import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: addDevicePage
    property var navigationStack: null
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color accentColor: "#FF6B35"
    readonly property color deviceBg: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color pressedColor: isDarkMode ? "#303032" : "#F0F0F5"
    property string lastAddedDevice: ""

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
                Text { text: "添加设备"; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
            }
        }
        ScrollView {
            width: parent.width; height: parent.height - 56; clip: true
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            Column {
                width: addDevicePage.width; spacing: 16; padding: 16
                Rectangle {
                    width: parent.width - 32; height: 72; radius: 20; color: cardColor; anchors.horizontalCenter: parent.horizontalCenter
                    Row {
                        anchors.fill: parent; anchors.margins: 16; spacing: 14
                        Rectangle {
                            width: 40; height: 40; radius: 20; color: accentColor; anchors.verticalCenter: parent.verticalCenter
                            SequentialAnimation on scale { running: true; loops: Animation.Infinite
                                NumberAnimation { from: 1.0; to: 1.08; duration: 800; easing.type: Easing.InOutQuad }
                                NumberAnimation { from: 1.08; to: 1.0; duration: 800; easing.type: Easing.InOutQuad } }
                            Text { anchors.centerIn: parent; text: "S"; font.pixelSize: 20; color: "#FFFFFF" }
                        }
                        Column { spacing: 2; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "正在扫描附近设备..."; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "请确保设备已开机且蓝牙已开启"; font.pixelSize: 12; color: textSecondary } }
                    }
                }
                Text { text: "可穿戴设备"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary; x: 16 }
                Repeater {
                    model: [
                        { name: "智能手表/手环", icon: "W", type: "watch" },
                        { name: "体脂秤", icon: "S", type: "scale" },
                        { name: "血压计", icon: "B", type: "blood_pressure" },
                        { name: "体温计", icon: "T", type: "thermometer" }
                    ]
                    delegate: Rectangle {
                        width: addDevicePage.width - 32; height: 60; radius: 16; color: devMA.pressed ? pressedColor : cardColor; anchors.horizontalCenter: parent.horizontalCenter
                        scale: devMA.pressed ? 0.98 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                        RowLayout { anchors.fill: parent; anchors.margins: 14; spacing: 12
                            Rectangle { width: 36; height: 36; radius: 10; color: deviceBg; Layout.alignment: Qt.AlignVCenter
                                Text { anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 16; font.weight: Font.Bold; color: textPrimary } }
                            Text { text: modelData.name; font.pixelSize: 15; color: textPrimary; Layout.alignment: Qt.AlignVCenter }
                            Item { Layout.fillWidth: true }
                            Rectangle { width: 28; height: 28; radius: 14; color: accentColor; Layout.alignment: Qt.AlignVCenter
                                Text { anchors.centerIn: parent; text: "+"; font.pixelSize: 18; color: "#FFFFFF" } } }
                        MouseArea { id: devMA; anchors.fill: parent; onClicked: { addSuccessToast.visible = true; addSuccessTimer.start() } }
                    }
                }
                Text { text: "环境与家居"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary; x: 16 }
                Repeater {
                    model: [
                        { name: "空气净化器", icon: "A", type: "air_quality" },
                        { name: "新风系统", icon: "H", type: "smart_home" },
                        { name: "温湿度传感器", icon: "T", type: "sensor" },
                        { name: "智能灯/插座", icon: "L", type: "light" }
                    ]
                    delegate: Rectangle {
                        width: addDevicePage.width - 32; height: 60; radius: 16; color: devMA2.pressed ? pressedColor : cardColor; anchors.horizontalCenter: parent.horizontalCenter
                        scale: devMA2.pressed ? 0.98 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                        RowLayout { anchors.fill: parent; anchors.margins: 14; spacing: 12
                            Rectangle { width: 36; height: 36; radius: 10; color: deviceBg; Layout.alignment: Qt.AlignVCenter
                                Text { anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 16; font.weight: Font.Bold; color: textPrimary } }
                            Text { text: modelData.name; font.pixelSize: 15; color: textPrimary; Layout.alignment: Qt.AlignVCenter }
                            Item { Layout.fillWidth: true }
                            Rectangle { width: 28; height: 28; radius: 14; color: accentColor; Layout.alignment: Qt.AlignVCenter
                                Text { anchors.centerIn: parent; text: "+"; font.pixelSize: 18; color: "#FFFFFF" } } }
                        MouseArea { id: devMA2; anchors.fill: parent; onClicked: { addSuccessToast.visible = true; addSuccessTimer.start() } }
                    }
                }
                Text { text: "车载设备"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary; x: 16 }
                Repeater {
                    model: [
                        { name: "车载传感器", icon: "C", type: "car" },
                        { name: "行车记录仪", icon: "D", type: "dashcam" }
                    ]
                    delegate: Rectangle {
                        width: addDevicePage.width - 32; height: 60; radius: 16; color: devMA3.pressed ? pressedColor : cardColor; anchors.horizontalCenter: parent.horizontalCenter
                        scale: devMA3.pressed ? 0.98 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                        RowLayout { anchors.fill: parent; anchors.margins: 14; spacing: 12
                            Rectangle { width: 36; height: 36; radius: 10; color: deviceBg; Layout.alignment: Qt.AlignVCenter
                                Text { anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 16; font.weight: Font.Bold; color: textPrimary } }
                            Text { text: modelData.name; font.pixelSize: 15; color: textPrimary; Layout.alignment: Qt.AlignVCenter }
                            Item { Layout.fillWidth: true }
                            Rectangle { width: 28; height: 28; radius: 14; color: accentColor; Layout.alignment: Qt.AlignVCenter
                                Text { anchors.centerIn: parent; text: "+"; font.pixelSize: 18; color: "#FFFFFF" } } }
                        MouseArea { id: devMA3; anchors.fill: parent; onClicked: { addSuccessToast.visible = true; addSuccessTimer.start() } }
                    }
                }
                Item { width: 1; height: 24 }
            }
        }
    }
    Timer { id: addSuccessTimer; interval: 1500; repeat: false; onTriggered: addSuccessToast.visible = false }
    Rectangle {
        id: addSuccessToast; visible: false; anchors.bottom: parent.bottom; anchors.bottomMargin: 80; anchors.horizontalCenter: parent.horizontalCenter
        width: 200; height: 44; radius: 22; color: "#22C55E"; z: 100
        Text { anchors.centerIn: parent; text: "V 设备添加成功"; font.pixelSize: 14; font.weight: Font.Medium; color: "#FFFFFF" }
    }
}
