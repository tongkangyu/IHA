#include "routes.h"
#include "database.h"
#include "middleware.h"
#include <spdlog/spdlog.h>
#include <openssl/rand.h>
#include <sstream>
#include <iomanip>

static std::string gen_record_id() {
    unsigned char bytes[16];
    RAND_bytes(bytes, sizeof(bytes));
    std::ostringstream ss;
    for (int i = 0; i < 16; ++i)
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)bytes[i];
    return ss.str();
}

void register_health_routes(crow::SimpleApp& app, const AppConfig& cfg) {

    CROW_ROUTE(app, "/api/health/data").methods("POST"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();

        auto body = crow::json::load(req.body);
        if (!body || !body.has("records")) {
            return crow::response(400, R"({"code":400,"message":"records array required"})");
        }

        try {
            ConnectionGuard conn(Database::instance());
            int count = 0;
            for (auto& r : body["records"]) {
                std::string metric_type = r.has("metric_type") ? std::string(r["metric_type"].s()) : "";
                double metric_value = r.has("metric_value") ? r["metric_value"].d() : 0;
                std::string collect_time = r.has("collect_time") ? std::string(r["collect_time"].s()) : "";
                std::string metric_unit = r.has("metric_unit") ? std::string(r["metric_unit"].s()) : "";
                std::string device_id = r.has("device_id") ? std::string(r["device_id"].s()) : "";
                int abnormal = r.has("abnormal_flag") ? (int)r["abnormal_flag"].i() : 0;

                if (metric_type.empty() || collect_time.empty()) continue;

                std::unique_ptr<sql::PreparedStatement> stmt(conn->prepareStatement(
                    "INSERT INTO t_health_record(record_id,user_id,device_id,metric_type,metric_value,metric_unit,collect_time,abnormal_flag)"
                    " VALUES(?,?,?,?,?,?,?,?)"));
                stmt->setString(1, gen_record_id());
                stmt->setString(2, auth.user_id);
                stmt->setString(3, device_id);
                stmt->setString(4, metric_type);
                stmt->setDouble(5, metric_value);
                stmt->setString(6, metric_unit);
                stmt->setString(7, collect_time);
                stmt->setInt(8, abnormal);
                stmt->executeUpdate();
                ++count;
            }

            crow::json::wvalue res;
            res["code"] = 200;
            res["message"] = "success";
            res["data"]["inserted"] = count;
            spdlog::info("Health data uploaded: user={} records={}", auth.user_id, count);
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Health upload DB error: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/health/dashboard").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();

        try {
            ConnectionGuard conn(Database::instance());

            std::unique_ptr<sql::PreparedStatement> stmt(conn->prepareStatement(
                "SELECT metric_type, metric_value, collect_time, abnormal_flag "
                "FROM t_health_record WHERE user_id=? AND deleted=0 "
                "ORDER BY collect_time DESC LIMIT 50"));
            stmt->setString(1, auth.user_id);
            std::unique_ptr<sql::ResultSet> rs(stmt->executeQuery());

            crow::json::wvalue::list records;
            int abnormal_count = 0;
            while (rs->next()) {
                crow::json::wvalue item;
                item["metric_type"] = rs->getString("metric_type");
                item["metric_value"] = static_cast<double>(rs->getDouble("metric_value"));
                item["collect_time"] = rs->getString("collect_time");
                item["abnormal_flag"] = rs->getInt("abnormal_flag");
                if (rs->getInt("abnormal_flag")) ++abnormal_count;
                records.push_back(std::move(item));
            }

            int health_score = std::max(0, 100 - abnormal_count * 5);

            std::unique_ptr<sql::PreparedStatement> env_stmt(conn->prepareStatement(
                "SELECT env_type, env_value, collect_time, location_tag "
                "FROM t_environment_record WHERE user_id=? AND deleted=0 "
                "ORDER BY collect_time DESC LIMIT 20"));
            env_stmt->setString(1, auth.user_id);
            std::unique_ptr<sql::ResultSet> env_rs(env_stmt->executeQuery());

            crow::json::wvalue::list env_records;
            while (env_rs->next()) {
                crow::json::wvalue item;
                item["env_type"] = env_rs->getString("env_type");
                item["env_value"] = static_cast<double>(env_rs->getDouble("env_value"));
                item["collect_time"] = env_rs->getString("collect_time");
                item["location_tag"] = env_rs->getString("location_tag");
                env_records.push_back(std::move(item));
            }

            crow::json::wvalue res;
            res["code"] = 200;
            res["data"]["health_score"] = health_score;
            res["data"]["health_records"] = std::move(records);
            res["data"]["environment_records"] = std::move(env_records);
            res["data"]["abnormal_count"] = abnormal_count;
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Dashboard DB error: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/health/recent").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();

        std::string metric_type = req.url_params.get("metric_type") ?
            req.url_params.get("metric_type") : "";
        int limit = req.url_params.get("limit") ?
            std::stoi(req.url_params.get("limit")) : 20;
        limit = std::min(limit, 100);

        try {
            ConnectionGuard conn(Database::instance());
            std::string sql = "SELECT record_id, metric_type, metric_value, metric_unit, "
                "collect_time, abnormal_flag FROM t_health_record "
                "WHERE user_id=? AND deleted=0";
            if (!metric_type.empty()) sql += " AND metric_type=?";
            sql += " ORDER BY collect_time DESC LIMIT ?";

            std::unique_ptr<sql::PreparedStatement> stmt(conn->prepareStatement(sql));
            int idx = 1;
            stmt->setString(idx++, auth.user_id);
            if (!metric_type.empty()) stmt->setString(idx++, metric_type);
            stmt->setInt(idx, limit);

            std::unique_ptr<sql::ResultSet> rs(stmt->executeQuery());
            crow::json::wvalue::list records;
            while (rs->next()) {
                crow::json::wvalue item;
                item["record_id"] = rs->getString("record_id");
                item["metric_type"] = rs->getString("metric_type");
                item["metric_value"] = static_cast<double>(rs->getDouble("metric_value"));
                item["metric_unit"] = rs->getString("metric_unit");
                item["collect_time"] = rs->getString("collect_time");
                item["abnormal_flag"] = rs->getInt("abnormal_flag");
                records.push_back(std::move(item));
            }

            crow::json::wvalue res;
            res["code"] = 200;
            res["data"] = std::move(records);
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Health recent DB error: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });
}
