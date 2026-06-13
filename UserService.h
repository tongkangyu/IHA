#ifndef USERSERVICE_H
#define USERSERVICE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QCryptographicHash>
#include <QDateTime>

class UserService : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isLoggedIn READ isLoggedIn NOTIFY loginStatusChanged)
    Q_PROPERTY(QString userId READ userId NOTIFY userInfoChanged)
    Q_PROPERTY(QString userName READ userName NOTIFY userInfoChanged)
    Q_PROPERTY(QString userGender READ userGender WRITE setUserGender NOTIFY userInfoChanged)
    Q_PROPERTY(QString userBirthday READ userBirthday WRITE setUserBirthday NOTIFY userInfoChanged)
    Q_PROPERTY(int userHeight READ userHeight WRITE setUserHeight NOTIFY userInfoChanged)
    Q_PROPERTY(int userWeight READ userWeight WRITE setUserWeight NOTIFY userInfoChanged)
    Q_PROPERTY(QString avatarUrl READ avatarUrl NOTIFY userInfoChanged)
    Q_PROPERTY(QString phoneNumber READ phoneNumber NOTIFY userInfoChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)

public:
    explicit UserService(QObject *parent = nullptr);
    ~UserService();

    bool isLoggedIn() const { return m_isLoggedIn; }
    QString userId() const { return m_userId; }
    QString userName() const { return m_userName; }
    QString userGender() const { return m_userGender; }
    void setUserGender(const QString &gender);
    QString userBirthday() const { return m_userBirthday; }
    void setUserBirthday(const QString &birthday);
    int userHeight() const { return m_userHeight; }
    void setUserHeight(int height);
    int userWeight() const { return m_userWeight; }
    void setUserWeight(int weight);
    QString avatarUrl() const { return m_avatarUrl; }
    QString phoneNumber() const { return m_phoneNumber; }
    bool isLoading() const { return m_isLoading; }
    QString lastError() const { return m_lastError; }

    Q_INVOKABLE void login(const QString &phone, const QString &password);
    Q_INVOKABLE void registerUser(const QString &phone, const QString &password, const QString &name);
    Q_INVOKABLE void logout();
    Q_INVOKABLE void updateProfile(const QString &name, const QString &gender, const QString &birthday, int height, int weight);
    Q_INVOKABLE void changePassword(const QString &oldPassword, const QString &newPassword);
    Q_INVOKABLE void sendVerifyCode(const QString &phone);
    Q_INVOKABLE void resetPassword(const QString &phone, const QString &verifyCode, const QString &newPassword);
    Q_INVOKABLE void loadLocalSession();
    Q_INVOKABLE int getUserAge() const;
    Q_INVOKABLE QString getToken() const { return m_sessionToken; }
    Q_INVOKABLE void fetchUserInfo();

signals:
    void loginStatusChanged();
    void userInfoChanged();
    void isLoadingChanged();
    void lastErrorChanged();
    void loginSuccess();
    void loginFailed(const QString &error);
    void registerSuccess();
    void registerFailed(const QString &error);
    void profileUpdated();
    void passwordChanged(bool success);
    void verifyCodeSent(bool success);

private slots:
    void onLoginReply(QNetworkReply *reply);
    void onRegisterReply(QNetworkReply *reply);
    void onUpdateProfileReply(QNetworkReply *reply);
    void onChangePasswordReply(QNetworkReply *reply);
    void onSendVerifyCodeReply(QNetworkReply *reply);
    void onResetPasswordReply(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_networkManager;

    bool m_isLoggedIn;
    QString m_userId;
    QString m_userName;
    QString m_userGender;
    QString m_userBirthday;
    int m_userHeight;
    int m_userWeight;
    QString m_avatarUrl;
    QString m_phoneNumber;
    QString m_sessionToken;
    bool m_isLoading;
    QString m_lastError;

    QString m_apiBaseUrl;

    void setIsLoggedIn(bool loggedIn);
    void setIsLoading(bool loading);
    void setLastError(const QString &error);
    void saveLocalSession();
    void clearLocalSession();
    QString getSessionFilePath();
    QString hashPassword(const QString &password);
    QNetworkRequest createAuthenticatedRequest(const QUrl &url);
};

#endif // USERSERVICE_H
