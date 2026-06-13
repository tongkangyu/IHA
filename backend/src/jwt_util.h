#pragma once

#include <string>
#include "config.h"

std::string create_token(const std::string& user_id, const std::string& mobile,
                         const std::string& role, const JwtConfig& cfg);

struct TokenPayload {
    std::string user_id;
    std::string mobile;
    std::string role;
    bool valid = false;
};

TokenPayload verify_token(const std::string& token, const JwtConfig& cfg);
