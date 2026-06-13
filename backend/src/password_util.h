#pragma once

#include <string>
#include <random>
#include <sstream>
#include <iomanip>
#include <openssl/sha.h>
#include <openssl/rand.h>

inline std::string bytes_to_hex(const unsigned char* data, size_t len) {
    std::ostringstream ss;
    for (size_t i = 0; i < len; ++i)
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)data[i];
    return ss.str();
}

inline std::string hash_password(const std::string& password) {
    unsigned char salt[16];
    RAND_bytes(salt, sizeof(salt));
    std::string salt_hex = bytes_to_hex(salt, sizeof(salt));

    std::string salted = salt_hex + password;
    unsigned char hash[SHA256_DIGEST_LENGTH];
    SHA256(reinterpret_cast<const unsigned char*>(salted.c_str()), salted.size(), hash);

    return salt_hex + ":" + bytes_to_hex(hash, SHA256_DIGEST_LENGTH);
}

inline bool verify_password(const std::string& password, const std::string& stored) {
    auto colon = stored.find(':');
    if (colon == std::string::npos) return false;

    std::string salt_hex = stored.substr(0, colon);
    std::string expected_hash = stored.substr(colon + 1);

    std::string salted = salt_hex + password;
    unsigned char hash[SHA256_DIGEST_LENGTH];
    SHA256(reinterpret_cast<const unsigned char*>(salted.c_str()), salted.size(), hash);

    return bytes_to_hex(hash, SHA256_DIGEST_LENGTH) == expected_hash;
}
