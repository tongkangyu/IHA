#include <crow.h>
#include <spdlog/spdlog.h>
#include "config.h"
#include "logger.h"
#include "database.h"
#include "routes.h"

int main(int argc, char* argv[]) {
    init_logger();

    std::string config_path = "config.json";
    if (argc > 1) config_path = argv[1];

    spdlog::info("Loading config from: {}", config_path);
    AppConfig cfg = load_config(config_path);

    spdlog::info("Connecting to database {}:{}/{}", cfg.database.host, cfg.database.port, cfg.database.schema);
    try {
        Database::instance().init(cfg.database);
    } catch (const std::exception& e) {
        spdlog::critical("Database init failed: {}", e.what());
        return 1;
    }

    crow::SimpleApp app;

    CROW_ROUTE(app, "/api/ping")([] {
        return crow::response(200, R"({"code":200,"message":"pong"})");
    });

    register_auth_routes(app, cfg);
    register_health_routes(app, cfg);
    register_user_routes(app, cfg);
    register_report_routes(app, cfg);
    register_stub_routes(app);
    register_feature_routes(app, cfg);

    spdlog::info("Starting IHA server on port {} with {} threads", cfg.server.port, cfg.server.threads);
    app.port(cfg.server.port)
       .concurrency(cfg.server.threads)
       .run();

    return 0;
}
