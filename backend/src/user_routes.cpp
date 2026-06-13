#include "routes.h"
#include "database.h"
#include "middleware.h"
#include <spdlog/spdlog.h>

void register_user_routes(crow::SimpleApp& app, const AppConfig& cfg) {

    CROW_ROUTE(app, "/api/user/info").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();

        try {
            ConnectionGuard conn(Database::instance());
            std::unique_ptr<sql::PreparedStatement> stmt(conn->prepareStatement(
                "SELECT user_id, mobile, nickname, role, avatar_url, gender, birthday, height "
                "FROM t_user WHERE user_id=? AND deleted=0"));
            stmt->setString(1, auth.user_id);
            std::unique_ptr<sql::ResultSet> rs(stmt->executeQuery());

            if (!rs->next()) {
                return crow::response(404, R"({"code":404,"message":"user not found"})");
            }

            crow::json::wvalue res;
            res["code"] = 200;
            res["data"]["user_id"] = rs->getString("user_id");
            res["data"]["mobile"] = rs->getString("mobile");
            res["data"]["nickname"] = rs->getString("nickname");
            res["data"]["role"] = rs->getString("role");
            res["data"]["avatar_url"] = rs->getString("avatar_url");
            res["data"]["gender"] = rs->getString("gender");
            res["data"]["birthday"] = rs->getString("birthday");
            res["data"]["height"] = rs->getInt("height");
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("User info GET error: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/user/info").methods("PUT"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();

        auto body = crow::json::load(req.body);
        if (!body) {
            return crow::response(400, R"({"code":400,"message":"invalid json"})");
        }

        try {
            ConnectionGuard conn(Database::instance());
            std::string sql = "UPDATE t_user SET update_time=NOW()";
            if (body.has("nickname")) sql += ", nickname=?";
            if (body.has("gender")) sql += ", gender=?";
            if (body.has("birthday")) sql += ", birthday=?";
            if (body.has("height")) sql += ", height=?";
            if (body.has("avatar_url")) sql += ", avatar_url=?";
            sql += " WHERE user_id=? AND deleted=0";

            std::unique_ptr<sql::PreparedStatement> stmt(conn->prepareStatement(sql));
            int idx = 1;
            if (body.has("nickname")) stmt->setString(idx++, std::string(body["nickname"].s()));
            if (body.has("gender")) stmt->setString(idx++, std::string(body["gender"].s()));
            if (body.has("birthday")) stmt->setString(idx++, std::string(body["birthday"].s()));
            if (body.has("height")) stmt->setInt(idx++, (int)body["height"].i());
            if (body.has("avatar_url")) stmt->setString(idx++, std::string(body["avatar_url"].s()));
            stmt->setString(idx, auth.user_id);
            stmt->executeUpdate();

            crow::json::wvalue res;
            res["code"] = 200;
            res["message"] = "success";
            spdlog::info("User info updated: {}", auth.user_id);
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("User info PUT error: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });
}
