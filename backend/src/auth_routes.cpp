#include "routes.h"
#include "database.h"
#include "password_util.h"
#include "jwt_util.h"
#include <spdlog/spdlog.h>
#include <random>
#include <sstream>
#include <iomanip>

static std::string generate_id() {
    unsigned char bytes[16];
    RAND_bytes(bytes, sizeof(bytes));
    std::ostringstream ss;
    for (int i = 0; i < 16; ++i)
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)bytes[i];
    return ss.str();
}

void register_auth_routes(crow::SimpleApp& app, const AppConfig& cfg) {

    CROW_ROUTE(app, "/api/auth/register").methods("POST"_method)
    ([&cfg](const crow::request& req) {
        auto body = crow::json::load(req.body);
        if (!body || !body.has("mobile") || !body.has("password")) {
            return crow::response(400, R"({"code":400,"message":"mobile and password required"})");
        }

        std::string mobile = body["mobile"].s();
        std::string password = body["password"].s();
        std::string nickname = body.has("nickname") ? std::string(body["nickname"].s()) : "";

        if (mobile.size() < 11 || password.size() < 6) {
            return crow::response(400, R"({"code":400,"message":"invalid mobile or password too short"})");
        }

        try {
            ConnectionGuard conn(Database::instance());
            std::unique_ptr<sql::PreparedStatement> check(
                conn->prepareStatement("SELECT user_id FROM t_user WHERE mobile=? AND deleted=0"));
            check->setString(1, mobile);
            std::unique_ptr<sql::ResultSet> rs(check->executeQuery());
            if (rs->next()) {
                return crow::response(409, R"({"code":409,"message":"mobile already registered"})");
            }

            std::string user_id = generate_id();
            std::string hash = hash_password(password);

            std::unique_ptr<sql::PreparedStatement> stmt(
                conn->prepareStatement(
                    "INSERT INTO t_user(user_id, mobile, password_hash, nickname, role) VALUES(?,?,?,?,?)"));
            stmt->setString(1, user_id);
            stmt->setString(2, mobile);
            stmt->setString(3, hash);
            stmt->setString(4, nickname);
            stmt->setString(5, "USER");
            stmt->executeUpdate();

            std::string token = create_token(user_id, mobile, "USER", cfg.jwt);

            crow::json::wvalue res;
            res["code"] = 200;
            res["message"] = "success";
            res["data"]["token"] = token;
            res["data"]["user_id"] = user_id;
            res["data"]["mobile"] = mobile;
            res["data"]["nickname"] = nickname;
            spdlog::info("User registered: {} {}", user_id, mobile);
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Register DB error: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/auth/login").methods("POST"_method)
    ([&cfg](const crow::request& req) {
        auto body = crow::json::load(req.body);
        if (!body || !body.has("mobile") || !body.has("password")) {
            return crow::response(400, R"({"code":400,"message":"mobile and password required"})");
        }

        std::string mobile = body["mobile"].s();
        std::string password = body["password"].s();

        try {
            ConnectionGuard conn(Database::instance());
            std::unique_ptr<sql::PreparedStatement> stmt(
                conn->prepareStatement(
                    "SELECT user_id, password_hash, nickname, role, status FROM t_user WHERE mobile=? AND deleted=0"));
            stmt->setString(1, mobile);
            std::unique_ptr<sql::ResultSet> rs(stmt->executeQuery());

            if (!rs->next()) {
                return crow::response(401, R"({"code":401,"message":"account not found"})");
            }

            int status = rs->getInt("status");
            if (status != 1) {
                return crow::response(403, R"({"code":403,"message":"account disabled"})");
            }

            std::string stored_hash = rs->getString("password_hash");
            if (!verify_password(password, stored_hash)) {
                return crow::response(401, R"({"code":401,"message":"wrong password"})");
            }

            std::string user_id = rs->getString("user_id");
            std::string nickname = rs->getString("nickname");
            std::string role = rs->getString("role");

            std::string token = create_token(user_id, mobile, role, cfg.jwt);

            crow::json::wvalue res;
            res["code"] = 200;
            res["message"] = "success";
            res["data"]["token"] = token;
            res["data"]["user_id"] = user_id;
            res["data"]["mobile"] = mobile;
            res["data"]["nickname"] = nickname;
            res["data"]["role"] = role;
            spdlog::info("User login: {} {}", user_id, mobile);
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Login DB error: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });
}
