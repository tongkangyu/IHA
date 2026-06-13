#pragma once

#include <string>
#include <fstream>
#include <nlohmann/json.hpp>

struct ServerConfig {
    int port = 8080;
    int threads = 4;
};

struct DatabaseConfig {
    std::string host = "127.0.0.1";
    int port = 3306;
    std::string user = "root";
    std::string password;
    std::string schema = "health_db";
    int pool_size = 10;
};

struct JwtConfig {
    std::string secret = "default-secret";
    int expire_hours = 24;
};

struct AiConfig {
    std::string api_url;
    std::string api_key;
    std::string model = "deepseek-v4-flash";
};

struct AppConfig {
    ServerConfig server;
    DatabaseConfig database;
    JwtConfig jwt;
    AiConfig ai;
};

inline AppConfig load_config(const std::string& path) {
    AppConfig cfg;
    std::ifstream f(path);
    if (!f.is_open()) return cfg;

    nlohmann::json j;
    f >> j;

    if (j.contains("server")) {
        auto& s = j["server"];
        if (s.contains("port")) cfg.server.port = s["port"];
        if (s.contains("threads")) cfg.server.threads = s["threads"];
    }
    if (j.contains("database")) {
        auto& d = j["database"];
        if (d.contains("host")) cfg.database.host = d["host"];
        if (d.contains("port")) cfg.database.port = d["port"];
        if (d.contains("user")) cfg.database.user = d["user"];
        if (d.contains("password")) cfg.database.password = d["password"];
        if (d.contains("schema")) cfg.database.schema = d["schema"];
        if (d.contains("pool_size")) cfg.database.pool_size = d["pool_size"];
    }
    if (j.contains("jwt")) {
        auto& jw = j["jwt"];
        if (jw.contains("secret")) cfg.jwt.secret = jw["secret"];
        if (jw.contains("expire_hours")) cfg.jwt.expire_hours = jw["expire_hours"];
    }
    if (j.contains("ai")) {
        auto& a = j["ai"];
        if (a.contains("api_url")) cfg.ai.api_url = a["api_url"];
        if (a.contains("api_key")) cfg.ai.api_key = a["api_key"];
        if (a.contains("model")) cfg.ai.model = a["model"];
    }
    return cfg;
}
