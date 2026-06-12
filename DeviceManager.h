#ifndef DEVICEMANAGER_H
#define DEVICEMANAGER_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QVariantMap>
#include <QTimer>
#include <QDateTime>

struct DeviceInfo {
    QString deviceId;
    QString name;
    QString type;
    QString manufacturer;
    QString model;
    int battery;
    bool isConnected;
    bool isOnline;
    QString firmwareVersion;
    QString lastSyncTime;
    QVariantMap capabilities;
    QVariantMap sensorData;
};

class DeviceModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum DeviceRoles {
        DeviceIdRole = Qt::UserRole + 1,
        NameRole,
        TypeRole,
        ManufacturerRole,
        ModelRole,
        BatteryRole,
        IsConnectedRole,
        IsOnlineRole,
        FirmwareVersionRole,
        LastSyncRole,
        CapabilitiesRole,
        SensorDataRole,
        IconRole,
        StatusTextRole
    };

    explicit DeviceModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addDevice(const DeviceInfo &device);
    void removeDevice(const QString &deviceId);
    void updateDevice(const QString &deviceId, const DeviceInfo &device);
    void clear();
    DeviceInfo getDevice(int index) const;
    int findDevice(const QString &deviceId) const;

private:
    QList<DeviceInfo> m_devices;
};

class DeviceManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(DeviceModel* devices READ devices CONSTANT)
    Q_PROPERTY(int connectedCount READ connectedCount NOTIFY devicesChanged)
    Q_PROPERTY(int onlineCount READ onlineCount NOTIFY devicesChanged)
    Q_PROPERTY(bool isScanning READ isScanning NOTIFY scanningChanged)
    Q_PROPERTY(QString lastSyncTime READ lastSyncTime NOTIFY syncStatusChanged)

public:
    explicit DeviceManager(QObject *parent = nullptr);
    ~DeviceManager();

    DeviceModel* devices() { return &m_deviceModel; }
    int connectedCount() const;
    int onlineCount() const;
    bool isScanning() const { return m_isScanning; }
    QString lastSyncTime() const { return m_lastSyncTime; }

    Q_INVOKABLE void startScan();
    Q_INVOKABLE void stopScan();
    Q_INVOKABLE void connectDevice(const QString &deviceId);
    Q_INVOKABLE void disconnectDevice(const QString &deviceId);
    Q_INVOKABLE void removeDevice(const QString &deviceId);
    Q_INVOKABLE void syncDevice(const QString &deviceId);
    Q_INVOKABLE void syncAllDevices();
    Q_INVOKABLE void sendCommand(const QString &deviceId, const QString &command, const QVariantMap &params);
    Q_INVOKABLE QVariantMap getDeviceSensorData(const QString &deviceId);
    Q_INVOKABLE QVariantMap getEnvironmentData();
    Q_INVOKABLE void loadDevices();
    Q_INVOKABLE void saveDevices();
    Q_INVOKABLE void generateSampleDevices();

signals:
    void devicesChanged();
    void scanningChanged();
    void syncStatusChanged();
    void deviceFound(const QString &deviceId, const QString &name, const QString &type);
    void deviceConnected(const QString &deviceId);
    void deviceDisconnected(const QString &deviceId);
    void deviceSyncCompleted(const QString &deviceId);
    void deviceSyncFailed(const QString &deviceId, const QString &error);
    void sensorDataUpdated(const QString &deviceId, const QVariantMap &data);
    void commandSent(const QString &deviceId, const QString &command);
    void commandFailed(const QString &deviceId, const QString &command, const QString &error);

private:
    DeviceModel m_deviceModel;
    bool m_isScanning;
    QString m_lastSyncTime;
    QTimer *m_scanTimer;
    QTimer *m_sensorUpdateTimer;

    void setIsScanning(bool scanning);
    void onScanTimeout();
    void onSensorUpdateTimeout();
    void updateEnvironmentFromSensors();
    QString getDeviceIcon(const QString &type) const;
    QString getDataFilePath();
};

#endif // DEVICEMANAGER_H
