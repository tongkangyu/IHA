#include "routes.h"
#include "database.h"
#include "middleware.h"
#include <spdlog/spdlog.h>
#include <openssl/rand.h>
#include <sstream>
#include <iomanip>

static std::string gid() {
    unsigned char b[16];
    RAND_bytes(b, sizeof(b));
    std::ostringstream s;
    for (int i = 0; i < 16; ++i) s << std::hex << std::setw(2) << std::setfill('0') << (int)b[i];
    return s.str();
}

static crow::json::wvalue query_list(const std::string& sql, const std::string& user_id,
    const std::vector<std::string>& fields) {
    ConnectionGuard conn(Database::instance());
    std::unique_ptr<sql::PreparedStatement> stmt(conn->prepareStatement(sql));
    stmt->setString(1, user_id);
    std::unique_ptr<sql::ResultSet> rs(stmt->executeQuery());

    crow::json::wvalue::list items;
    while (rs->next()) {
        crow::json::wvalue item;
        for (auto& f : fields) {
            try { item[f] = rs->getString(f); } catch (...) {
                try { item[f] = rs->getInt(f); } catch (...) {
                    try { item[f] = static_cast<double>(rs->getDouble(f)); } catch (...) { item[f] = ""; }
                }
            }
        }
        items.push_back(std::move(item));
    }
    crow::json::wvalue res;
    res["code"] = 200;
    res["data"] = std::move(items);
    return res;
}

void register_feature_routes(crow::SimpleApp& app, const AppConfig& cfg) {

    CROW_ROUTE(app, "/api/habits").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();
        try {
            auto res = query_list(
                "SELECT habit_id,name,icon,frequency,streak,completed_today,target_time FROM t_habit WHERE user_id=? AND deleted=0",
                auth.user_id, {"habit_id","name","icon","frequency","streak","completed_today","target_time"});
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Habits GET: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/habits").methods("POST"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();
        auto body = crow::json::load(req.body);
        if (!body) return crow::response(400, R"({"code":400,"message":"invalid json"})");

        try {
            ConnectionGuard conn(Database::instance());
            if (body.has("habit_id") && body.has("action")) {
                std::string action = body["action"].s();
                std::string id = body["habit_id"].s();
                if (action == "toggle") {
                    std::unique_ptr<sql::PreparedStatement> s(conn->prepareStatement(
                        "UPDATE t_habit SET completed_today = IF(completed_today=0,1,0), streak = IF(completed_today=0,streak+1,streak-1) WHERE habit_id=? AND user_id=?"));
                    s->setString(1, id); s->setString(2, auth.user_id); s->executeUpdate();
                }
            } else if (body.has("name")) {
                std::unique_ptr<sql::PreparedStatement> s(conn->prepareStatement(
                    "INSERT INTO t_habit(habit_id,user_id,name,icon,target_time) VALUES(?,?,?,?,?)"));
                s->setString(1, gid()); s->setString(2, auth.user_id);
                s->setString(3, std::string(body["name"].s()));
                s->setString(4, body.has("icon") ? std::string(body["icon"].s()) : "H");
                s->setString(5, body.has("target_time") ? std::string(body["target_time"].s()) : "08:00");
                s->executeUpdate();
            }
            crow::json::wvalue res; res["code"] = 200; res["message"] = "success";
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Habits POST: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/badges").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();
        try {
            auto res = query_list(
                "SELECT badge_id,name,description,icon,status,progress,target FROM t_badge WHERE user_id=?",
                auth.user_id, {"badge_id","name","description","icon","status","progress","target"});
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Badges GET: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/challenges").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();
        try {
            auto res = query_list(
                "SELECT challenge_id,name,description,status,progress,target,days_remaining FROM t_challenge WHERE user_id=?",
                auth.user_id, {"challenge_id","name","description","status","progress","target","days_remaining"});
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Challenges GET: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/courses").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();
        try {
            auto res = query_list(
                "SELECT course_id,name,category,total_lessons,completed_lessons,status FROM t_course WHERE user_id=?",
                auth.user_id, {"course_id","name","category","total_lessons","completed_lessons","status"});
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Courses GET: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/orders").methods("GET"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();
        try {
            auto res = query_list(
                "SELECT order_id,product_name,price,status,create_time FROM t_order WHERE user_id=?",
                auth.user_id, {"order_id","product_name","price","status","create_time"});
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Orders GET: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });

    CROW_ROUTE(app, "/api/init-sample-data").methods("POST"_method)
    ([&cfg](const crow::request& req) {
        auto auth = authenticate(req, cfg.jwt);
        if (!auth.valid) return unauthorized();
        try {
            ConnectionGuard conn(Database::instance());
            std::string uid = auth.user_id;

            auto exec = [&](const std::string& sql) {
                std::unique_ptr<sql::PreparedStatement> s(conn->prepareStatement(sql));
                s->executeUpdate();
            };

            exec("DELETE FROM t_habit WHERE user_id='" + uid + "'");
            exec("DELETE FROM t_badge WHERE user_id='" + uid + "'");
            exec("DELETE FROM t_challenge WHERE user_id='" + uid + "'");
            exec("DELETE FROM t_course WHERE user_id='" + uid + "'");
            exec("DELETE FROM t_order WHERE user_id='" + uid + "'");

            auto ins = [&](const std::string& sql) {
                std::unique_ptr<sql::PreparedStatement> s(conn->prepareStatement(sql));
                s->executeUpdate();
            };

            ins("INSERT INTO t_habit VALUES('" + gid() + "','" + uid + "','早起打卡','R','DAILY',15,1,'06:30',NOW(),0)");
            ins("INSERT INTO t_habit VALUES('" + gid() + "','" + uid + "','喝水8杯','W','DAILY',22,0,'08:00',NOW(),0)");
            ins("INSERT INTO t_habit VALUES('" + gid() + "','" + uid + "','冥想10分钟','M','DAILY',8,1,'07:00',NOW(),0)");
            ins("INSERT INTO t_habit VALUES('" + gid() + "','" + uid + "','跑步30分钟','S','DAILY',5,0,'18:00',NOW(),0)");
            ins("INSERT INTO t_habit VALUES('" + gid() + "','" + uid + "','阅读30分钟','B','DAILY',12,1,'21:00',NOW(),0)");

            ins("INSERT INTO t_badge VALUES('" + gid() + "','" + uid + "','千步达人','累计步数达到10000步','S','EARNED',100,100,NOW())");
            ins("INSERT INTO t_badge VALUES('" + gid() + "','" + uid + "','早起鸟儿','连续7天早起打卡','R','EARNED',100,100,NOW())");
            ins("INSERT INTO t_badge VALUES('" + gid() + "','" + uid + "','健康之星','健康评分保持90+一周','H','EARNED',100,100,NOW())");
            ins("INSERT INTO t_badge VALUES('" + gid() + "','" + uid + "','跑步达人','累计跑步100公里','S','IN_PROGRESS',65,100,NULL)");
            ins("INSERT INTO t_badge VALUES('" + gid() + "','" + uid + "','冥想大师','连续30天冥想','M','IN_PROGRESS',40,100,NULL)");
            ins("INSERT INTO t_badge VALUES('" + gid() + "','" + uid + "','社交之星','健康圈互动100次','F','LOCKED',0,100,NULL)");

            ins("INSERT INTO t_challenge VALUES('" + gid() + "','" + uid + "','30天步行挑战','每天步行8000步以上','ACTIVE',72,100,9,NOW())");
            ins("INSERT INTO t_challenge VALUES('" + gid() + "','" + uid + "','睡眠改善计划','连续早睡早起21天','ACTIVE',45,100,12,NOW())");
            ins("INSERT INTO t_challenge VALUES('" + gid() + "','" + uid + "','减脂训练营','完成20次HIIT训练','COMPLETED',100,100,0,NOW())");

            ins("INSERT INTO t_course VALUES('" + gid() + "','" + uid + "','健康饮食入门','nutrition',12,8,'ACTIVE',NOW())");
            ins("INSERT INTO t_course VALUES('" + gid() + "','" + uid + "','瑜伽基础课程','fitness',20,20,'COMPLETED',NOW())");
            ins("INSERT INTO t_course VALUES('" + gid() + "','" + uid + "','正念冥想指南','mindfulness',15,6,'ACTIVE',NOW())");

            ins("INSERT INTO t_order VALUES('" + gid() + "','" + uid + "','智能运动手表',1299.00,'COMPLETED',NOW())");
            ins("INSERT INTO t_order VALUES('" + gid() + "','" + uid + "','无线运动耳机',299.00,'SHIPPED',NOW())");
            ins("INSERT INTO t_order VALUES('" + gid() + "','" + uid + "','瑜伽垫',99.00,'COMPLETED',NOW())");

            spdlog::info("Sample data initialized for user: {}", uid);
            crow::json::wvalue res; res["code"] = 200; res["message"] = "sample data created";
            return crow::response(200, res);
        } catch (sql::SQLException& e) {
            spdlog::error("Init sample data: {}", e.what());
            return crow::response(500, R"({"code":500,"message":"internal error"})");
        }
    });
}
