#include "AIService.h"
#include "config.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QUrl>
#include <QSslConfiguration>
#include <QSslSocket>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>
#include <QFile>

AIService::AIService(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_isLoading(false)
    , m_apiUrl(AI_API_URL)
    , m_apiKey(AI_API_KEY)
    , m_model(AI_MODEL)
{
}

AIService::~AIService()
{
}

void AIService::sendMessage(const QString &userMessage, const QString &healthContext)
{
    if (m_isLoading) {
        qDebug() << "AIService: Already loading, skipping request";
        return;
    }

    qDebug() << "AIService: Sending message:" << userMessage;
    
    setIsLoading(true);
    setLastError(QString());

    // 如果是第一次对话，添加系统提示词
    if (m_conversationHistory.isEmpty()) {
        QString systemPrompt = QString(
            "你是一个友善的AI健康助理。\n\n"
            "普通对话时：像朋友一样自然交流，回复简洁（50字以内）。\n\n"
            "分析健康数据时：\n"
            "- 必须基于用户提供的真实数据进行分析\n"
            "- 给出具体的数值和百分比\n"
            "- 提供3-5条有针对性的建议\n"
            "- 回复可以详细（200-300字）\n"
            "- 不要编造数据，只使用用户提供的真实数据"
        );
        m_conversationHistory.append(createMessage("system", systemPrompt));
        qDebug() << "AIService: System prompt added";
    }

    QString messageToSend = userMessage;
    
    // 检测是否需要健康数据分析
    bool needsHealthContext = userMessage.contains("健康") || 
                              userMessage.contains("步数") || 
                              userMessage.contains("卡路里") ||
                              userMessage.contains("睡眠") ||
                              userMessage.contains("心率") ||
                              userMessage.contains("运动") ||
                              userMessage.contains("数据") ||
                              userMessage.contains("报告") ||
                              userMessage.contains("建议") ||
                              userMessage.contains("分析");
    
    if (!healthContext.isEmpty() && needsHealthContext) {
        messageToSend = QString("【请基于以下真实健康数据进行分析，不要编造数据】\n\n%1\n\n用户问题：%2").arg(healthContext, userMessage);
        qDebug() << "AIService: Health context included:" << healthContext;
    } else {
        qDebug() << "AIService: No health context for this message";
    }

    m_conversationHistory.append(createMessage("user", messageToSend));
    
    qDebug() << "AIService: Conversation history count:" << m_conversationHistory.count();
    qDebug() << "AIService: Full message to send:" << messageToSend;

    QJsonObject requestBody;
    requestBody["model"] = m_model;
    requestBody["messages"] = m_conversationHistory;
    requestBody["temperature"] = 0.7;
    requestBody["max_tokens"] = needsHealthContext ? 800 : 300;  // 健康分析需要更多token
    requestBody["top_p"] = 0.9;
    requestBody["frequency_penalty"] = 0.3;
    requestBody["stream"] = false;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    // 使用大括号初始化避免 "Most Vexing Parse" 问题
    QNetworkRequest request{QUrl(m_apiUrl)};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", QString("Bearer %1").arg(m_apiKey).toUtf8());

    QSslConfiguration sslConfig = request.sslConfiguration();
    sslConfig.setPeerVerifyMode(QSslSocket::VerifyNone);
    request.setSslConfiguration(sslConfig);

    QNetworkReply *reply = m_networkManager->post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onReplyFinished(reply);
    });
}

void AIService::clearConversation()
{
    m_conversationHistory = QJsonArray();
    
    // 删除保存的对话文件
    QString filePath = getConversationFilePath();
    QFile file(filePath);
    if (file.exists()) {
        file.remove();
    }
    
    qDebug() << "AIService: Conversation cleared";
}

QJsonObject AIService::createMessage(const QString &role, const QString &content)
{
    QJsonObject message;
    message["role"] = role;
    message["content"] = content;
    return message;
}

void AIService::onReplyFinished(QNetworkReply *reply)
{
    reply->deleteLater();
    setIsLoading(false);

    if (reply->error() != QNetworkReply::NoError) {
        QString errorString = reply->errorString();
        setLastError(errorString);
        emit errorOccurred(errorString);
        
        if (!m_conversationHistory.isEmpty()) {
            m_conversationHistory.removeLast();
        }
        return;
    }

    QByteArray responseData = reply->readAll();
    qDebug() << "AIService: Raw response:" << responseData.left(500);
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (doc.isNull() || !doc.isObject()) {
        setLastError("Invalid JSON response");
        emit errorOccurred("Invalid JSON response");
        return;
    }

    QJsonObject obj = doc.object();
    
    if (obj.contains("error")) {
        QString errorMsg = obj["error"].toObject()["message"].toString();
        setLastError(errorMsg);
        emit errorOccurred(errorMsg);
        return;
    }

    QJsonArray choices = obj["choices"].toArray();
    if (choices.isEmpty()) {
        setLastError("No response from AI");
        emit errorOccurred("No response from AI");
        return;
    }

    QString content = choices[0].toObject()["message"].toObject()["content"].toString();
    qDebug() << "AIService: AI response:" << content.left(200);
    
    m_conversationHistory.append(createMessage("assistant", content));
    
    // 自动保存对话
    saveConversation();
    
    // 尝试解析JSON并格式化输出
    QString formattedResponse = formatAIResponse(content);
    
    emit responseReceived(formattedResponse);
}

void AIService::onSslErrors(QNetworkReply *reply, const QList<QSslError> &errors)
{
    Q_UNUSED(errors);
    reply->ignoreSslErrors();
}

void AIService::setIsLoading(bool loading)
{
    if (m_isLoading != loading) {
        m_isLoading = loading;
        emit isLoadingChanged();
    }
}

void AIService::setLastError(const QString &error)
{
    if (m_lastError != error) {
        m_lastError = error;
        emit lastErrorChanged();
    }
}

QString AIService::formatAIResponse(const QString &rawContent)
{
    // 直接返回原始内容，不再解析JSON
    return rawContent.trimmed();
}

QString AIService::getConversationFilePath()
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    return dataPath + "/conversation.json";
}

void AIService::saveConversation()
{
    QString filePath = getConversationFilePath();
    QFile file(filePath);
    
    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject root;
        root["conversation"] = m_conversationHistory;
        
        QJsonDocument doc(root);
        QByteArray jsonData = doc.toJson(QJsonDocument::Compact);
        file.write(jsonData);
        file.close();
        qDebug() << "AIService: Conversation saved to" << filePath;
        qDebug() << "AIService: Saved" << m_conversationHistory.count() << "messages";
        qDebug() << "AIService: File size:" << jsonData.size() << "bytes";
    } else {
        qDebug() << "AIService: Failed to save conversation:" << file.errorString();
    }
}

void AIService::loadConversation()
{
    QString filePath = getConversationFilePath();
    QFile file(filePath);
    
    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();
        
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject root = doc.object();
            if (root.contains("conversation")) {
                m_conversationHistory = root["conversation"].toArray();
                qDebug() << "AIService: Conversation loaded, count:" << m_conversationHistory.count();
                
                // 打印前几条消息确认内容
                for (int i = 0; i < qMin(3, m_conversationHistory.count()); ++i) {
                    QJsonObject msg = m_conversationHistory[i].toObject();
                    qDebug() << "  Message" << i << ":" << msg["role"].toString() << "-" << msg["content"].toString().left(50);
                }
                
                emit conversationLoaded();
            }
        }
    } else {
        qDebug() << "AIService: No saved conversation found, starting fresh";
    }
}

QVariantList AIService::getConversationForQML()
{
    QVariantList messages;
    
    qDebug() << "AIService: getConversationForQML called, history count:" << m_conversationHistory.count();
    
    for (int i = 0; i < m_conversationHistory.count(); ++i) {
        QJsonObject msg = m_conversationHistory[i].toObject();
        QString role = msg["role"].toString();
        QString content = msg["content"].toString();
        
        // 跳过 system 消息
        if (role == "system") continue;
        
        QVariantMap messageMap;
        messageMap["type"] = role;  // user 或 assistant
        messageMap["content"] = content;
        messages.append(messageMap);
        
        qDebug() << "  - Message" << messages.count() << ":" << role << "(" << content.left(30) << "...)";
    }
    
    qDebug() << "AIService: Returning" << messages.count() << "messages for QML";
    return messages;
}