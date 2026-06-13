cmake_minimum_required(VERSION 3.14)
project(iha_server VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW)
endif()
if(POLICY CMP0167)
    cmake_policy(SET CMP0167 OLD)
endif()

set(DEPS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps)

include(FetchContent)

FetchContent_Declare(nlohmann_json URL ${DEPS_DIR}/json.tar.gz)
FetchContent_Declare(Crow URL ${DEPS_DIR}/crow.tar.gz)
FetchContent_Declare(jwt-cpp URL ${DEPS_DIR}/jwt.tar.gz)
FetchContent_Declare(spdlog URL ${DEPS_DIR}/spdlog.tar.gz)
FetchContent_Declare(httplib URL ${DEPS_DIR}/httplib.tar.gz)

set(CROW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(CROW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(CROW_USE_BOOST ON CACHE BOOL "" FORCE)
set(JWT_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(SPDLOG_BUILD_EXAMPLE OFF CACHE BOOL "" FORCE)
set(HTTPLIB_COMPILE OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(nlohmann_json Crow jwt-cpp spdlog httplib)

find_package(OpenSSL REQUIRED)
find_package(Boost REQUIRED COMPONENTS system)

find_path(MYSQLCPPCONN_INCLUDE_DIR
    NAMES mysql_connection.h
    PATHS /usr/include /usr/local/include
)
find_library(MYSQLCPPCONN_LIBRARY
    NAMES mysqlcppconn
    PATHS /usr/lib /usr/lib/x86_64-linux-gnu /usr/local/lib
)

if(NOT MYSQLCPPCONN_INCLUDE_DIR OR NOT MYSQLCPPCONN_LIBRARY)
    message(FATAL_ERROR "MySQL Connector/C++ not found. Install: sudo apt install libmysqlcppconn-dev")
endif()

add_executable(iha_server
    src/main.cpp
    src/database.cpp
    src/jwt_util.cpp
    src/auth_routes.cpp
    src/health_routes.cpp
    src/user_routes.cpp
    src/report_routes.cpp
    src/stub_routes.cpp
    src/feature_routes.cpp
)

target_include_directories(iha_server PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${MYSQLCPPCONN_INCLUDE_DIR}
)

target_link_libraries(iha_server PRIVATE
    Crow::Crow
    spdlog::spdlog
    nlohmann_json::nlohmann_json
    jwt-cpp::jwt-cpp
    httplib::httplib
    OpenSSL::SSL
    OpenSSL::Crypto
    Boost::system
    ${MYSQLCPPCONN_LIBRARY}
    pthread
)
