#include "HealthCircleManager.h"
#include "config.h"
#include <QDebug>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

CircleMemberModel::CircleMemberModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int CircleMemberModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_members.count();
}

QVariant CircleMemberModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_members.count())
        return QVariant();

    const CircleMember &member = m_members[index.row()];

    switch (role) {
    case MemberIdRole: return member.memberId;
    case NameRole: return member.name;
    case RelationshipRole: return member.relationship;
    case AvatarUrlRole: return member.avatarUrl;
    case IsOnlineRole: return member.isOnline;
    case PermissionsRole: return member.dataPermissions;
    case HealthSummaryRole: return member.healthSummary;
    default: return QVariant();
    }
}

QHash<int, QByteArray> CircleMemberModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[MemberIdRole] = "memberId";
    roles[NameRole] = "name";
    roles[RelationshipRole] = "relationship";
    roles[AvatarUrlRole] = "avatarUrl";
    roles[IsOnlineRole] = "isOnline";
    roles[PermissionsRole] = "permissions";
    roles[HealthSummaryRole] = "healthSummary";
    return roles;
}

void CircleMemberModel::addMember(const CircleMember &member)
{
    beginInsertRows(QModelIndex(), m_members.count(), m_members.count());
    m_members.append(member);
    endInsertRows();
}

void CircleMemberModel::removeMember(const QString &memberId)
{
    for (int i = 0; i < m_members.count(); ++i) {
        if (m_members[i].memberId == memberId) {
            beginRemoveRows(QModelIndex(), i, i);
            m_members.removeAt(i);
            endRemoveRows();
            return;
        }
    }
}

void CircleMemberModel::updateMember(const QString &memberId, const CircleMember &member)
{
    for (int i = 0; i < m_members.count(); ++i) {
        if (m_members[i].memberId == memberId) {
            m_members[i] = member;
            emit dataChanged(index(i), index(i));
            return;
        }
    }
}

void CircleMemberModel::clear()
{
    beginResetModel();
    m_members.clear();
    endResetModel();
}

CircleMember CircleMemberModel::getMember(int index) const
{
    if (index >= 0 && index < m_members.count())
        return m_members[index];
    return CircleMember();
}

HealthCircleManager::HealthCircleManager(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_isLoading(false)
    , m_apiBaseUrl(USER_API_URL)
{
    loadMembers();
    if (m_memberModel.rowCount() == 0) {
        generateSampleMembers();
    }
}

HealthCircleManager::~HealthCircleManager()
{
    saveMembers();
}

int HealthCircleManager::memberCount() const
{
    return m_memberModel.rowCount();
}

void HealthCircleManager::inviteMember(const QString &phone, const QString &relationship)
{
    setIsLoading(true);

    QJsonObject requestBody;
    requestBody["phone"] = phone;
    requestBody["relationship"] = relationship;

    QJsonDocument doc(requestBody);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    QUrl url(m_apiBaseUrl + "/circle/invite");
    QNetworkRequest request{url};
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkManager->post(request, data);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        setIsLoading(false);
        if (reply->error() == QNetworkReply::NoError) {
            emit memberInvited("");
        }
    });
}

void HealthCircleManager::removeMember(const QString &memberId)
{
    m_memberModel.removeMember(memberId);
    emit memberRemoved(memberId);
    emit membersChanged();
    saveMembers();
}

void HealthCircleManager::updatePermissions(const QString &memberId, const QVariantMap &permissions)
{
    for (int i = 0; i < m_memberModel.rowCount(); ++i) {
        CircleMember member = m_memberModel.getMember(i);
        if (member.memberId == memberId) {
            member.dataPermissions = permissions;
            m_memberModel.updateMember(memberId, member);
            emit permissionsUpdated(memberId);
            saveMembers();
            return;
        }
    }
}

QVariantMap HealthCircleManager::getMemberPermissions(const QString &memberId)
{
    for (int i = 0; i < m_memberModel.rowCount(); ++i) {
        CircleMember member = m_memberModel.getMember(i);
        if (member.memberId == memberId) {
            return member.dataPermissions;
        }
    }
    return QVariantMap();
}

void HealthCircleManager::shareHealthData(const QString &memberId, const QVariantMap &dataTypes)
{
    Q_UNUSED(dataTypes)
    emit healthDataShared(memberId);
}

void HealthCircleManager::revokeAccess(const QString &memberId, const QString &dataType)
{
    for (int i = 0; i < m_memberModel.rowCount(); ++i) {
        CircleMember member = m_memberModel.getMember(i);
        if (member.memberId == memberId) {
            QVariantMap perms = member.dataPermissions;
            perms[dataType] = false;
            member.dataPermissions = perms;
            m_memberModel.updateMember(memberId, member);
            emit accessRevoked(memberId, dataType);
            saveMembers();
            return;
        }
    }
}

QVariantMap HealthCircleManager::getMemberHealthSummary(const QString &memberId)
{
    for (int i = 0; i < m_memberModel.rowCount(); ++i) {
        CircleMember member = m_memberModel.getMember(i);
        if (member.memberId == memberId) {
            return member.healthSummary;
        }
    }
    return QVariantMap();
}

void HealthCircleManager::loadMembers()
{
    QString filePath = getDataFilePath();
    QFile file(filePath);

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();

        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject root = doc.object();
            QJsonArray membersArray = root["members"].toArray();

            for (int i = 0; i < membersArray.count(); ++i) {
                QJsonObject obj = membersArray[i].toObject();
                CircleMember member;
                member.memberId = obj["memberId"].toString();
                member.name = obj["name"].toString();
                member.relationship = obj["relationship"].toString();
                member.avatarUrl = obj["avatarUrl"].toString();
                member.isOnline = obj["isOnline"].toBool();
                member.dataPermissions = obj["permissions"].toObject().toVariantMap();
                member.healthSummary = obj["healthSummary"].toObject().toVariantMap();

                m_memberModel.addMember(member);
            }
            emit membersChanged();
        }
    }
}

void HealthCircleManager::saveMembers()
{
    QString filePath = getDataFilePath();
    QFile file(filePath);

    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject root;
        QJsonArray membersArray;

        for (int i = 0; i < m_memberModel.rowCount(); ++i) {
            CircleMember member = m_memberModel.getMember(i);
            QJsonObject obj;
            obj["memberId"] = member.memberId;
            obj["name"] = member.name;
            obj["relationship"] = member.relationship;
            obj["avatarUrl"] = member.avatarUrl;
            obj["isOnline"] = member.isOnline;
            obj["permissions"] = QJsonObject::fromVariantMap(member.dataPermissions);
            obj["healthSummary"] = QJsonObject::fromVariantMap(member.healthSummary);
            membersArray.append(obj);
        }

        root["members"] = membersArray;

        QJsonDocument doc(root);
        file.write(doc.toJson(QJsonDocument::Compact));
        file.close();
    }
}

void HealthCircleManager::generateSampleMembers()
{
    CircleMember mom;
    mom.memberId = "mom_001";
    mom.name = QString::fromUtf8("\xE5\xA6\x88\xE5\xA6\x88");
    mom.relationship = QString::fromUtf8("\xE6\xAF\x8D\xE4\xBA\xB2");
    mom.isOnline = true;
    mom.dataPermissions = QVariantMap{
        {"steps", true}, {"heartRate", true}, {"sleep", true},
        {"location", false}, {"environment", true}
    };
    mom.healthSummary = QVariantMap{
        {"steps", 5200}, {"heartRate", 75}, {"sleepHours", 6.5},
        {"status", "normal"}
    };
    m_memberModel.addMember(mom);

    CircleMember dad;
    dad.memberId = "dad_001";
    dad.name = QString::fromUtf8("\xE7\x88\xB8\xE7\x88\xB8");
    dad.relationship = QString::fromUtf8("\xE7\x88\xB6\xE4\xBA\xB2");
    dad.isOnline = false;
    dad.dataPermissions = QVariantMap{
        {"steps", true}, {"heartRate", true}, {"sleep", false},
        {"location", false}, {"environment", false}
    };
    dad.healthSummary = QVariantMap{
        {"steps", 3800}, {"heartRate", 78}, {"sleepHours", 5.5},
        {"status", "warning"}
    };
    m_memberModel.addMember(dad);

    CircleMember doctor;
    doctor.memberId = "doc_001";
    doctor.name = QString::fromUtf8("\xE5\xBC\xA0\xE5\x8C\xBB\xE7\x94\x9F");
    doctor.relationship = QString::fromUtf8("\xE5\xAE\xB6\xE5\xBA\xAD\xE5\x8C\xBB\xE7\x94\x9F");
    doctor.isOnline = true;
    doctor.dataPermissions = QVariantMap{
        {"steps", true}, {"heartRate", true}, {"sleep", true},
        {"bloodPressure", true}, {"bloodOxygen", true}, {"weight", true}
    };
    doctor.healthSummary = QVariantMap{
        {"lastVisit", "2026-03-15"}, {"nextVisit", "2026-06-15"},
        {"status", "monitoring"}
    };
    m_memberModel.addMember(doctor);

    emit membersChanged();
    saveMembers();
}

void HealthCircleManager::setIsLoading(bool loading)
{
    if (m_isLoading != loading) {
        m_isLoading = loading;
        emit isLoadingChanged();
    }
}

QString HealthCircleManager::getDataFilePath()
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) dir.mkpath(".");
    return dataPath + "/health_circle.json";
}
