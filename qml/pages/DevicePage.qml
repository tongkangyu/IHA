import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: devicePage

    property var navigationStack: null

    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color accentColor: "#FF6B35"
    readonly property color deviceBg: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color btnColor: isDarkMode ? "#1E1E20" : "#E5E5EA"
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
                Text { text: "设备"; font.pixelSize: 24; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
                Item { width: parent.width - 184; height: 1 }
                Rectangle {
                    width: 36; height: 36; radius: 18; color: scanMA.pressed ? pressedColor : btnColor; anchors.verticalCenter: parent.verticalCenter
                    Text { anchors.centerIn: parent; text: "O"; font.pixelSize: 14; color: textSecondary }
                    MouseArea { id: scanMA; anchors.fill: parent; onClicked: console.log("Scan") }
                }
                Item { width: 8; height: 1 }
                Rectangle {
                    width: 36; height: 36; radius: 18; color: addMA.pressed ? pressedColor : btnColor; anchors.verticalCenter: parent.verticalCenter
                    Text { anchors.centerIn: parent; text: "+"; font.pixelSize: 22; color: textPrimary }
                    MouseArea { id: addMA; anchors.fill: parent; onClicked: if (navigationStack) navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/AddDevicePage.qml") }
                }
            }
        }

        Flickable {
            width: parent.width
            height: parent.height - 56
            clip: true
            contentWidth: width
            contentHeight: flickContent.height
            boundsBehavior: Flickable.DragOverBounds

            Column {
                id: flickContent
                width: devicePage.width - 32
                x: 16
                spacing: 12

                Rectangle {
                    width: parent.width; height: 72; radius: 20; color: cardColor
                    Row {
                        anchors.fill: parent; anchors.margins: 16; spacing: 14
                        Rectangle { width: 40; height: 40; radius: 20; color: accentColor; anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "6"; font.pixelSize: 18; font.weight: Font.Bold; color: "#FFFFFF" } }
                        Column { spacing: 2; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "已连接设备"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "共 6 个设备"; font.pixelSize: 13; color: textSecondary } }
                    }
                }

                Text { text: "我的设备"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary }

                Rectangle {
                    id: watchCard
                    width: parent.width; height: 80; radius: 20; color: cardColor
                    Row {
                        anchors.fill: parent; anchors.margins: 14; spacing: 12
                        Rectangle { width: 44; height: 44; radius: 12; color: deviceBg; anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "W"; font.pixelSize: 18; font.weight: Font.Bold; color: "#FF6B35" } }
                        Column { spacing: 2; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "REDMI Watch 6"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                            Text { text: "Xiaomi \u00B7 REDMI Watch 6"; font.pixelSize: 11; color: textSecondary }
                            Row { spacing: 6
                                Rectangle { width: 6; height: 6; radius: 3; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "已连接 \u00B7 44%"; font.pixelSize: 12; color: "#22C55E" } } } }
                    Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: ">"; font.pixelSize: 20; color: textSecondary }
                    MouseArea { anchors.fill: parent; onClicked: {
                        if (navigationStack) { var pos = watchCard.mapToItem(null, 0, 0)
                            navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/DeviceDetailPage.qml", pos.x, pos.y, watchCard.width, watchCard.height) } } }
                }

                Rectangle {
                    id: scaleCard
                    width: parent.width; height: 80; radius: 20; color: cardColor
                    Row {
                        anchors.fill: parent; anchors.margins: 14; spacing: 12
                        Rectangle { width: 44; height: 44; radius: 12; color: deviceBg; anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "S"; font.pixelSize: 18; font.weight: Font.Bold; color: "#7D5FFF" } }
                        Column { spacing: 2; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "小米体脂秤 S400"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                            Text { text: "Xiaomi \u00B7 S400"; font.pixelSize: 11; color: textSecondary }
                            Row { spacing: 6
                                Rectangle { width: 6; height: 6; radius: 3; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "已连接 \u00B7 82%"; font.pixelSize: 12; color: "#22C55E" } } } }
                    Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: ">"; font.pixelSize: 20; color: textSecondary }
                    MouseArea { anchors.fill: parent; onClicked: {
                        if (navigationStack) { var pos = scaleCard.mapToItem(null, 0, 0)
                            navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/DeviceDetailPage.qml", pos.x, pos.y, scaleCard.width, scaleCard.height) } } }
                }

                Rectangle {
                    id: bpCard
                    width: parent.width; height: 80; radius: 20; color: cardColor
                    Row {
                        anchors.fill: parent; anchors.margins: 14; spacing: 12
                        Rectangle { width: 44; height: 44; radius: 12; color: deviceBg; anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "B"; font.pixelSize: 18; font.weight: Font.Bold; color: "#EF4444" } }
                        Column { spacing: 2; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "欧姆龙血压计 J710"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                            Text { text: "Omron \u00B7 J710"; font.pixelSize: 11; color: textSecondary }
                            Row { spacing: 6
                                Rectangle { width: 6; height: 6; radius: 3; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "已连接 \u00B7 65%"; font.pixelSize: 12; color: "#22C55E" } } } }
                    Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: ">"; font.pixelSize: 20; color: textSecondary }
                    MouseArea { anchors.fill: parent; onClicked: {
                        if (navigationStack) { var pos = bpCard.mapToItem(null, 0, 0)
                            navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/DeviceDetailPage.qml", pos.x, pos.y, bpCard.width, bpCard.height) } } }
                }

                Rectangle {
                    id: airCard
                    width: parent.width; height: 80; radius: 20; color: cardColor
                    Row {
                        anchors.fill: parent; anchors.margins: 14; spacing: 12
                        Rectangle { width: 44; height: 44; radius: 12; color: deviceBg; anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "A"; font.pixelSize: 18; font.weight: Font.Bold; color: "#22C55E" } }
                        Column { spacing: 2; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "米家空气净化器 Pro"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                            Text { text: "Xiaomi \u00B7 MJX001"; font.pixelSize: 11; color: textSecondary }
                            Row { spacing: 6
                                Rectangle { width: 6; height: 6; radius: 3; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "已连接 \u00B7 100%"; font.pixelSize: 12; color: "#22C55E" } } } }
                    Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: ">"; font.pixelSize: 20; color: textSecondary }
                    MouseArea { anchors.fill: parent; onClicked: {
                        if (navigationStack) { var pos = airCard.mapToItem(null, 0, 0)
                            navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/DeviceDetailPage.qml", pos.x, pos.y, airCard.width, airCard.height) } } }
                }

                Rectangle {
                    id: homeCard
                    width: parent.width; height: 80; radius: 20; color: cardColor
                    Row {
                        anchors.fill: parent; anchors.margins: 14; spacing: 12
                        Rectangle { width: 44; height: 44; radius: 12; color: deviceBg; anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "H"; font.pixelSize: 18; font.weight: Font.Bold; color: "#3B82F6" } }
                        Column { spacing: 2; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "米家新风系统"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                            Text { text: "Xiaomi \u00B7 MJXFJ-150"; font.pixelSize: 11; color: textSecondary }
                            Row { spacing: 6
                                Rectangle { width: 6; height: 6; radius: 3; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "已连接 \u00B7 100%"; font.pixelSize: 12; color: "#22C55E" } } } }
                    Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: ">"; font.pixelSize: 20; color: textSecondary }
                    MouseArea { anchors.fill: parent; onClicked: {
                        if (navigationStack) { var pos = homeCard.mapToItem(null, 0, 0)
                            navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/DeviceDetailPage.qml", pos.x, pos.y, homeCard.width, homeCard.height) } } }
                }

                Rectangle {
                    id: carCard
                    width: parent.width; height: 80; radius: 20; color: cardColor
                    Row {
                        anchors.fill: parent; anchors.margins: 14; spacing: 12
                        Rectangle { width: 44; height: 44; radius: 12; color: deviceBg; anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "C"; font.pixelSize: 18; font.weight: Font.Bold; color: "#FBBF24" } }
                        Column { spacing: 2; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "车载健康传感器"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                            Text { text: "Xiaomi \u00B7 CAR-S1"; font.pixelSize: 11; color: textSecondary }
                            Row { spacing: 6
                                Rectangle { width: 6; height: 6; radius: 3; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "已连接 \u00B7 100%"; font.pixelSize: 12; color: "#22C55E" } } } }
                    Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: ">"; font.pixelSize: 20; color: textSecondary }
                    MouseArea { anchors.fill: parent; onClicked: {
                        if (navigationStack) { var pos = carCard.mapToItem(null, 0, 0)
                            navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/DeviceDetailPage.qml", pos.x, pos.y, carCard.width, carCard.height) } } }
                }

                Text { text: "环境与家居"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary }

                Rectangle {
                    id: envCard
                    width: parent.width; height: 120; radius: 20; color: cardColor
                    Column {
                        anchors.fill: parent; anchors.margins: 14; spacing: 8
                        Row { spacing: 8
                            Text { text: "H"; font.pixelSize: 14; font.weight: Font.Bold; color: "#3B82F6" }
                            Text { text: "室内环境"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary; anchors.verticalCenter: parent.verticalCenter } }
                        Row { width: parent.width; spacing: 8
                            Rectangle { width: (parent.width - 16) / 3; height: 44; radius: 12; color: deviceBg
                                Column { anchors.centerIn: parent; spacing: 1
                                    Text { text: "24.5\u00B0C"; font.pixelSize: 13; font.weight: Font.Bold; color: textPrimary }
                                    Text { text: "温度"; font.pixelSize: 10; color: textSecondary } } }
                            Rectangle { width: (parent.width - 16) / 3; height: 44; radius: 12; color: deviceBg
                                Column { anchors.centerIn: parent; spacing: 1
                                    Text { text: "55%"; font.pixelSize: 13; font.weight: Font.Bold; color: textPrimary }
                                    Text { text: "湿度"; font.pixelSize: 10; color: textSecondary } } }
                            Rectangle { width: (parent.width - 16) / 3; height: 44; radius: 12; color: deviceBg
                                Column { anchors.centerIn: parent; spacing: 1
                                    Text { text: "35"; font.pixelSize: 13; font.weight: Font.Bold; color: "#22C55E" }
                                    Text { text: "PM2.5"; font.pixelSize: 10; color: textSecondary } } } }
                    }
                    MouseArea { anchors.fill: parent; onClicked: {
                        if (navigationStack) { var pos = envCard.mapToItem(null, 0, 0)
                            navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/EnvironmentPage.qml", pos.x, pos.y, envCard.width, envCard.height) } } }
                }

                Text { text: "快捷控制"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary }

                Rectangle {
                    width: parent.width; radius: 16; color: cardColor
                    height: qcCol.height + 16
                    Column {
                        id: qcCol
                        width: parent.width
                        y: 8
                        Rectangle { width: parent.width; height: 44; color: qc1MA.pressed ? pressedColor : "transparent"
                            RowLayout { anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 16; spacing: 10
                                Rectangle { width: 26; height: 26; radius: 7; color: "#FF6B35"; Layout.alignment: Qt.AlignVCenter
                                    Text { anchors.centerIn: parent; text: "L"; font.pixelSize: 12; font.weight: Font.Bold; color: "#FFFFFF" } }
                                Column { spacing: 0; Layout.alignment: Qt.AlignVCenter
                                    Text { text: "智能场景联动"; font.pixelSize: 14; color: textPrimary }
                                    Text { text: "CO2升高自动开新风"; font.pixelSize: 10; color: textSecondary } }
                                Item { Layout.fillWidth: true }
                                Text { text: ">"; font.pixelSize: 18; color: textSecondary; Layout.alignment: Qt.AlignVCenter } }
                            MouseArea { id: qc1MA; anchors.fill: parent; onClicked: console.log("Scene") } }

                        Rectangle { height: 1; color: dividerColor; x: 44; width: parent.width - 56 }

                        Rectangle { width: parent.width; height: 44; color: qc2MA.pressed ? pressedColor : "transparent"
                            RowLayout { anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 16; spacing: 10
                                Rectangle { width: 26; height: 26; radius: 7; color: "#7D5FFF"; Layout.alignment: Qt.AlignVCenter
                                    Text { anchors.centerIn: parent; text: "G"; font.pixelSize: 12; font.weight: Font.Bold; color: "#FFFFFF" } }
                                Column { spacing: 0; Layout.alignment: Qt.AlignVCenter
                                    Text { text: "设备分组管理"; font.pixelSize: 14; color: textPrimary }
                                    Text { text: "按房间分组控制"; font.pixelSize: 10; color: textSecondary } }
                                Item { Layout.fillWidth: true }
                                Text { text: ">"; font.pixelSize: 18; color: textSecondary; Layout.alignment: Qt.AlignVCenter } }
                            MouseArea { id: qc2MA; anchors.fill: parent; onClicked: console.log("Group") } }

                        Rectangle { height: 1; color: dividerColor; x: 44; width: parent.width - 56 }

                        Rectangle { width: parent.width; height: 44; color: qc3MA.pressed ? pressedColor : "transparent"
                            RowLayout { anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 16; spacing: 10
                                Rectangle { width: 26; height: 26; radius: 7; color: "#3B82F6"; Layout.alignment: Qt.AlignVCenter
                                    Text { anchors.centerIn: parent; text: "U"; font.pixelSize: 12; font.weight: Font.Bold; color: "#FFFFFF" } }
                                Column { spacing: 0; Layout.alignment: Qt.AlignVCenter
                                    Text { text: "固件更新"; font.pixelSize: 14; color: textPrimary }
                                    Text { text: "1个设备可更新"; font.pixelSize: 10; color: textSecondary } }
                                Item { Layout.fillWidth: true }
                                Text { text: ">"; font.pixelSize: 18; color: textSecondary; Layout.alignment: Qt.AlignVCenter } }
                            MouseArea { id: qc3MA; anchors.fill: parent; onClicked: console.log("Update") } }

                        Rectangle { height: 1; color: dividerColor; x: 44; width: parent.width - 56 }

                        Rectangle { width: parent.width; height: 44; color: qc4MA.pressed ? pressedColor : "transparent"
                            RowLayout { anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 16; spacing: 10
                                Rectangle { width: 26; height: 26; radius: 7; color: "#22C55E"; Layout.alignment: Qt.AlignVCenter
                                    Text { anchors.centerIn: parent; text: "D"; font.pixelSize: 12; font.weight: Font.Bold; color: "#FFFFFF" } }
                                Column { spacing: 0; Layout.alignment: Qt.AlignVCenter
                                    Text { text: "数据授权管理"; font.pixelSize: 14; color: textPrimary }
                                    Text { text: "管理数据共享权限"; font.pixelSize: 10; color: textSecondary } }
                                Item { Layout.fillWidth: true }
                                Text { text: ">"; font.pixelSize: 18; color: textSecondary; Layout.alignment: Qt.AlignVCenter } }
                            MouseArea { id: qc4MA; anchors.fill: parent; onClicked: if (navigationStack) navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/DataAuthorizationPage.qml") } }

                        Rectangle { height: 1; color: dividerColor; x: 44; width: parent.width - 56 }

                        Rectangle { width: parent.width; height: 44; color: qc5MA.pressed ? pressedColor : "transparent"
                            RowLayout { anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 16; spacing: 10
                                Rectangle { width: 26; height: 26; radius: 7; color: "#A1A1AA"; Layout.alignment: Qt.AlignVCenter
                                    Text { anchors.centerIn: parent; text: "S"; font.pixelSize: 12; font.weight: Font.Bold; color: "#FFFFFF" } }
                                Column { spacing: 0; Layout.alignment: Qt.AlignVCenter
                                    Text { text: "更多设置"; font.pixelSize: 14; color: textPrimary } }
                                Item { Layout.fillWidth: true }
                                Text { text: ">"; font.pixelSize: 18; color: textSecondary; Layout.alignment: Qt.AlignVCenter } }
                            MouseArea { id: qc5MA; anchors.fill: parent; onClicked: console.log("Settings") } }
                    }
                }

                Item { width: 1; height: 24 }
            }
        }
    }
}
