#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "AIService.h"
#include "HealthDataManager.h"

int main(int argc, char *argv[])
{
    // 使用系统默认输入法
    // qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    
    // 创建服务实例（在engine之后）
    AIService *aiService = new AIService(&app);
    HealthDataManager *healthDataManager = new HealthDataManager(&app);
    
    // 注册服务到QML上下文
    engine.rootContext()->setContextProperty("aiService", aiService);
    engine.rootContext()->setContextProperty("healthDataManager", healthDataManager);
    
    // 注册版本号到QML
    engine.rootContext()->setContextProperty("appVersion", QStringLiteral(APP_VERSION));
    
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
