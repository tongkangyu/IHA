import QtQuick
import QtQuick.Controls

Item {
    id: deviceDetailPage
    property var navigationStack: null
    property string deviceId: ""
    property string deviceName: "设备"
    property string deviceType: "watch"
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color accentColor: "#FF6B35"
    readonly property color deviceBg: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color pressedColor: isDarkMode ? "#303032" : "#F0F0F5"
    readonly property color dividerColor: isDarkMode ? "#27272A" : "#E5E5EA"
    property bool showDisconnectConfirm: false
    property bool showRemoveConfirm: false

    Column {
        anchors.fill: parent
        Rectangle {
            width: parent.width; height: 56; color: headerColor
            Row {
                anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 16
                Rectangle {
                    width: 36; height: 36; radius: 18; color: backMA.pressed ? pressedColor : "transparent"; anchors.verticalCenter: parent.verticalCenter
                    Text { anchors.centerIn: parent; text: "<"; font.pixelSize: 24; font.weight: Font.Bold; color: textPrimary }
                    MouseArea { id: backMA; anchors.fill: parent; onClicked: if (navigationStack) navigationStack.goBack() }
                }
                Text { text: deviceName; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
            }
        }
        ScrollView {
            width: parent.width; height: parent.height - 56; clip: true
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            Column {
                width: deviceDetailPage.width; spacing: 16; padding: 16
                Rectangle {
                    width: parent.width - 32; height: 140; radius: 24; color: cardColor; anchors.horizontalCenter: parent.horizontalCenter
                    Column { anchors.centerIn: parent; spacing: 10
                        Rectangle { width: 56; height: 56; radius: 28; color: accentColor; anchors.horizontalCenter: parent.horizontalCenter
                            Text { anchors.centerIn: parent; text: "W"; font.pixelSize: 28; color: "#FFFFFF" } }
                        Text { text: deviceName; font.pixelSize: 18; font.weight: Font.Bold; color: textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                        Row { spacing: 8; anchors.horizontalCenter: parent.horizontalCenter
                            Rectangle { width: 8; height: 8; radius: 4; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "已连接 \u00B7 电量 44%"; font.pixelSize: 13; color: "#22C55E" } } }
                }
                Rectangle {
                    width: parent.width - 32; radius: 16; color: cardColor; anchors.horizontalCenter: parent.horizontalCenter
                    Column {
                        width: parent.width
                        Repeater {
                            model: [
                                { title: "设备名称", value: deviceName },
                                { title: "制造商", value: "Xiaomi" },
                                { title: "型号", value: "REDMI Watch 6" },
                                { title: "固件版本", value: "1.8.2" },
                                { title: "蓝牙地址", value: "XX:XX:XX:XX:XX" },
                                { title: "序列号", value: "SN-XXXX-XXXX" }
                            ]
                            delegate: Rectangle {
                                width: deviceDetailPage.width - 32; height: 44; color: "transparent"
                                Rectangle { visible: index > 0; anchors.top: parent.top; anchors.left: parent.left; anchors.leftMargin: 16; width: parent.width - 32; height: 1; color: dividerColor }
                                Row { anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                                    Text { text: modelData.title; font.pixelSize: 14; color: textSecondary; anchors.verticalCenter: parent.verticalCenter }
                                    Item { width: parent.width - 200; height: 1 }
                                    Text { text: modelData.value; font.pixelSize: 14; color: textPrimary; anchors.verticalCenter: parent.verticalCenter } }
                            }
                        }
                    }
                }
                Rectangle {
                    width: parent.width - 32; height: 48; radius: 14; color: syncBtnMA.pressed ? "#E55A2B" : accentColor; anchors.horizontalCenter: parent.horizontalCenter
                    scale: syncBtnMA.pressed ? 0.98 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                    Text { anchors.centerIn: parent; text: "同步数据"; font.pixelSize: 16; font.weight: Font.DemiBold; color: "#FFFFFF" }
                    MouseArea { id: syncBtnMA; anchors.fill: parent; onClicked: { syncToast.visible = true; syncTimer.start() } }
                }
                Rectangle {
                    width: parent.width - 32; height: 48; radius: 14; color: disconnectMA.pressed ? pressedColor : deviceBg; anchors.horizontalCenter: parent.horizontalCenter
                    scale: disconnectMA.pressed ? 0.98 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                    Text { anchors.centerIn: parent; text: "断开连接"; font.pixelSize: 16; color: "#EF4444" }
                    MouseArea { id: disconnectMA; anchors.fill: parent; onClicked: showDisconnectConfirm = true }
                }
                Rectangle {
                    width: parent.width - 32; height: 48; radius: 14; color: removeMA.pressed ? pressedColor : deviceBg; anchors.horizontalCenter: parent.horizontalCenter
                    scale: removeMA.pressed ? 0.98 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                    Text { anchors.centerIn: parent; text: "移除设备"; font.pixelSize: 16; color: "#EF4444" }
                    MouseArea { id: removeMA; anchors.fill: parent; onClicked: showRemoveConfirm = true }
                }
                Item { width: 1; height: 24 }
            }
        }
    }
    Timer { id: syncTimer; interval: 1500; repeat: false; onTriggered: syncToast.visible = false }
    Rectangle {
        id: syncToast; visible: false; anchors.bottom: parent.bottom; anchors.bottomMargin: 80; anchors.horizontalCenter: parent.horizontalCenter
        width: 180; height: 44; radius: 22; color: "#22C55E"; z: 100
        Text { anchors.centerIn: parent; text: "V 同步完成"; font.pixelSize: 14; font.weight: Font.Medium; color: "#FFFFFF" }
    }
    Rectangle {
        id: disconnectConfirmDialog; visible: showDisconnectConfirm; anchors.fill: parent; color: "#80000000"; z: 100
        MouseArea { anchors.fill: parent; onClicked: showDisconnectConfirm = false }
        Rectangle {
            width: parent.width - 64; height: 160; radius: 20; color: cardColor; anchors.centerIn: parent
            Column { anchors.fill: parent; anchors.margins: 20; spacing: 16
                Text { text: "断开连接"; font.pixelSize: 18; font.weight: Font.Bold; color: textPrimary }
                Text { text: "确定要断开 " + deviceName + " 的连接吗？断开后将无法实时获取数据。"; font.pixelSize: 14; color: textSecondary; wrapMode: Text.Wrap; width: parent.width }
                Row { width: parent.width; spacing: 12
                    Rectangle { width: (parent.width - 12) / 2; height: 40; radius: 20; color: deviceBg
                        Text { anchors.centerIn: parent; text: "取消"; font.pixelSize: 14; color: textPrimary }
                        MouseArea { anchors.fill: parent; onClicked: showDisconnectConfirm = false } }
                    Rectangle { width: (parent.width - 12) / 2; height: 40; radius: 20; color: "#EF4444"
                        Text { anchors.centerIn: parent; text: "断开"; font.pixelSize: 14; font.weight: Font.DemiBold; color: "#FFFFFF" }
                        MouseArea { anchors.fill: parent; onClicked: { showDisconnectConfirm = false; if (navigationStack) navigationStack.goBack() } } } } } }
    }
    Rectangle {
        id: removeConfirmDialog; visible: showRemoveConfirm; anchors.fill: parent; color: "#80000000"; z: 100
        MouseArea { anchors.fill: parent; onClicked: showRemoveConfirm = false }
        Rectangle {
            width: parent.width - 64; height: 160; radius: 20; color: cardColor; anchors.centerIn: parent
            Column { anchors.fill: parent; anchors.margins: 20; spacing: 16
                Text { text: "移除设备"; font.pixelSize: 18; font.weight: Font.Bold; color: "#EF4444" }
                Text { text: "确定要移除 " + deviceName + " 吗？移除后需要重新配对才能连接。"; font.pixelSize: 14; color: textSecondary; wrapMode: Text.Wrap; width: parent.width }
                Row { width: parent.width; spacing: 12
                    Rectangle { width: (parent.width - 12) / 2; height: 40; radius: 20; color: deviceBg
                        Text { anchors.centerIn: parent; text: "取消"; font.pixelSize: 14; color: textPrimary }
                        MouseArea { anchors.fill: parent; onClicked: showRemoveConfirm = false } }
                    Rectangle { width: (parent.width - 12) / 2; height: 40; radius: 20; color: "#EF4444"
                        Text { anchors.centerIn: parent; text: "移除"; font.pixelSize: 14; font.weight: Font.DemiBold; color: "#FFFFFF" }
                        MouseArea { anchors.fill: parent; onClicked: { showRemoveConfirm = false; if (navigationStack) navigationStack.goBack() } } } } } }
    }
}
