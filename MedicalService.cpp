#include "MedicalService.h"
#include "config.h"
#include <QDebug>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

MedicalService::MedicalService(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_isLoading(false)
    , m_hasActiveConsultation(false)
    , m_apiBaseUrl(MEDICAL_API_URL)
{
}

MedicalService::~MedicalService()
{
}

void MedicalService::requestConsultation(const QString &symptom, const QString &department)
{
    setIsLoading(true);
    setLastError(QString());

    QJsonObject requestBody;
    requestBody["symptom"] = symptom;
    requestBody["department"] = department;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/consultation/request");
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkManager->post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        setIsLoading(false);

        if (reply->error() != QNetworkReply::NoError) {
            setLastError(reply->errorString());
            return;
        }

        QByteArray responseData = reply->readAll();
        QJsonDocument responseDoc = QJsonDocument::fromJson(responseData);
        if (!responseDoc.isNull() && responseDoc.isObject()) {
            QString consultationId = responseDoc.object()["consultationId"].toString();
            m_activeConsultationId = consultationId;
            setHasActiveConsultation(true);
            emit consultationRequested(consultationId);
        }
    });
}

void MedicalService::cancelConsultation(const QString &consultationId)
{
    setIsLoading(true);

    QUrl url(m_apiBaseUrl + "/consultation/" + consultationId + "/cancel");
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkManager->post(request, QByteArray());
    connect(reply, &QNetworkReply::finished, this, [this, reply, consultationId]() {
        reply->deleteLater();
        setIsLoading(false);

        if (reply->error() == QNetworkReply::NoError) {
            m_activeConsultationId.clear();
            setHasActiveConsultation(false);
            emit consultationCancelled(consultationId);
        } else {
            setLastError(reply->errorString());
        }
    });
}

void MedicalService::sendMessageToDoctor(const QString &consultationId, const QString &message)
{
    QJsonObject requestBody;
    requestBody["message"] = message;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/consultation/" + consultationId + "/message");
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    m_networkManager->post(request, data);
}

void MedicalService::authorizeDataAccess(const QString &consultationId, const QVariantMap &dataTypes)
{
    QJsonObject requestBody;
    requestBody["dataTypes"] = QJsonObject::fromVariantMap(dataTypes);

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/consultation/" + consultationId + "/authorize");
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkManager->post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply, consultationId]() {
        reply->deleteLater();
        if (reply->error() == QNetworkReply::NoError) {
            emit dataAccessAuthorized(consultationId);
        }
    });
}

void MedicalService::revokeDataAccess(const QString &consultationId)
{
    QUrl url(m_apiBaseUrl + "/consultation/" + consultationId + "/revoke");
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkManager->post(request, QByteArray());
    connect(reply, &QNetworkReply::finished, this, [this, reply, consultationId]() {
        reply->deleteLater();
        if (reply->error() == QNetworkReply::NoError) {
            emit dataAccessRevoked(consultationId);
        }
    });
}

QVariantList MedicalService::getDoctorList(const QString &department)
{
    Q_UNUSED(department)
    QVariantList doctors;

    QVariantMap doc1;
    doc1["id"] = "doc_001";
    doc1["name"] = QString::fromUtf8("\xE5\xBC\xA0\xE5\x8C\xBB\xE7\x94\x9F");
    doc1["department"] = QString::fromUtf8("\xE5\x86\x85\xE7\xA7\x91");
    doc1["title"] = QString::fromUtf8("\xE4\xB8\xBB\xE4\xBB\xBB\xE5\x8C\xBB\xE5\xB8\x88");
    doc1["rating"] = 4.8;
    doc1["isOnline"] = true;
    doctors.append(doc1);

    QVariantMap doc2;
    doc2["id"] = "doc_002";
    doc2["name"] = QString::fromUtf8("\xE6\x9D\x8E\xE5\x8C\xBB\xE7\x94\x9F");
    doc2["department"] = QString::fromUtf8("\xE5\xBF\x83\xE8\xA1\x80\xE7\xAE\xA1\xE7\xA7\x91");
    doc2["title"] = QString::fromUtf8("\xE5\x89\xAF\xE4\xB8\xBB\xE4\xBB\xBB\xE5\x8C\xBB\xE5\xB8\x88");
    doc2["rating"] = 4.6;
    doc2["isOnline"] = true;
    doctors.append(doc2);

    return doctors;
}

QVariantList MedicalService::getConsultationHistory()
{
    QVariantList history;

    QVariantMap consult;
    consult["id"] = "cons_001";
    consult["doctorName"] = QString::fromUtf8("\xE5\xBC\xA0\xE5\x8C\xBB\xE7\x94\x9F");
    consult["department"] = QString::fromUtf8("\xE5\x86\x85\xE7\xA7\x91");
    consult["date"] = "2026-03-15";
    consult["status"] = "completed";
    consult["rating"] = 5;
    history.append(consult);

    return history;
}

void MedicalService::endConsultation(const QString &consultationId)
{
    QUrl url(m_apiBaseUrl + "/consultation/" + consultationId + "/end");
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkManager->post(request, QByteArray());
    connect(reply, &QNetworkReply::finished, this, [this, reply, consultationId]() {
        reply->deleteLater();
        m_activeConsultationId.clear();
        setHasActiveConsultation(false);
        emit consultationEnded(consultationId);
    });
}

void MedicalService::rateConsultation(const QString &consultationId, int rating, const QString &comment)
{
    QJsonObject requestBody;
    requestBody["rating"] = rating;
    requestBody["comment"] = comment;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/consultation/" + consultationId + "/rate");
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    m_networkManager->post(request, data);
}

void MedicalService::setIsLoading(bool loading)
{
    if (m_isLoading != loading) {
        m_isLoading = loading;
        emit isLoadingChanged();
    }
}

void MedicalService::setLastError(const QString &error)
{
    if (m_lastError != error) {
        m_lastError = error;
        emit lastErrorChanged();
    }
}

void MedicalService::setHasActiveConsultation(bool active)
{
    if (m_hasActiveConsultation != active) {
        m_hasActiveConsultation = active;
        emit consultationChanged();
    }
}
