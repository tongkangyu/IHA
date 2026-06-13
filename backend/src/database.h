#pragma once

#include <string>
#include <memory>
#include <queue>
#include <mutex>
#include <condition_variable>
#include <mysql_driver.h>
#include <mysql_connection.h>
#include <cppconn/prepared_statement.h>
#include <cppconn/resultset.h>
#include <cppconn/exception.h>
#include "config.h"

class Database {
public:
    static Database& instance();
    void init(const DatabaseConfig& cfg);
    std::unique_ptr<sql::Connection> get_connection();
    void return_connection(std::unique_ptr<sql::Connection> conn);

private:
    Database() = default;
    std::queue<std::unique_ptr<sql::Connection>> pool_;
    std::mutex mutex_;
    std::condition_variable cv_;
    DatabaseConfig config_;
    int pool_size_ = 0;

    std::unique_ptr<sql::Connection> create_connection();
};

class ConnectionGuard {
public:
    explicit ConnectionGuard(Database& db) : db_(db), conn_(db.get_connection()) {}
    ~ConnectionGuard() { if (conn_) db_.return_connection(std::move(conn_)); }
    sql::Connection* operator->() { return conn_.get(); }
    sql::Connection* get() { return conn_.get(); }

private:
    Database& db_;
    std::unique_ptr<sql::Connection> conn_;
};
