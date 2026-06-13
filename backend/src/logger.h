#pragma once

#include <spdlog/spdlog.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/sinks/rotating_file_sink.h>
#include <filesystem>

inline void init_logger() {
    std::filesystem::create_directories("logs");

    auto console_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
    console_sink->set_level(spdlog::level::debug);

    auto file_sink = std::make_shared<spdlog::sinks::rotating_file_sink_mt>(
        "logs/iha_server.log", 5 * 1024 * 1024, 3);
    file_sink->set_level(spdlog::level::info);

    auto logger = std::make_shared<spdlog::logger>("iha",
        spdlog::sinks_init_list{console_sink, file_sink});
    logger->set_level(spdlog::level::debug);
    logger->set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%^%l%$] [%n] %v");

    spdlog::set_default_logger(logger);
    spdlog::info("Logger initialized");
}
