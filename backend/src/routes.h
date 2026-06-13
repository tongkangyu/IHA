#pragma once

#include <crow.h>
#include "config.h"

void register_auth_routes(crow::SimpleApp& app, const AppConfig& cfg);
void register_health_routes(crow::SimpleApp& app, const AppConfig& cfg);
void register_user_routes(crow::SimpleApp& app, const AppConfig& cfg);
void register_report_routes(crow::SimpleApp& app, const AppConfig& cfg);
void register_stub_routes(crow::SimpleApp& app);
void register_feature_routes(crow::SimpleApp& app, const AppConfig& cfg);
