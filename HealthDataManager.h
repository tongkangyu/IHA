#ifndef HEALTHDATAMANAGER_H
#define HEALTHDATAMANAGER_H

#include <QObject>
#include <QVariantMap>
#include <QDate>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class HealthDataManager : public QObject
{
    Q_OBJECT
    
    // 今日数据属性
    Q_PROPERTY(int todaySteps READ todaySteps WRITE setTodaySteps NOTIFY todayStepsChanged)
    Q_PROPERTY(int stepsGoal READ stepsGoal WRITE setStepsGoal NOTIFY stepsGoalChanged)
    Q_PROPERTY(int todayCalories READ todayCalories WRITE setTodayCalories NOTIFY todayCaloriesChanged)
    Q_PROPERTY(int caloriesGoal READ caloriesGoal WRITE setCaloriesGoal NOTIFY caloriesGoalChanged)
    Q_PROPERTY(int todayActivity READ todayActivity WRITE setTodayActivity NOTIFY todayActivityChanged)
    Q_PROPERTY(int activityGoal READ activityGoal WRITE setActivityGoal NOTIFY activityGoalChanged)
    Q_PROPERTY(int todaySleepMinutes READ todaySleepMinutes WRITE setTodaySleepMinutes NOTIFY todaySleepMinutesChanged)
    Q_PROPERTY(int todayHeartRate READ todayHeartRate WRITE setTodayHeartRate NOTIFY todayHeartRateChanged)
    Q_PROPERTY(int moderateActivityMinutes READ moderateActivityMinutes WRITE setModerateActivityMinutes NOTIFY moderateActivityMinutesChanged)
    
    Q_PROPERTY(int healthScore READ healthScore NOTIFY healthScoreChanged)

    // 周平均数据
    Q_PROPERTY(int weekAvgSteps READ weekAvgSteps NOTIFY weekAvgStepsChanged)
    Q_PROPERTY(int weekAvgSleepMinutes READ weekAvgSleepMinutes NOTIFY weekAvgSleepMinutesChanged)
    Q_PROPERTY(int weekAvgHeartRate READ weekAvgHeartRate NOTIFY weekAvgHeartRateChanged)
    Q_PROPERTY(int weekAvgCalories READ weekAvgCalories NOTIFY weekAvgCaloriesChanged)

public:
    explicit HealthDataManager(QObject *parent = nullptr);
    ~HealthDataManager();

    // 属性访问器
    int todaySteps() const { return m_todaySteps; }
    void setTodaySteps(int value);
    
    int stepsGoal() const { return m_stepsGoal; }
    void setStepsGoal(int value);
    
    int todayCalories() const { return m_todayCalories; }
    void setTodayCalories(int value);
    
    int caloriesGoal() const { return m_caloriesGoal; }
    void setCaloriesGoal(int value);
    
    int todayActivity() const { return m_todayActivity; }
    void setTodayActivity(int value);
    
    int activityGoal() const { return m_activityGoal; }
    void setActivityGoal(int value);
    
    int todaySleepMinutes() const { return m_todaySleepMinutes; }
    void setTodaySleepMinutes(int value);
    
    int todayHeartRate() const { return m_todayHeartRate; }
    void setTodayHeartRate(int value);
    
    int moderateActivityMinutes() const { return m_moderateActivityMinutes; }
    void setModerateActivityMinutes(int value);
    
    int healthScore() const { return m_healthScore; }
    int weekAvgSteps() const { return m_weekAvgSteps; }
    int weekAvgSleepMinutes() const { return m_weekAvgSleepMinutes; }
    int weekAvgHeartRate() const { return m_weekAvgHeartRate; }
    int weekAvgCalories() const { return m_weekAvgCalories; }

    // QML可调用方法
    Q_INVOKABLE void addSteps(int steps);
    Q_INVOKABLE void addCalories(int calories);
    Q_INVOKABLE void addActivity(int minutes);
    Q_INVOKABLE void updateHeartRate(int bpm);
    Q_INVOKABLE void updateSleep(int hours, int minutes);
    Q_INVOKABLE void generateSampleData();
    Q_INVOKABLE QString getHealthSummary();
    Q_INVOKABLE QString getDetailedHealthContext();
    Q_INVOKABLE QVariantList getWeeklySteps();
    Q_INVOKABLE QVariantList getWeeklySleep();
    Q_INVOKABLE QVariantList getWeeklyHeartRate();
    
    // 数据持久化
    Q_INVOKABLE void saveData();
    Q_INVOKABLE void loadData();
    Q_INVOKABLE void resetTodayData();

    // 后端同步
    Q_INVOKABLE void fetchFromBackend(const QString &token);
    Q_INVOKABLE void uploadToBackend(const QString &token);
    Q_INVOKABLE void fetchWeeklyReport(const QString &token);
    Q_INVOKABLE QString weeklyReportText() const { return m_weeklyReportText; }

signals:
    void todayStepsChanged();
    void stepsGoalChanged();
    void todayCaloriesChanged();
    void caloriesGoalChanged();
    void todayActivityChanged();
    void activityGoalChanged();
    void todaySleepMinutesChanged();
    void todayHeartRateChanged();
    void moderateActivityMinutesChanged();
    void weekAvgStepsChanged();
    void weekAvgSleepMinutesChanged();
    void weekAvgHeartRateChanged();
    void weekAvgCaloriesChanged();
    void dataChanged();
    void dataLoaded();
    void healthScoreChanged();
    void weeklyReportReady(const QString &reportText);

private:
    // 今日数据
    int m_todaySteps = 0;
    int m_stepsGoal = 10000;
    int m_todayCalories = 0;
    int m_caloriesGoal = 600;
    int m_todayActivity = 0;
    int m_activityGoal = 12;
    int m_todaySleepMinutes = 0;
    int m_todayHeartRate = 72;
    int m_moderateActivityMinutes = 0;
    
    int m_healthScore = 100;

    // 周平均数据
    int m_weekAvgSteps = 0;
    int m_weekAvgSleepMinutes = 0;
    int m_weekAvgHeartRate = 0;
    int m_weekAvgCalories = 0;
    
    // 周数据历史
    QVariantList m_weeklySteps;
    QVariantList m_weeklySleep;
    QVariantList m_weeklyHeartRate;
    
    QDate m_currentDate;
    QDate m_lastSavedDate;

    QNetworkAccessManager *m_networkManager;
    QString m_apiBaseUrl;
    QString m_weeklyReportText;
    
    QString getDataFilePath();
    void checkAndResetForNewDay();
    void onDashboardReply(QNetworkReply *reply);
};

#endif // HEALTHDATAMANAGER_H