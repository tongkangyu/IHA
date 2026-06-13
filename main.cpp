#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include "AIService.h"
#include "HealthDataManager.h"
#include "UserService.h"
#include "DeviceManager.h"
#include "HealthCircleManager.h"
#include "MedicalService.h"
#include "config.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("IHA");
    app.setApplicationName("SmartHealth");

    QSettings settings;
    bool savedDarkMode = settings.value("darkMode", true).toBool();

    QQmlApplicationEngine engine;

    AIService *aiService = new AIService(&app);
    HealthDataManager *healthDataManager = new HealthDataManager(&app);
    UserService *userService = new UserService(&app);
    DeviceManager *deviceManager = new DeviceManager(&app);
    HealthCircleManager *healthCircleManager = new HealthCircleManager(&app);
    MedicalService *medicalService = new MedicalService(&app);

    engine.rootContext()->setContextProperty("aiService", aiService);
    engine.rootContext()->setContextProperty("healthDataManager", healthDataManager);
    engine.rootContext()->setContextProperty("userService", userService);
    engine.rootContext()->setContextProperty("deviceManager", deviceManager);
    engine.rootContext()->setContextProperty("healthCircleManager", healthCircleManager);
    engine.rootContext()->setContextProperty("medicalService", medicalService);
    engine.rootContext()->setContextProperty("appVersion", QStringLiteral(APP_VERSION));
    engine.rootContext()->setContextProperty("savedDarkMode", savedDarkMode);
    engine.rootContext()->setContextProperty("apiBaseUrl", QStringLiteral(USER_API_URL));

    const QUrl url(QStringLiteral("qrc:/qt/qml/IHA/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
