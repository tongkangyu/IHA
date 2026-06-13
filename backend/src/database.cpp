#include "database.h"
#include <spdlog/spdlog.h>

Database& Database::instance() {
    static Database db;
    return db;
}

void Database::init(const DatabaseConfig& cfg) {
    config_ = cfg;
    pool_size_ = cfg.pool_size;

    for (int i = 0; i < pool_size_; ++i) {
        try {
            pool_.push(create_connection());
        } catch (sql::SQLException& e) {
            spdlog::error("Failed to create DB connection {}: {}", i, e.what());
            throw;
        }
    }
    spdlog::info("Database pool initialized with {} connections", pool_size_);
}

std::unique_ptr<sql::Connection> Database::create_connection() {
    sql::mysql::MySQL_Driver* driver = sql::mysql::get_mysql_driver_instance();
    std::string url = "tcp://" + config_.host + ":" + std::to_string(config_.port);
    std::unique_ptr<sql::Connection> conn(
        driver->connect(url, config_.user, config_.password));
    conn->setSchema(config_.schema);
    return conn;
}

std::unique_ptr<sql::Connection> Database::get_connection() {
    std::unique_lock<std::mutex> lock(mutex_);
    cv_.wait(lock, [this] { return !pool_.empty(); });
    auto conn = std::move(pool_.front());
    pool_.pop();

    try {
        if (conn->isClosed()) {
            conn = create_connection();
        }
    } catch (...) {
        conn = create_connection();
    }
    return conn;
}

void Database::return_connection(std::unique_ptr<sql::Connection> conn) {
    std::lock_guard<std::mutex> lock(mutex_);
    pool_.push(std::move(conn));
    cv_.notify_one();
}
