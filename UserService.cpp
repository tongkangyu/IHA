#include "UserService.h"
#include "config.h"
#include <QDebug>
#include <QNetworkRequest>

UserService::UserService(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_isLoggedIn(false)
    , m_userHeight(170)
    , m_userWeight(65)
    , m_isLoading(false)
    , m_apiBaseUrl(USER_API_URL)
{
    loadLocalSession();
}

UserService::~UserService()
{
}

QString UserService::hashPassword(const QString &password)
{
    QByteArray hash = QCryptographicHash::hash(
        (password + "IHA_SALT_2026").toUtf8(),
        QCryptographicHash::Sha256
    );
    return QString(hash.toHex());
}

QNetworkRequest UserService::createAuthenticatedRequest(const QUrl &url)
{
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    if (!m_sessionToken.isEmpty()) {
        request.setRawHeader("Authorization", QString("Bearer %1").arg(m_sessionToken).toUtf8());
    }
    return request;
}

void UserService::login(const QString &phone, const QString &password)
{
    setIsLoading(true);
    setLastError(QString());

    QJsonObject requestBody;
    requestBody["mobile"] = phone;
    requestBody["password"] = password;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/auth/login");
    QNetworkRequest request = createAuthenticatedRequest(url);

    QNetworkReply *reply = m_networkManager->post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onLoginReply(reply);
    });
}

void UserService::registerUser(const QString &phone, const QString &password, const QString &name)
{
    setIsLoading(true);
    setLastError(QString());

    QJsonObject requestBody;
    requestBody["mobile"] = phone;
    requestBody["password"] = password;
    requestBody["nickname"] = name;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/auth/register");
    QNetworkRequest request = createAuthenticatedRequest(url);

    QNetworkReply *reply = m_networkManager->post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onRegisterReply(reply);
    });
}

void UserService::logout()
{
    m_isLoggedIn = false;
    m_userId.clear();
    m_userName.clear();
    m_userGender.clear();
    m_userBirthday.clear();
    m_userHeight = 170;
    m_userWeight = 65;
    m_avatarUrl.clear();
    m_phoneNumber.clear();
    m_sessionToken.clear();

    clearLocalSession();
    emit loginStatusChanged();
    emit userInfoChanged();
}

void UserService::updateProfile(const QString &name, const QString &gender, const QString &birthday, int height, int weight)
{
    setIsLoading(true);

    QJsonObject requestBody;
    requestBody["nickname"] = name;
    requestBody["gender"] = gender;
    requestBody["birthday"] = birthday;
    requestBody["height"] = height;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/user/info");
    QNetworkRequest request = createAuthenticatedRequest(url);

    QNetworkReply *reply = m_networkManager->put(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUpdateProfileReply(reply);
    });

    m_userName = name;
    m_userGender = gender;
    m_userBirthday = birthday;
    m_userHeight = height;
    m_userWeight = weight;
    emit userInfoChanged();
    saveLocalSession();
}

void UserService::changePassword(const QString &oldPassword, const QString &newPassword)
{
    setIsLoading(true);

    QJsonObject requestBody;
    requestBody["oldPassword"] = hashPassword(oldPassword);
    requestBody["newPassword"] = hashPassword(newPassword);

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/user/password");
    QNetworkRequest request = createAuthenticatedRequest(url);

    QNetworkReply *reply = m_networkManager->put(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onChangePasswordReply(reply);
    });
}

void UserService::sendVerifyCode(const QString &phone)
{
    setIsLoading(true);

    QJsonObject requestBody;
    requestBody["phone"] = phone;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/auth/verify-code");
    QNetworkRequest request = createAuthenticatedRequest(url);

    QNetworkReply *reply = m_networkManager->post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onSendVerifyCodeReply(reply);
    });
}

void UserService::resetPassword(const QString &phone, const QString &verifyCode, const QString &newPassword)
{
    setIsLoading(true);

    QJsonObject requestBody;
    requestBody["phone"] = phone;
    requestBody["verifyCode"] = verifyCode;
    requestBody["newPassword"] = hashPassword(newPassword);

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/auth/reset-password");
    QNetworkRequest request = createAuthenticatedRequest(url);

    QNetworkReply *reply = m_networkManager->post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onResetPasswordReply(reply);
    });
}

void UserService::loadLocalSession()
{
    QString filePath = getSessionFilePath();
    QFile file(filePath);

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();

        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject root = doc.object();

            m_sessionToken = root["token"].toString();
            m_userId = root["userId"].toString();
            m_userName = root["userName"].toString();
            m_userGender = root["gender"].toString();
            m_userBirthday = root["birthday"].toString();
            m_userHeight = root["height"].toInt();
            m_userWeight = root["weight"].toInt();
            m_avatarUrl = root["avatarUrl"].toString();
            m_phoneNumber = root["phone"].toString();

            if (!m_sessionToken.isEmpty() && !m_userId.isEmpty()) {
                m_isLoggedIn = true;
                emit loginStatusChanged();
                emit userInfoChanged();
                fetchUserInfo();
                qDebug() << "UserService: Session restored for" << m_userName;
            }
        }
    }

    if (!m_isLoggedIn) {
        qDebug() << "UserService: No valid session found";
    }
}

int UserService::getUserAge() const
{
    if (m_userBirthday.isEmpty()) return 0;
    QDate birthday = QDate::fromString(m_userBirthday, "yyyy-MM-dd");
    if (!birthday.isValid()) return 0;
    QDate today = QDate::currentDate();
    int age = today.year() - birthday.year();
    if (today.month() < birthday.month() ||
        (today.month() == birthday.month() && today.day() < birthday.day())) {
        age--;
    }
    return age;
}

void UserService::setUserGender(const QString &gender)
{
    if (m_userGender != gender) {
        m_userGender = gender;
        emit userInfoChanged();
    }
}

void UserService::setUserBirthday(const QString &birthday)
{
    if (m_userBirthday != birthday) {
        m_userBirthday = birthday;
        emit userInfoChanged();
    }
}

void UserService::setUserHeight(int height)
{
    if (m_userHeight != height) {
        m_userHeight = height;
        emit userInfoChanged();
    }
}

void UserService::setUserWeight(int weight)
{
    if (m_userWeight != weight) {
        m_userWeight = weight;
        emit userInfoChanged();
    }
}

void UserService::setIsLoggedIn(bool loggedIn)
{
    if (m_isLoggedIn != loggedIn) {
        m_isLoggedIn = loggedIn;
        emit loginStatusChanged();
    }
}

void UserService::setIsLoading(bool loading)
{
    if (m_isLoading != loading) {
        m_isLoading = loading;
        emit isLoadingChanged();
    }
}

void UserService::setLastError(const QString &error)
{
    if (m_lastError != error) {
        m_lastError = error;
        emit lastErrorChanged();
    }
}

void UserService::saveLocalSession()
{
    QString filePath = getSessionFilePath();
    QFile file(filePath);

    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject root;
        root["token"] = m_sessionToken;
        root["userId"] = m_userId;
        root["userName"] = m_userName;
        root["gender"] = m_userGender;
        root["birthday"] = m_userBirthday;
        root["height"] = m_userHeight;
        root["weight"] = m_userWeight;
        root["avatarUrl"] = m_avatarUrl;
        root["phone"] = m_phoneNumber;

        QJsonDocument doc(root);
        file.write(doc.toJson(QJsonDocument::Compact));
        file.close();
        qDebug() << "UserService: Session saved";
    }
}

void UserService::clearLocalSession()
{
    QString filePath = getSessionFilePath();
    QFile file(filePath);
    if (file.exists()) {
        file.remove();
    }
}

QString UserService::getSessionFilePath()
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    return dataPath + "/user_session.json";
}

void UserService::onLoginReply(QNetworkReply *reply)
{
    reply->deleteLater();
    setIsLoading(false);

    QByteArray responseData = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (doc.isNull() || !doc.isObject()) {
        QString error = reply->error() != QNetworkReply::NoError ?
            reply->errorString() : "Invalid response";
        setLastError(error);
        emit loginFailed(error);
        return;
    }

    QJsonObject obj = doc.object();
    int code = obj["code"].toInt();

    if (code != 200) {
        QString errorMsg = obj["message"].toString();
        setLastError(errorMsg);
        emit loginFailed(errorMsg);
        return;
    }

    QJsonObject data = obj["data"].toObject();
    m_sessionToken = data["token"].toString();
    m_userId = data["user_id"].toString();
    m_userName = data["nickname"].toString();
    m_phoneNumber = data["mobile"].toString();

    setIsLoggedIn(true);
    saveLocalSession();
    fetchUserInfo();

    emit loginSuccess();
    emit userInfoChanged();
}

void UserService::onRegisterReply(QNetworkReply *reply)
{
    reply->deleteLater();
    setIsLoading(false);

    QByteArray responseData = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (doc.isNull() || !doc.isObject()) {
        QString error = reply->error() != QNetworkReply::NoError ?
            reply->errorString() : "Invalid response";
        setLastError(error);
        emit registerFailed(error);
        return;
    }

    QJsonObject obj = doc.object();
    int code = obj["code"].toInt();

    if (code != 200) {
        QString errorMsg = obj["message"].toString();
        setLastError(errorMsg);
        emit registerFailed(errorMsg);
        return;
    }

    QJsonObject data = obj["data"].toObject();
    m_sessionToken = data["token"].toString();
    m_userId = data["user_id"].toString();
    m_userName = data["nickname"].toString();
    m_phoneNumber = data["mobile"].toString();

    setIsLoggedIn(true);
    saveLocalSession();
    fetchUserInfo();

    emit registerSuccess();
    emit userInfoChanged();
}

void UserService::onUpdateProfileReply(QNetworkReply *reply)
{
    reply->deleteLater();
    setIsLoading(false);

    if (reply->error() != QNetworkReply::NoError) {
        setLastError(reply->errorString());
        return;
    }

    emit profileUpdated();
}

void UserService::onChangePasswordReply(QNetworkReply *reply)
{
    reply->deleteLater();
    setIsLoading(false);

    if (reply->error() != QNetworkReply::NoError) {
        setLastError(reply->errorString());
        emit passwordChanged(false);
        return;
    }

    emit passwordChanged(true);
}

void UserService::onSendVerifyCodeReply(QNetworkReply *reply)
{
    reply->deleteLater();
    setIsLoading(false);

    if (reply->error() != QNetworkReply::NoError) {
        setLastError(reply->errorString());
        emit verifyCodeSent(false);
        return;
    }

    emit verifyCodeSent(true);
}

void UserService::onResetPasswordReply(QNetworkReply *reply)
{
    reply->deleteLater();
    setIsLoading(false);

    if (reply->error() != QNetworkReply::NoError) {
        setLastError(reply->errorString());
        return;
    }
}

void UserService::fetchUserInfo()
{
    if (m_sessionToken.isEmpty()) return;

    QUrl url(m_apiBaseUrl + "/user/info");
    QNetworkRequest request = createAuthenticatedRequest(url);

    QNetworkReply *reply = m_networkManager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        QByteArray responseData = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        if (doc.isNull() || !doc.isObject()) return;

        QJsonObject obj = doc.object();
        if (obj["code"].toInt() == 401) { logout(); return; }
        if (obj["code"].toInt() != 200) return;

        QJsonObject data = obj["data"].toObject();
        if (data.contains("nickname") && !data["nickname"].toString().isEmpty())
            m_userName = data["nickname"].toString();
        if (data.contains("gender") && !data["gender"].toString().isEmpty())
            m_userGender = data["gender"].toString();
        if (data.contains("birthday") && !data["birthday"].toString().isEmpty())
            m_userBirthday = data["birthday"].toString();
        if (data.contains("height") && data["height"].toInt() > 0)
            m_userHeight = data["height"].toInt();

        saveLocalSession();
        emit userInfoChanged();
    });
}
