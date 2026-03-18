#ifndef AISERVICE_H
#define AISERVICE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonArray>
#include <QJsonObject>

class AIService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)

public:
    explicit AIService(QObject *parent = nullptr);
    ~AIService();

    bool isLoading() const { return m_isLoading; }
    QString lastError() const { return m_lastError; }

    Q_INVOKABLE void sendMessage(const QString &userMessage, const QString &healthContext = QString());
    Q_INVOKABLE void clearConversation();
    Q_INVOKABLE void saveConversation();
    Q_INVOKABLE void loadConversation();
    Q_INVOKABLE QVariantList getConversationForQML();

signals:
    void responseReceived(const QString &response);
    void errorOccurred(const QString &error);
    void isLoadingChanged();
    void lastErrorChanged();
    void conversationLoaded();

private slots:
    void onReplyFinished(QNetworkReply *reply);
    void onSslErrors(QNetworkReply *reply, const QList<QSslError> &errors);

private:
    QNetworkAccessManager *m_networkManager;
    QJsonArray m_conversationHistory;
    bool m_isLoading;
    QString m_lastError;

    QString m_apiUrl;
    QString m_apiKey;
    QString m_model;

    void setIsLoading(bool loading);
    void setLastError(const QString &error);
    QJsonObject createMessage(const QString &role, const QString &content);
    QString formatAIResponse(const QString &rawContent);
    QString getConversationFilePath();
};

#endif // AISERVICE_H
