#include "DeviceManager.h"
#include <QDebug>
#include <QRandomGenerator>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

DeviceModel::DeviceModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int DeviceModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_devices.count();
}

QVariant DeviceModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_devices.count())
        return QVariant();

    const DeviceInfo &device = m_devices[index.row()];

    switch (role) {
    case DeviceIdRole:
        return device.deviceId;
    case NameRole:
        return device.name;
    case TypeRole:
        return device.type;
    case ManufacturerRole:
        return device.manufacturer;
    case ModelRole:
        return device.model;
    case BatteryRole:
        return device.battery;
    case IsConnectedRole:
        return device.isConnected;
    case IsOnlineRole:
        return device.isOnline;
    case FirmwareVersionRole:
        return device.firmwareVersion;
    case LastSyncRole:
        return device.lastSyncTime;
    case CapabilitiesRole:
        return device.capabilities;
    case SensorDataRole:
        return device.sensorData;
    case IconRole: {
        if (device.type == "watch") return QString::fromUtf8("\xF0\x9F\x95\x90");
        if (device.type == "scale") return QString::fromUtf8("\xF0\x9B\x92\x96");
        if (device.type == "blood_pressure") return QString::fromUtf8("\xF0\x9F\x92\x89");
        if (device.type == "thermometer") return QString::fromUtf8("\xF0\x9F\x8C\xA1");
        if (device.type == "air_quality") return QString::fromUtf8("\xF0\x9F\x8C\xAC");
        if (device.type == "smart_home") return QString::fromUtf8("\xF0\x9F\x8F\xA0");
        if (device.type == "car") return QString::fromUtf8("\xF0\x9F\x9A\x97");
        return QString::fromUtf8("\xF0\x9F\x93\xB1");
    }
    case StatusTextRole:
        if (device.isConnected) return QString::fromUtf8("\xE5\xB7\xB2\xE8\xBF\x9E\xE6\x8E\xA5");
        if (device.isOnline) return QString::fromUtf8("\xE5\x9C\xA8\xE7\xBA\xBF");
        return QString::fromUtf8("\xE6\x9C\xAA\xE8\xBF\x9E\xE6\x8E\xA5");
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> DeviceModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DeviceIdRole] = "deviceId";
    roles[NameRole] = "name";
    roles[TypeRole] = "deviceType";
    roles[ManufacturerRole] = "manufacturer";
    roles[ModelRole] = "model";
    roles[BatteryRole] = "battery";
    roles[IsConnectedRole] = "isConnected";
    roles[IsOnlineRole] = "isOnline";
    roles[FirmwareVersionRole] = "firmwareVersion";
    roles[LastSyncRole] = "lastSync";
    roles[CapabilitiesRole] = "capabilities";
    roles[SensorDataRole] = "sensorData";
    roles[IconRole] = "icon";
    roles[StatusTextRole] = "statusText";
    return roles;
}

void DeviceModel::addDevice(const DeviceInfo &device)
{
    beginInsertRows(QModelIndex(), m_devices.count(), m_devices.count());
    m_devices.append(device);
    endInsertRows();
}

void DeviceModel::removeDevice(const QString &deviceId)
{
    int idx = findDevice(deviceId);
    if (idx >= 0) {
        beginRemoveRows(QModelIndex(), idx, idx);
        m_devices.removeAt(idx);
        endRemoveRows();
    }
}

void DeviceModel::updateDevice(const QString &deviceId, const DeviceInfo &device)
{
    int idx = findDevice(deviceId);
    if (idx >= 0) {
        m_devices[idx] = device;
        emit dataChanged(index(idx), index(idx));
    }
}

void DeviceModel::clear()
{
    beginResetModel();
    m_devices.clear();
    endResetModel();
}

DeviceInfo DeviceModel::getDevice(int index) const
{
    if (index >= 0 && index < m_devices.count())
        return m_devices[index];
    return DeviceInfo();
}

int DeviceModel::findDevice(const QString &deviceId) const
{
    for (int i = 0; i < m_devices.count(); ++i) {
        if (m_devices[i].deviceId == deviceId)
            return i;
    }
    return -1;
}

DeviceManager::DeviceManager(QObject *parent)
    : QObject(parent)
    , m_isScanning(false)
    , m_scanTimer(new QTimer(this))
    , m_sensorUpdateTimer(new QTimer(this))
{
    m_scanTimer->setSingleShot(true);
    connect(m_scanTimer, &QTimer::timeout, this, &DeviceManager::onScanTimeout);

    m_sensorUpdateTimer->setInterval(30000);
    m_sensorUpdateTimer->stop();

    loadDevices();

    if (m_deviceModel.rowCount() == 0) {
        generateSampleDevices();
    }
}

DeviceManager::~DeviceManager()
{
    saveDevices();
}

int DeviceManager::connectedCount() const
{
    int count = 0;
    for (int i = 0; i < m_deviceModel.rowCount(); ++i) {
        if (m_deviceModel.getDevice(i).isConnected)
            count++;
    }
    return count;
}

int DeviceManager::onlineCount() const
{
    int count = 0;
    for (int i = 0; i < m_deviceModel.rowCount(); ++i) {
        if (m_deviceModel.getDevice(i).isOnline)
            count++;
    }
    return count;
}

void DeviceManager::startScan()
{
    if (m_isScanning) return;

    setIsScanning(true);
    m_scanTimer->start(5000);

    qDebug() << "DeviceManager: Scanning for devices...";
}

void DeviceManager::stopScan()
{
    setIsScanning(false);
    m_scanTimer->stop();
}

void DeviceManager::connectDevice(const QString &deviceId)
{
    int idx = m_deviceModel.findDevice(deviceId);
    if (idx < 0) return;

    DeviceInfo device = m_deviceModel.getDevice(idx);
    device.isConnected = true;
    device.isOnline = true;
    m_deviceModel.updateDevice(deviceId, device);

    emit deviceConnected(deviceId);
    emit devicesChanged();
    saveDevices();
}

void DeviceManager::disconnectDevice(const QString &deviceId)
{
    int idx = m_deviceModel.findDevice(deviceId);
    if (idx < 0) return;

    DeviceInfo device = m_deviceModel.getDevice(idx);
    device.isConnected = false;
    m_deviceModel.updateDevice(deviceId, device);

    emit deviceDisconnected(deviceId);
    emit devicesChanged();
    saveDevices();
}

void DeviceManager::removeDevice(const QString &deviceId)
{
    m_deviceModel.removeDevice(deviceId);
    emit devicesChanged();
    saveDevices();
}

void DeviceManager::syncDevice(const QString &deviceId)
{
    int idx = m_deviceModel.findDevice(deviceId);
    if (idx < 0) return;

    DeviceInfo device = m_deviceModel.getDevice(idx);
    if (!device.isConnected) {
        emit deviceSyncFailed(deviceId, "Device not connected");
        return;
    }

    device.lastSyncTime = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
    m_deviceModel.updateDevice(deviceId, device);

    m_lastSyncTime = device.lastSyncTime;
    emit syncStatusChanged();
    emit deviceSyncCompleted(deviceId);
    saveDevices();
}

void DeviceManager::syncAllDevices()
{
    for (int i = 0; i < m_deviceModel.rowCount(); ++i) {
        DeviceInfo device = m_deviceModel.getDevice(i);
        if (device.isConnected) {
            syncDevice(device.deviceId);
        }
    }
}

void DeviceManager::sendCommand(const QString &deviceId, const QString &command, const QVariantMap &params)
{
    int idx = m_deviceModel.findDevice(deviceId);
    if (idx < 0) {
        emit commandFailed(deviceId, command, "Device not found");
        return;
    }

    DeviceInfo device = m_deviceModel.getDevice(idx);
    if (!device.isConnected) {
        emit commandFailed(deviceId, command, "Device not connected");
        return;
    }

    qDebug() << "DeviceManager: Sending command" << command << "to" << deviceId << "params:" << params;
    emit commandSent(deviceId, command);
}

QVariantMap DeviceManager::getDeviceSensorData(const QString &deviceId)
{
    int idx = m_deviceModel.findDevice(deviceId);
    if (idx < 0) return QVariantMap();
    return m_deviceModel.getDevice(idx).sensorData;
}

QVariantMap DeviceManager::getEnvironmentData()
{
    QVariantMap envData;
    double avgTemp = 0, avgHumidity = 0, avgCo2 = 0, avgPm25 = 0;
    int envCount = 0;

    for (int i = 0; i < m_deviceModel.rowCount(); ++i) {
        DeviceInfo device = m_deviceModel.getDevice(i);
        if (device.type == "air_quality" || device.type == "smart_home") {
            QVariantMap data = device.sensorData;
            if (data.contains("temperature")) { avgTemp += data["temperature"].toDouble(); envCount++; }
            if (data.contains("humidity")) avgHumidity += data["humidity"].toDouble();
            if (data.contains("co2")) avgCo2 += data["co2"].toDouble();
            if (data.contains("pm25")) avgPm25 += data["pm25"].toDouble();
        }
    }

    if (envCount > 0) {
        avgTemp /= envCount;
        avgHumidity /= envCount;
    }

    envData["temperature"] = avgTemp > 0 ? avgTemp : 24.5;
    envData["humidity"] = avgHumidity > 0 ? avgHumidity : 55.0;
    envData["co2"] = avgCo2 > 0 ? avgCo2 : 420;
    envData["pm25"] = avgPm25 > 0 ? avgPm25 : 35;
    envData["airQuality"] = avgPm25 < 35 ? "good" : avgPm25 < 75 ? "moderate" : "poor";

    return envData;
}

void DeviceManager::loadDevices()
{
    QString filePath = getDataFilePath();
    QFile file(filePath);

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();

        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject root = doc.object();

            if (root["version"].toInt() < 2) {
                qDebug() << "DeviceManager: Data version outdated, regenerating";
                return;
            }

            QJsonArray devicesArray = root["devices"].toArray();

            for (int i = 0; i < devicesArray.count(); ++i) {
                QJsonObject obj = devicesArray[i].toObject();
                DeviceInfo device;
                device.deviceId = obj["deviceId"].toString();
                device.name = obj["name"].toString();
                device.type = obj["type"].toString();
                device.manufacturer = obj["manufacturer"].toString();
                device.model = obj["model"].toString();
                device.battery = obj["battery"].toInt();
                device.isConnected = obj["isConnected"].toBool();
                device.isOnline = obj["isOnline"].toBool();
                device.firmwareVersion = obj["firmwareVersion"].toString();
                device.lastSyncTime = obj["lastSyncTime"].toString();
                device.capabilities = obj["capabilities"].toObject().toVariantMap();
                device.sensorData = obj["sensorData"].toObject().toVariantMap();

                m_deviceModel.addDevice(device);
            }

            qDebug() << "DeviceManager: Loaded" << devicesArray.count() << "devices";
            emit devicesChanged();
        }
    }
}

void DeviceManager::saveDevices()
{
    QString filePath = getDataFilePath();
    QFile file(filePath);

    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject root;
        QJsonArray devicesArray;

        for (int i = 0; i < m_deviceModel.rowCount(); ++i) {
            DeviceInfo device = m_deviceModel.getDevice(i);
            QJsonObject obj;
            obj["deviceId"] = device.deviceId;
            obj["name"] = device.name;
            obj["type"] = device.type;
            obj["manufacturer"] = device.manufacturer;
            obj["model"] = device.model;
            obj["battery"] = device.battery;
            obj["isConnected"] = device.isConnected;
            obj["isOnline"] = device.isOnline;
            obj["firmwareVersion"] = device.firmwareVersion;
            obj["lastSyncTime"] = device.lastSyncTime;
            obj["capabilities"] = QJsonObject::fromVariantMap(device.capabilities);
            obj["sensorData"] = QJsonObject::fromVariantMap(device.sensorData);
            devicesArray.append(obj);
        }

        root["devices"] = devicesArray;
        root["version"] = 2;

        QJsonDocument doc(root);
        file.write(doc.toJson(QJsonDocument::Compact));
        file.close();
    }
}

void DeviceManager::generateSampleDevices()
{
    DeviceInfo watch;
    watch.deviceId = "watch_001";
    watch.name = "REDMI Watch 6";
    watch.type = "watch";
    watch.manufacturer = "Xiaomi";
    watch.model = "REDMI Watch 6";
    watch.battery = 44;
    watch.isConnected = true;
    watch.isOnline = true;
    watch.firmwareVersion = "1.8.2";
    watch.lastSyncTime = "2026-04-18 08:30:00";
    watch.capabilities = QVariantMap{
        {"heartRate", true}, {"steps", true}, {"sleep", true},
        {"bloodOxygen", true}, {"calories", true}, {"activity", true}
    };
    watch.sensorData = QVariantMap{
        {"heartRate", 72}, {"steps", 9580}, {"bloodOxygen", 98},
        {"calories", 568}, {"sleepMinutes", 427}
    };
    m_deviceModel.addDevice(watch);

    DeviceInfo scale;
    scale.deviceId = "scale_001";
    scale.name = "小米体脂秤 S400";
    scale.type = "scale";
    scale.manufacturer = "Xiaomi";
    scale.model = "S400";
    scale.battery = 82;
    scale.isConnected = true;
    scale.isOnline = true;
    scale.firmwareVersion = "2.1.0";
    scale.lastSyncTime = "2026-04-18 07:15:00";
    scale.capabilities = QVariantMap{
        {"weight", true}, {"bodyFat", true}, {"bmi", true},
        {"muscle", true}, {"water", true}
    };
    scale.sensorData = QVariantMap{
        {"weight", 68.5}, {"bodyFat", 18.2}, {"bmi", 22.3},
        {"muscle", 45.8}, {"water", 55.2}
    };
    m_deviceModel.addDevice(scale);

    DeviceInfo airMonitor;
    airMonitor.deviceId = "air_001";
    airMonitor.name = "米家空气净化器 Pro";
    airMonitor.type = "air_quality";
    airMonitor.manufacturer = "Xiaomi";
    airMonitor.model = "MJX001";
    airMonitor.battery = 100;
    airMonitor.isConnected = true;
    airMonitor.isOnline = true;
    airMonitor.firmwareVersion = "3.4.1";
    airMonitor.lastSyncTime = "2026-04-18 09:00:00";
    airMonitor.capabilities = QVariantMap{
        {"pm25", true}, {"temperature", true}, {"humidity", true},
        {"co2", true}, {"control", true}
    };
    airMonitor.sensorData = QVariantMap{
        {"pm25", 35}, {"temperature", 24.5}, {"humidity", 55},
        {"co2", 420}, {"mode", "auto"}
    };
    m_deviceModel.addDevice(airMonitor);

    DeviceInfo bpMonitor;
    bpMonitor.deviceId = "bp_001";
    bpMonitor.name = "欧姆龙血压计 J710";
    bpMonitor.type = "blood_pressure";
    bpMonitor.manufacturer = "Omron";
    bpMonitor.model = "J710";
    bpMonitor.battery = 65;
    bpMonitor.isConnected = true;
    bpMonitor.isOnline = true;
    bpMonitor.firmwareVersion = "1.2.0";
    bpMonitor.lastSyncTime = "2026-04-17 20:00:00";
    bpMonitor.capabilities = QVariantMap{
        {"systolic", true}, {"diastolic", true}, {"pulse", true}
    };
    bpMonitor.sensorData = QVariantMap{
        {"systolic", 120}, {"diastolic", 80}, {"pulse", 72}
    };
    m_deviceModel.addDevice(bpMonitor);

    DeviceInfo smartHome;
    smartHome.deviceId = "home_001";
    smartHome.name = "米家新风系统";
    smartHome.type = "smart_home";
    smartHome.manufacturer = "Xiaomi";
    smartHome.model = "MJXFJ-150";
    smartHome.battery = 100;
    smartHome.isConnected = true;
    smartHome.isOnline = true;
    smartHome.firmwareVersion = "2.0.5";
    smartHome.lastSyncTime = "2026-04-18 08:00:00";
    smartHome.capabilities = QVariantMap{
        {"control", true}, {"temperature", true}, {"humidity", true},
        {"co2", true}, {"mode", true}
    };
    smartHome.sensorData = QVariantMap{
        {"temperature", 23.8}, {"humidity", 52}, {"co2", 380},
        {"mode", "auto"}, {"speed", 2}
    };
    m_deviceModel.addDevice(smartHome);

    DeviceInfo carDevice;
    carDevice.deviceId = "car_001";
    carDevice.name = "车载健康传感器";
    carDevice.type = "car";
    carDevice.manufacturer = "Xiaomi";
    carDevice.model = "CAR-S1";
    carDevice.battery = 100;
    carDevice.isConnected = true;
    carDevice.isOnline = true;
    carDevice.firmwareVersion = "1.0.3";
    carDevice.lastSyncTime = "2026-04-18 08:45:00";
    carDevice.capabilities = QVariantMap{
        {"temperature", true}, {"airQuality", true}, {"drivingTime", true}
    };
    carDevice.sensorData = QVariantMap{
        {"temperature", 26.2}, {"airQuality", "good"}, {"drivingMinutes", 45}
    };
    m_deviceModel.addDevice(carDevice);

    emit devicesChanged();
    saveDevices();
    qDebug() << "DeviceManager: Sample devices generated";
}

void DeviceManager::setIsScanning(bool scanning)
{
    if (m_isScanning != scanning) {
        m_isScanning = scanning;
        emit scanningChanged();
    }
}

void DeviceManager::onScanTimeout()
{
    setIsScanning(false);
    qDebug() << "DeviceManager: Scan completed";
}

void DeviceManager::onSensorUpdateTimeout()
{
    for (int i = 0; i < m_deviceModel.rowCount(); ++i) {
        DeviceInfo device = m_deviceModel.getDevice(i);
        if (device.isConnected) {
            QVariantMap data = device.sensorData;
            if (device.type == "watch") {
                data["heartRate"] = 68 + QRandomGenerator::global()->bounded(15);
                data["steps"] = data["steps"].toInt() + QRandomGenerator::global()->bounded(50);
            } else if (device.type == "air_quality" || device.type == "smart_home") {
                data["temperature"] = 23.0 + QRandomGenerator::global()->bounded(40) / 10.0;
                data["humidity"] = 48 + QRandomGenerator::global()->bounded(15);
                data["co2"] = 380 + QRandomGenerator::global()->bounded(100);
                data["pm25"] = 25 + QRandomGenerator::global()->bounded(30);
            }
            device.sensorData = data;
            m_deviceModel.updateDevice(device.deviceId, device);
            emit sensorDataUpdated(device.deviceId, data);
        }
    }
}

QString DeviceManager::getDeviceIcon(const QString &type) const
{
    Q_UNUSED(type)
    return "";
}

QString DeviceManager::getDataFilePath()
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    return dataPath + "/devices.json";
}
