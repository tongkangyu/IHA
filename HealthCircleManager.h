#ifndef HEALTHCIRCLEMANAGER_H
#define HEALTHCIRCLEMANAGER_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QVariantMap>
#include <QNetworkAccessManager>
#include <QNetworkReply>

struct CircleMember {
    QString memberId;
    QString name;
    QString relationship;
    QString avatarUrl;
    bool isOnline;
    QVariantMap dataPermissions;
    QVariantMap healthSummary;
};

class CircleMemberModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum MemberRoles {
        MemberIdRole = Qt::UserRole + 1,
        NameRole,
        RelationshipRole,
        AvatarUrlRole,
        IsOnlineRole,
        PermissionsRole,
        HealthSummaryRole
    };

    explicit CircleMemberModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addMember(const CircleMember &member);
    void removeMember(const QString &memberId);
    void updateMember(const QString &memberId, const CircleMember &member);
    void clear();
    CircleMember getMember(int index) const;

private:
    QList<CircleMember> m_members;
};

class HealthCircleManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(CircleMemberModel* members READ members CONSTANT)
    Q_PROPERTY(int memberCount READ memberCount NOTIFY membersChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit HealthCircleManager(QObject *parent = nullptr);
    ~HealthCircleManager();

    CircleMemberModel* members() { return &m_memberModel; }
    int memberCount() const;
    bool isLoading() const { return m_isLoading; }

    Q_INVOKABLE void inviteMember(const QString &phone, const QString &relationship);
    Q_INVOKABLE void removeMember(const QString &memberId);
    Q_INVOKABLE void updatePermissions(const QString &memberId, const QVariantMap &permissions);
    Q_INVOKABLE QVariantMap getMemberPermissions(const QString &memberId);
    Q_INVOKABLE void shareHealthData(const QString &memberId, const QVariantMap &dataTypes);
    Q_INVOKABLE void revokeAccess(const QString &memberId, const QString &dataType);
    Q_INVOKABLE QVariantMap getMemberHealthSummary(const QString &memberId);
    Q_INVOKABLE void loadMembers();
    Q_INVOKABLE void saveMembers();
    Q_INVOKABLE void generateSampleMembers();

signals:
    void membersChanged();
    void isLoadingChanged();
    void memberInvited(const QString &memberId);
    void memberRemoved(const QString &memberId);
    void permissionsUpdated(const QString &memberId);
    void healthDataShared(const QString &memberId);
    void accessRevoked(const QString &memberId, const QString &dataType);

private:
    CircleMemberModel m_memberModel;
    QNetworkAccessManager *m_networkManager;
    bool m_isLoading;
    QString m_apiBaseUrl;

    void setIsLoading(bool loading);
    QString getDataFilePath();
};

#endif // HEALTHCIRCLEMANAGER_H
