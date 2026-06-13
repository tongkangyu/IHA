#include "HealthDataManager.h"
#include "config.h"
#include <QDebug>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QDateTime>

HealthDataManager::HealthDataManager(QObject *parent)
    : QObject(parent)
    , m_currentDate(QDate::currentDate())
    , m_lastSavedDate(QDate::currentDate())
    , m_networkManager(new QNetworkAccessManager(this))
    , m_apiBaseUrl(USER_API_URL)
{
    // 先尝试加载已保存的数据
    loadData();
    
    // 检查是否是新的一天，如果是则重置今日数据
    checkAndResetForNewDay();
    
    qDebug() << "HealthDataManager initialized. Date:" << m_currentDate.toString("yyyy-MM-dd");
}

HealthDataManager::~HealthDataManager()
{
    // 析构时保存数据
    saveData();
}

QString HealthDataManager::getDataFilePath()
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    return dataPath + "/health_data.json";
}

void HealthDataManager::checkAndResetForNewDay()
{
    if (m_lastSavedDate.isValid() && m_lastSavedDate != m_currentDate) {
        qDebug() << "New day detected, resetting today's data";
        resetTodayData();
    }
}

void HealthDataManager::saveData()
{
    QString filePath = getDataFilePath();
    QFile file(filePath);
    
    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject root;
        
        // 保存日期
        root["lastSavedDate"] = m_currentDate.toString("yyyy-MM-dd");
        
        // 保存目标设置
        root["stepsGoal"] = m_stepsGoal;
        root["caloriesGoal"] = m_caloriesGoal;
        root["activityGoal"] = m_activityGoal;
        
        // 保存今日数据
        QJsonObject todayData;
        todayData["steps"] = m_todaySteps;
        todayData["calories"] = m_todayCalories;
        todayData["activity"] = m_todayActivity;
        todayData["sleepMinutes"] = m_todaySleepMinutes;
        todayData["heartRate"] = m_todayHeartRate;
        todayData["moderateActivityMinutes"] = m_moderateActivityMinutes;
        root["todayData"] = todayData;
        
        // 保存周平均数据
        root["weekAvgSteps"] = m_weekAvgSteps;
        root["weekAvgSleepMinutes"] = m_weekAvgSleepMinutes;
        root["weekAvgHeartRate"] = m_weekAvgHeartRate;
        root["weekAvgCalories"] = m_weekAvgCalories;
        
        // 保存周数据历史
        root["weeklySteps"] = QJsonArray::fromVariantList(m_weeklySteps);
        root["weeklySleep"] = QJsonArray::fromVariantList(m_weeklySleep);
        root["weeklyHeartRate"] = QJsonArray::fromVariantList(m_weeklyHeartRate);
        
        QJsonDocument doc(root);
        file.write(doc.toJson(QJsonDocument::Compact));
        file.close();
        
        qDebug() << "HealthDataManager: Data saved to" << filePath;
    } else {
        qDebug() << "HealthDataManager: Failed to save data:" << file.errorString();
    }
}

void HealthDataManager::loadData()
{
    QString filePath = getDataFilePath();
    QFile file(filePath);
    
    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();
        
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject root = doc.object();
            
            // 加载上次保存日期
            if (root.contains("lastSavedDate")) {
                m_lastSavedDate = QDate::fromString(root["lastSavedDate"].toString(), "yyyy-MM-dd");
            }
            
            // 加载目标设置
            if (root.contains("stepsGoal")) m_stepsGoal = root["stepsGoal"].toInt();
            if (root.contains("caloriesGoal")) m_caloriesGoal = root["caloriesGoal"].toInt();
            if (root.contains("activityGoal")) m_activityGoal = root["activityGoal"].toInt();
            
            // 加载今日数据
            if (root.contains("todayData")) {
                QJsonObject todayData = root["todayData"].toObject();
                m_todaySteps = todayData["steps"].toInt();
                m_todayCalories = todayData["calories"].toInt();
                m_todayActivity = todayData["activity"].toInt();
                m_todaySleepMinutes = todayData["sleepMinutes"].toInt();
                m_todayHeartRate = todayData["heartRate"].toInt();
                m_moderateActivityMinutes = todayData["moderateActivityMinutes"].toInt();
            }
            
            // 加载周平均数据
            if (root.contains("weekAvgSteps")) m_weekAvgSteps = root["weekAvgSteps"].toInt();
            if (root.contains("weekAvgSleepMinutes")) m_weekAvgSleepMinutes = root["weekAvgSleepMinutes"].toInt();
            if (root.contains("weekAvgHeartRate")) m_weekAvgHeartRate = root["weekAvgHeartRate"].toInt();
            if (root.contains("weekAvgCalories")) m_weekAvgCalories = root["weekAvgCalories"].toInt();
            
            // 加载周数据历史
            if (root.contains("weeklySteps")) m_weeklySteps = root["weeklySteps"].toArray().toVariantList();
            if (root.contains("weeklySleep")) m_weeklySleep = root["weeklySleep"].toArray().toVariantList();
            if (root.contains("weeklyHeartRate")) m_weeklyHeartRate = root["weeklyHeartRate"].toArray().toVariantList();
            
            qDebug() << "HealthDataManager: Data loaded from" << filePath;
            qDebug() << "  - Last saved date:" << m_lastSavedDate.toString("yyyy-MM-dd");
            qDebug() << "  - Steps:" << m_todaySteps << "/" << m_stepsGoal;
            
            emit dataLoaded();
            return;
        }
    }
    
    // 没有保存的数据，使用示例数据
    qDebug() << "HealthDataManager: No saved data found, using sample data";
    generateSampleData();
}

void HealthDataManager::resetTodayData()
{
    // 在重置前，将今日数据添加到周历史
    if (m_weeklySteps.size() >= 7) {
        m_weeklySteps.removeFirst();
        m_weeklySleep.removeFirst();
        m_weeklyHeartRate.removeFirst();
    }
    
    m_weeklySteps.append(m_todaySteps);
    m_weeklySleep.append(m_todaySleepMinutes);
    m_weeklyHeartRate.append(m_todayHeartRate);
    
    // 重新计算周平均
    if (!m_weeklySteps.isEmpty()) {
        int totalSteps = 0, totalSleep = 0, totalHeartRate = 0;
        for (int i = 0; i < m_weeklySteps.size(); ++i) {
            totalSteps += m_weeklySteps[i].toInt();
            totalSleep += m_weeklySleep[i].toInt();
            totalHeartRate += m_weeklyHeartRate[i].toInt();
        }
        m_weekAvgSteps = totalSteps / m_weeklySteps.size();
        m_weekAvgSleepMinutes = totalSleep / m_weeklySleep.size();
        m_weekAvgHeartRate = totalHeartRate / m_weeklyHeartRate.size();
    }
    
    // 重置今日数据为0
    m_todaySteps = 0;
    m_todayCalories = 0;
    m_todayActivity = 0;
    m_todaySleepMinutes = 0;
    m_todayHeartRate = 72;
    m_moderateActivityMinutes = 0;
    
    // 更新日期
    m_currentDate = QDate::currentDate();
    m_lastSavedDate = m_currentDate;
    
    // 发出信号
    emit todayStepsChanged();
    emit todayCaloriesChanged();
    emit todayActivityChanged();
    emit todaySleepMinutesChanged();
    emit todayHeartRateChanged();
    emit moderateActivityMinutesChanged();
    emit weekAvgStepsChanged();
    emit weekAvgSleepMinutesChanged();
    emit weekAvgHeartRateChanged();
    
    qDebug() << "HealthDataManager: Today's data reset for new day";
}

void HealthDataManager::setTodaySteps(int value)
{
    if (m_todaySteps != value) {
        m_todaySteps = value;
        emit todayStepsChanged();
        saveData();
    }
}

void HealthDataManager::setStepsGoal(int value)
{
    if (m_stepsGoal != value) {
        m_stepsGoal = value;
        emit stepsGoalChanged();
        saveData();
    }
}

void HealthDataManager::setTodayCalories(int value)
{
    if (m_todayCalories != value) {
        m_todayCalories = value;
        emit todayCaloriesChanged();
        saveData();
    }
}

void HealthDataManager::setCaloriesGoal(int value)
{
    if (m_caloriesGoal != value) {
        m_caloriesGoal = value;
        emit caloriesGoalChanged();
        saveData();
    }
}

void HealthDataManager::setTodayActivity(int value)
{
    if (m_todayActivity != value) {
        m_todayActivity = value;
        emit todayActivityChanged();
        saveData();
    }
}

void HealthDataManager::setActivityGoal(int value)
{
    if (m_activityGoal != value) {
        m_activityGoal = value;
        emit activityGoalChanged();
        saveData();
    }
}

void HealthDataManager::setTodaySleepMinutes(int value)
{
    if (m_todaySleepMinutes != value) {
        m_todaySleepMinutes = value;
        emit todaySleepMinutesChanged();
        saveData();
    }
}

void HealthDataManager::setTodayHeartRate(int value)
{
    if (m_todayHeartRate != value) {
        m_todayHeartRate = value;
        emit todayHeartRateChanged();
        saveData();
    }
}

void HealthDataManager::setModerateActivityMinutes(int value)
{
    if (m_moderateActivityMinutes != value) {
        m_moderateActivityMinutes = value;
        emit moderateActivityMinutesChanged();
        saveData();
    }
}

void HealthDataManager::addSteps(int steps)
{
    m_todaySteps += steps;
    emit todayStepsChanged();
    saveData();
}

void HealthDataManager::addCalories(int calories)
{
    m_todayCalories += calories;
    emit todayCaloriesChanged();
    saveData();
}

void HealthDataManager::addActivity(int minutes)
{
    m_moderateActivityMinutes += minutes;
    emit moderateActivityMinutesChanged();
    saveData();
}

void HealthDataManager::updateHeartRate(int bpm)
{
    m_todayHeartRate = bpm;
    emit todayHeartRateChanged();
    saveData();
}

void HealthDataManager::updateSleep(int hours, int minutes)
{
    m_todaySleepMinutes = hours * 60 + minutes;
    emit todaySleepMinutesChanged();
    saveData();
}

void HealthDataManager::generateSampleData()
{
    // 示例数据
    m_todaySteps = 9580;
    m_todayCalories = 568;
    m_todayActivity = 4;
    m_todaySleepMinutes = 427; // 7小时7分钟
    m_todayHeartRate = 72;
    m_moderateActivityMinutes = 85;
    
    m_weekAvgSteps = 8234;
    m_weekAvgSleepMinutes = 445;
    m_weekAvgHeartRate = 68;
    m_weekAvgCalories = 489;
    
    // 示例周数据
    m_weeklySteps.clear();
    m_weeklySteps << 8500 << 9200 << 7800 << 10500 << 6800 << 9580 << 8900;
    
    m_weeklySleep.clear();
    m_weeklySleep << 420 << 450 << 390 << 480 << 380 << 427 << 410;
    
    m_weeklyHeartRate.clear();
    m_weeklyHeartRate << 68 << 72 << 65 << 70 << 75 << 72 << 69;
    
    qDebug() << "HealthDataManager: Sample data generated";
}

QString HealthDataManager::getHealthSummary()
{
    return QString("今日步数: %1/%2, 卡路里: %3/%4, 睡眠: %5小时%6分钟, 心率: %7次/分")
        .arg(m_todaySteps).arg(m_stepsGoal)
        .arg(m_todayCalories).arg(m_caloriesGoal)
        .arg(m_todaySleepMinutes / 60).arg(m_todaySleepMinutes % 60)
        .arg(m_todayHeartRate);
}

QString HealthDataManager::getDetailedHealthContext()
{
    return QString(
        "【今日健康数据】\n"
        "- 步数: %1 / %2 步 (完成 %3%)\n"
        "- 卡路里: %4 / %5 千卡\n"
        "- 活动: %6 次\n"
        "- 中高强度活动: %7 分钟\n"
        "- 睡眠: %8小时%9分钟\n"
        "- 心率: %10 次/分\n\n"
        "【周平均数据】\n"
        "- 平均步数: %11 步/天\n"
        "- 平均卡路里: %12 千卡/天\n"
        "- 平均睡眠: %13小时%14分钟/天\n"
        "- 平均心率: %15 次/分"
    ).arg(m_todaySteps).arg(m_stepsGoal).arg(m_stepsGoal > 0 ? (m_todaySteps * 100 / m_stepsGoal) : 0)
     .arg(m_todayCalories).arg(m_caloriesGoal)
     .arg(m_todayActivity)
     .arg(m_moderateActivityMinutes)
     .arg(m_todaySleepMinutes / 60).arg(m_todaySleepMinutes % 60)
     .arg(m_todayHeartRate)
     .arg(m_weekAvgSteps)
     .arg(m_weekAvgCalories)
     .arg(m_weekAvgSleepMinutes / 60).arg(m_weekAvgSleepMinutes % 60)
     .arg(m_weekAvgHeartRate);
}

QVariantList HealthDataManager::getWeeklySteps()
{
    if (m_weeklySteps.isEmpty()) {
        return QVariantList() << 8500 << 9200 << 7800 << 10500 << 9580 << 8900 << 8100;
    }
    return m_weeklySteps;
}

QVariantList HealthDataManager::getWeeklySleep()
{
    if (m_weeklySleep.isEmpty()) {
        return QVariantList() << 420 << 450 << 390 << 480 << 427 << 440 << 410;
    }
    return m_weeklySleep;
}

QVariantList HealthDataManager::getWeeklyHeartRate()
{
    if (m_weeklyHeartRate.isEmpty()) {
        return QVariantList() << 68 << 72 << 65 << 70 << 72 << 69 << 67;
    }
    return m_weeklyHeartRate;
}

void HealthDataManager::fetchFromBackend(const QString &token)
{
    if (token.isEmpty() || m_apiBaseUrl.isEmpty()) return;

    QUrl url(m_apiBaseUrl + "/health/dashboard");
    QNetworkRequest request(url);
    request.setRawHeader("Authorization", QString("Bearer %1").arg(token).toUtf8());

    QNetworkReply *reply = m_networkManager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onDashboardReply(reply);
    });
}

void HealthDataManager::onDashboardReply(QNetworkReply *reply)
{
    reply->deleteLater();
    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (doc.isNull() || !doc.isObject()) return;

    QJsonObject obj = doc.object();
    if (obj["code"].toInt() != 200) return;

    QJsonObject d = obj["data"].toObject();
    int score = d["health_score"].toInt(100);
    if (m_healthScore != score) {
        m_healthScore = score;
        emit healthScoreChanged();
    }

    QJsonArray records = d["health_records"].toArray();

    int steps = 0, calories = 0, sleepMin = 0, heartRate = 0, activity = 0;
    QString today = QDate::currentDate().toString("yyyy-MM-dd");

    for (const QJsonValue &v : records) {
        QJsonObject r = v.toObject();
        QString type = r["metric_type"].toString();
        double value = r["metric_value"].toDouble();
        QString time = r["collect_time"].toString();

        if (!time.startsWith(today)) continue;

        if (type == "STEPS") steps += (int)value;
        else if (type == "HEART_RATE") heartRate = (int)value;
        else if (type == "SLEEP") sleepMin = (int)value;
        else if (type == "CALORIES") calories += (int)value;
        else if (type == "ACTIVITY") activity += (int)value;
    }

    if (steps > 0) setTodaySteps(steps);
    if (calories > 0) setTodayCalories(calories);
    if (sleepMin > 0) setTodaySleepMinutes(sleepMin);
    if (heartRate > 0) setTodayHeartRate(heartRate);
    if (activity > 0) setTodayActivity(activity);

    saveData();
    emit dataLoaded();
    qDebug() << "HealthDataManager: Data fetched from backend";
}

void HealthDataManager::uploadToBackend(const QString &token)
{
    if (token.isEmpty() || m_apiBaseUrl.isEmpty()) return;

    QUrl url(m_apiBaseUrl + "/health/data");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", QString("Bearer %1").arg(token).toUtf8());

    QString now = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
    QJsonArray records;

    if (m_todaySteps > 0) {
        QJsonObject r;
        r["metric_type"] = "STEPS";
        r["metric_value"] = m_todaySteps;
        r["metric_unit"] = "steps";
        r["collect_time"] = now;
        records.append(r);
    }
    if (m_todayCalories > 0) {
        QJsonObject r;
        r["metric_type"] = "CALORIES";
        r["metric_value"] = m_todayCalories;
        r["metric_unit"] = "kcal";
        r["collect_time"] = now;
        records.append(r);
    }
    if (m_todayHeartRate > 0) {
        QJsonObject r;
        r["metric_type"] = "HEART_RATE";
        r["metric_value"] = m_todayHeartRate;
        r["metric_unit"] = "bpm";
        r["collect_time"] = now;
        records.append(r);
    }
    if (m_todaySleepMinutes > 0) {
        QJsonObject r;
        r["metric_type"] = "SLEEP";
        r["metric_value"] = m_todaySleepMinutes;
        r["metric_unit"] = "minutes";
        r["collect_time"] = now;
        records.append(r);
    }

    if (records.isEmpty()) return;

    QJsonObject body;
    body["records"] = records;
    QJsonDocument doc(body);

    m_networkManager->post(request, doc.toJson(QJsonDocument::Compact));
    qDebug() << "HealthDataManager: Uploading" << records.size() << "records to backend";
}

void HealthDataManager::fetchWeeklyReport(const QString &token)
{
    if (token.isEmpty() || m_apiBaseUrl.isEmpty()) return;

    QUrl url(m_apiBaseUrl + "/report/weekly");
    QNetworkRequest request(url);
    request.setRawHeader("Authorization", QString("Bearer %1").arg(token).toUtf8());

    QNetworkReply *reply = m_networkManager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        QByteArray data = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (doc.isNull() || !doc.isObject()) return;

        QJsonObject obj = doc.object();
        if (obj["code"].toInt() != 200) return;

        QJsonObject d = obj["data"].toObject();
        m_weeklyReportText = d["insight_text"].toString();
        emit weeklyReportReady(m_weeklyReportText);
        qDebug() << "HealthDataManager: Weekly report received";
    });
}
