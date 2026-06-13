#include "jwt_util.h"
#include <jwt-cpp/jwt.h>
#include <spdlog/spdlog.h>

std::string create_token(const std::string& user_id, const std::string& mobile,
                         const std::string& role, const JwtConfig& cfg) {
    auto token = jwt::create()
        .set_issuer("iha-server")
        .set_subject(user_id)
        .set_payload_claim("mobile", jwt::claim(mobile))
        .set_payload_claim("role", jwt::claim(role))
        .set_issued_at(std::chrono::system_clock::now())
        .set_expires_at(std::chrono::system_clock::now() + std::chrono::hours(cfg.expire_hours))
        .sign(jwt::algorithm::hs256{cfg.secret});
    return token;
}

TokenPayload verify_token(const std::string& token, const JwtConfig& cfg) {
    TokenPayload payload;
    try {
        auto decoded = jwt::decode(token);
        auto verifier = jwt::verify()
            .allow_algorithm(jwt::algorithm::hs256{cfg.secret})
            .with_issuer("iha-server");
        verifier.verify(decoded);

        payload.user_id = decoded.get_subject();
        payload.mobile = decoded.get_payload_claim("mobile").as_string();
        payload.role = decoded.get_payload_claim("role").as_string();
        payload.valid = true;
    } catch (const std::exception& e) {
        spdlog::warn("JWT verification failed: {}", e.what());
    }
    return payload;
}
