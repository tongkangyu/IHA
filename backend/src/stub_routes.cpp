#include "routes.h"
#include <spdlog/spdlog.h>

void register_stub_routes(crow::SimpleApp& app) {
    auto stub_handler = [](const crow::request& req) {
        spdlog::debug("Stub route hit: {} {}", crow::method_name(req.method), req.url);
        crow::json::wvalue res;
        res["code"] = 501;
        res["message"] = "Not implemented yet";
        return crow::response(501, res);
    };

    CROW_ROUTE(app, "/api/device/list").methods("GET"_method)(stub_handler);
    CROW_ROUTE(app, "/api/device/bind").methods("POST"_method)(stub_handler);
    CROW_ROUTE(app, "/api/device/unbind").methods("POST"_method)(stub_handler);
    CROW_ROUTE(app, "/api/device/<string>/command").methods("POST"_method)
    ([](const crow::request&, const std::string&) {
        crow::json::wvalue res;
        res["code"] = 501;
        res["message"] = "Not implemented yet";
        return crow::response(501, res);
    });

    CROW_ROUTE(app, "/api/authorization/list").methods("GET"_method)(stub_handler);
    CROW_ROUTE(app, "/api/authorization/save").methods("POST"_method)(stub_handler);
    CROW_ROUTE(app, "/api/authorization/revoke").methods("POST"_method)(stub_handler);

    CROW_ROUTE(app, "/api/consultation/create").methods("POST"_method)(stub_handler);
    CROW_ROUTE(app, "/api/consultation/list").methods("GET"_method)(stub_handler);
    CROW_ROUTE(app, "/api/consultation/reply").methods("POST"_method)(stub_handler);
}
