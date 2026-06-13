#include "routes.h"
#include "database.h"
#include "middleware.h"
#include <spdlog/spdlog.h>
#include <httplib.h>
#include <nlohmann/json.hpp>
#include <openssl/rand.h>
#include <sstream>
#include <iomanip>

static std::string gen_id() {
    unsigned char bytes[16];
    RAND_bytes(bytes, sizeof(bytes));
    std::ostringstream ss;
    for (int i = 0; i < 16; ++i)
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)bytes[i];
    return ss.str();
}

static std::string call_ai_for_report(const std::string& health_summary, const AppConfig& cfg) {
    if (cfg.ai.api_url.empty() || cfg.ai.api_key.empty()) {
        return "AI service not configured.";
    }

    std::string host, path;
    bool use_ssl = false;
    std::string url = cfg.ai.api_url;
    if (url.substr(0, 8) == "https://") {
        use_ssl = true;
        url = url.substr(8);
    } else if (url.substr(0, 7) == "http://") {
        url = url.substr(7);
    }
    auto slash_pos = url.find('/');
    if (slash_pos != std::string::npos) {
        host = url.substr(0, slash_pos);
        path = url.substr(slash_pos);
    } else {
        host = url;
        path = "/v1/chat/completions";
    }

    nlohmann::json req_body;
    req_body["model"] = cfg.ai.model;
    req_body["messages"] = nlohmann::json::array({
        {{"role", "system"}, {"content",
            "You are a health analyst. Generate a concise weekly health report in Chinese based on the following data. "
            "Include: overall assessment, key metrics summary, trends, and 2-3 actionable suggestions."}},
        {{"role", "user"}, {"content", health_summary}}
    });
    req_body["temperature"] = 0.7;

    std::string response_text;
    try {
        if (use_ssl) {
            httplib::SSLClient cli(host);
            cli.set_connection_timeout(30);
            cli.set_read_timeout(60);
            auto res = cli.Post(path, {{"Authorization", "Bearer " + cfg.ai.api_key},
                                       {"Content-Type", "application/json"}},
                                req_body.dump(), "application/json");
            if (res && res->status == 200) {
                auto j = nlohmann::json::parse(res->body);
                response_text = j["choices"][0]["message"]["content"];
            } else {
                spdlog::error("AI API failed: status={}", res ? res->status : -1);
                response_text = "Weekly report generation failed.";
            }
        } else {
            httplib::Client cli(host);
            cli.set_connection_timeout(30);
            cli.set_read_timeout(60);
            auto res = cli.Post(path, {{"Authorization", "Bearer " + cfg.ai.api_key},
                                       {"Content-Type", "application/json"}},
                                req_body.dump(), "application/json");
            if (res && res->status == 200) {
                auto j = nlohmann::json::parse(res->body);
                response_text = j["choices"][0]["message"]["content"];
            } else {
                response_text = "Weekly report generation failed.";
            }
        }
    } catch (const std::exception& e) {
        spdlog::error("AI API exception: {}", e.what());
        response_text = "AI service error.";
    }
    return response_text;
}

void register_report_routes(crow::SimpleApp& app, const AppConfig& cfg) {

    CROW_ROUTE(app, "/api/report/weekly").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();

        try {
            ConnectionGuard conn(Database::instance());

            std::unique_ptr<sql::PreparedStatement> check(conn->prepareStatement(
                "SELECT report_id, summary_json, insight_text, week_start, week_end, create_time "
                "FROM t_weekly_report WHERE user_id=? AND deleted=0 "
                "AND week_start >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) "
                "ORDER BY create_time DESC LIMIT 1"));
            check->setString(1, auth.user_id);
            std::unique_ptr<sql::ResultSet> existing(check->executeQuery());

            if (existing->next()) {
                crow::json::wvalue res;
                res["code"] = 200;
                res["data"]["report_id"] = existing->getString("report_id");
                res["data"]["summary_json"] = existing->getString("summary_json");
                res["data"]["insight_text"] = existing->getString("insight_text");
                res["data"]["week_start"] = existing->getString("week_start");
                res["data"]["week_end"] = existing->getString("week_end");
                return crow::response(200, res);
            }

            std::unique_ptr<sql::PreparedStatement> data_stmt(conn->prepareStatement(
                "SELECT metric_type, metric_value, collect_time, abnormal_flag "
                "FROM t_health_record WHERE user_id=? AND deleted=0 "
                "AND collect_time >= DATE_SUB(NOW(), INTERVAL 7 DAY) "
                "ORDER BY collect_time"));
            data_stmt->setString(1, auth.user_id);
            std::unique_ptr<sql::ResultSet> data_rs(data_stmt->executeQuery());

            nlohmann::json summary_data;
            summary_data["records"] = nlohmann::json::array();
            while (data_rs->next()) {
                nlohmann::json rec;
                rec["type"] = data_rs->getString("metric_type");
                rec["value"] = data_rs->getDouble("metric_value");
                rec["time"] = data_rs->getString("collect_time");
                rec["abnormal"] = data_rs->getInt("abnormal_flag");
                summary_data["records"].push_back(rec);
            }

            std::string health_summary = summary_data.dump();
            std::string insight = call_ai_for_report(health_summary, cfg);

            std::string report_id = gen_id();
            std::unique_ptr<sql::PreparedStatement> insert(conn->prepareStatement(
                "INSERT INTO t_weekly_report(report_id, user_id, week_start, week_end, summary_json, insight_text) "
                "VALUES(?, ?, DATE_SUB(CURDATE(), INTERVAL 7 DAY), CURDATE(), ?, ?)"));
            insert->setString(1, report_id);
            insert->setString(2, auth.user_id);
            insert->setString(3, health_summary);
            insert->setString(4, insight);
            insert->executeUpdate();

            crow::json::wvalue res;
            res["code"] = 200;
            res["data"]["report_id"] = report_id;
            res["data"]["summary_json"] = health_summary;
            res["data"]["insight_text"] = insight;
            spdlog::info("Weekly report generated for user: {}", auth.user_id);
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Report DB error: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });
}
