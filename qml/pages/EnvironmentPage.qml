import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: envPage
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
    readonly property color dividerColor: isDarkMode ? "#27272A" : "#E5E5EA"

    Rectangle { anchors.fill: parent; color: bgColor }

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
                Text { text: "室内环境"; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
            }
        }

        Flickable {
            width: parent.width; height: parent.height - 56; clip: true
            contentWidth: width; contentHeight: envContent.height; boundsBehavior: Flickable.DragOverBounds

            Column {
                id: envContent; width: envPage.width - 32; x: 16; spacing: 12; padding: 16

                Rectangle {
                    width: parent.width - 32; height: 100; radius: 20; color: isDarkMode ? "#1A3A2A" : "#E0F5E8"
                    Column {
                        anchors.centerIn: parent; spacing: 4
                        Text { text: "空气质量：优"; font.pixelSize: 20; font.weight: Font.Bold; color: "#22C55E"; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: "所有指标正常，环境舒适"; font.pixelSize: 13; color: "#22C55E"; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }

                Text { text: "实时数据"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary }

                Row {
                    width: parent.width - 32; spacing: 8
                    Rectangle {
                        width: (parent.width - 16) / 3; height: 80; radius: 16; color: cardColor
                        Column { anchors.centerIn: parent; spacing: 4
                            Text { text: "24.5\u00B0C"; font.pixelSize: 18; font.weight: Font.Bold; color: "#FF6B35" }
                            Text { text: "温度"; font.pixelSize: 12; color: textSecondary } }
                    }
                    Rectangle {
                        width: (parent.width - 16) / 3; height: 80; radius: 16; color: cardColor
                        Column { anchors.centerIn: parent; spacing: 4
                            Text { text: "55%"; font.pixelSize: 18; font.weight: Font.Bold; color: "#3B82F6" }
                            Text { text: "湿度"; font.pixelSize: 12; color: textSecondary } }
                    }
                    Rectangle {
                        width: (parent.width - 16) / 3; height: 80; radius: 16; color: cardColor
                        Column { anchors.centerIn: parent; spacing: 4
                            Text { text: "35"; font.pixelSize: 18; font.weight: Font.Bold; color: "#22C55E" }
                            Text { text: "PM2.5"; font.pixelSize: 12; color: textSecondary } }
                    }
                }

                Row {
                    width: parent.width - 32; spacing: 8
                    Rectangle {
                        width: (parent.width - 16) / 3; height: 80; radius: 16; color: cardColor
                        Column { anchors.centerIn: parent; spacing: 4
                            Text { text: "420 ppm"; font.pixelSize: 18; font.weight: Font.Bold; color: "#22C55E" }
                            Text { text: "CO2"; font.pixelSize: 12; color: textSecondary } }
                    }
                    Rectangle {
                        width: (parent.width - 16) / 3; height: 80; radius: 16; color: cardColor
                        Column { anchors.centerIn: parent; spacing: 4
                            Text { text: "0.03 mg/m3"; font.pixelSize: 16; font.weight: Font.Bold; color: "#22C55E" }
                            Text { text: "甲醛"; font.pixelSize: 12; color: textSecondary } }
                    }
                    Rectangle {
                        width: (parent.width - 16) / 3; height: 80; radius: 16; color: cardColor
                        Column { anchors.centerIn: parent; spacing: 4
                            Text { text: "800 lux"; font.pixelSize: 18; font.weight: Font.Bold; color: "#FBBF24" }
                            Text { text: "光照"; font.pixelSize: 12; color: textSecondary } }
                    }
                }

                Text { text: "环境设备"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary }

                Rectangle {
                    width: parent.width - 32; height: 64; radius: 16; color: cardColor
                    RowLayout { anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 12
                        Rectangle { width: 36; height: 36; radius: 10; color: deviceBg; Layout.alignment: Qt.AlignVCenter
                            Text { anchors.centerIn: parent; text: "A"; font.pixelSize: 16; font.weight: Font.Bold; color: "#22C55E" } }
                        Column { spacing: 2; Layout.alignment: Qt.AlignVCenter
                            Text { text: "米家空气净化器 Pro"; font.pixelSize: 14; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "运行中 \u00B7 自动模式"; font.pixelSize: 11; color: "#22C55E" } }
                        Item { Layout.fillWidth: true }
                        Rectangle { width: 40; height: 24; radius: 12; color: "#22C55E"
                            Text { anchors.centerIn: parent; text: "ON"; font.pixelSize: 10; font.weight: Font.Bold; color: "#FFFFFF" } } }
                }

                Rectangle {
                    width: parent.width - 32; height: 64; radius: 16; color: cardColor
                    RowLayout { anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 12
                        Rectangle { width: 36; height: 36; radius: 10; color: deviceBg; Layout.alignment: Qt.AlignVCenter
                            Text { anchors.centerIn: parent; text: "H"; font.pixelSize: 16; font.weight: Font.Bold; color: "#3B82F6" } }
                        Column { spacing: 2; Layout.alignment: Qt.AlignVCenter
                            Text { text: "米家新风系统"; font.pixelSize: 14; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "运行中 \u00B7 低速模式"; font.pixelSize: 11; color: "#22C55E" } }
                        Item { Layout.fillWidth: true }
                        Rectangle { width: 40; height: 24; radius: 12; color: "#22C55E"
                            Text { anchors.centerIn: parent; text: "ON"; font.pixelSize: 10; font.weight: Font.Bold; color: "#FFFFFF" } } }
                }

                Text { text: "智能场景"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary }

                Rectangle {
                    width: parent.width - 32; height: 56; radius: 16; color: cardColor
                    RowLayout { anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 12
                        Rectangle { width: 32; height: 32; radius: 10; color: accentColor; Layout.alignment: Qt.AlignVCenter
                            Text { anchors.centerIn: parent; text: "L"; font.pixelSize: 14; font.weight: Font.Bold; color: "#FFFFFF" } }
                        Text { text: "CO2升高自动开新风"; font.pixelSize: 14; color: textPrimary; Layout.alignment: Qt.AlignVCenter }
                        Item { Layout.fillWidth: true }
                        Rectangle { width: 40; height: 24; radius: 12; color: accentColor
                            Text { anchors.centerIn: parent; text: "ON"; font.pixelSize: 10; font.weight: Font.Bold; color: "#FFFFFF" } } }
                }

                Rectangle {
                    width: parent.width - 32; height: 56; radius: 16; color: cardColor
                    RowLayout { anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 12
                        Rectangle { width: 32; height: 32; radius: 10; color: "#7D5FFF"; Layout.alignment: Qt.AlignVCenter
                            Text { anchors.centerIn: parent; text: "S"; font.pixelSize: 14; font.weight: Font.Bold; color: "#FFFFFF" } }
                        Text { text: "睡眠模式 \u00B7 自动调暗灯光"; font.pixelSize: 14; color: textPrimary; Layout.alignment: Qt.AlignVCenter }
                        Item { Layout.fillWidth: true }
                        Rectangle { width: 40; height: 24; radius: 12; color: "#7D5FFF"
                            Text { anchors.centerIn: parent; text: "ON"; font.pixelSize: 10; font.weight: Font.Bold; color: "#FFFFFF" } } }
                }

                Item { width: 1; height: 24 }
            }
        }
    }
}
