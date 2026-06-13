#pragma once

#include <string>
#include <crow.h>
#include "jwt_util.h"
#include "config.h"

inline TokenPayload authenticate(const crow::request& req, const JwtConfig& cfg) {
    TokenPayload empty;
    std::string auth = req.get_header_value("Authorization");
    if (auth.empty() || auth.substr(0, 7) != "Bearer ") return empty;
    return verify_token(auth.substr(7), cfg);
}

inline crow::response unauthorized() {
    crow::json::wvalue res;
    res["code"] = 401;
    res["message"] = "Unauthorized";
    return crow::response(401, res);
}
