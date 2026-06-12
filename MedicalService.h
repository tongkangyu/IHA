#ifndef MEDICALSERVICE_H
#define MEDICALSERVICE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantMap>

class MedicalService : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)
    Q_PROPERTY(bool hasActiveConsultation READ hasActiveConsultation NOTIFY consultationChanged)

public:
    explicit MedicalService(QObject *parent = nullptr);
    ~MedicalService();

    bool isLoading() const { return m_isLoading; }
    QString lastError() const { return m_lastError; }
    bool hasActiveConsultation() const { return m_hasActiveConsultation; }

    Q_INVOKABLE void requestConsultation(const QString &symptom, const QString &department);
    Q_INVOKABLE void cancelConsultation(const QString &consultationId);
    Q_INVOKABLE void sendMessageToDoctor(const QString &consultationId, const QString &message);
    Q_INVOKABLE void authorizeDataAccess(const QString &consultationId, const QVariantMap &dataTypes);
    Q_INVOKABLE void revokeDataAccess(const QString &consultationId);
    Q_INVOKABLE QVariantList getDoctorList(const QString &department);
    Q_INVOKABLE QVariantList getConsultationHistory();
    Q_INVOKABLE void endConsultation(const QString &consultationId);
    Q_INVOKABLE void rateConsultation(const QString &consultationId, int rating, const QString &comment);

signals:
    void isLoadingChanged();
    void lastErrorChanged();
    void consultationChanged();
    void consultationRequested(const QString &consultationId);
    void consultationCancelled(const QString &consultationId);
    void doctorMessageReceived(const QString &consultationId, const QString &message);
    void consultationEnded(const QString &consultationId);
    void dataAccessAuthorized(const QString &consultationId);
    void dataAccessRevoked(const QString &consultationId);

private:
    QNetworkAccessManager *m_networkManager;
    bool m_isLoading;
    QString m_lastError;
    bool m_hasActiveConsultation;
    QString m_apiBaseUrl;
    QString m_activeConsultationId;

    void setIsLoading(bool loading);
    void setLastError(const QString &error);
    void setHasActiveConsultation(bool active);
};

#endif // MEDICALSERVICE_H
