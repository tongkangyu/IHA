import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: consultationPage
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
                Text { text: "在线问诊"; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
            }
        }
        ScrollView {
            width: parent.width; height: parent.height - 56; clip: true
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            Column {
                width: consultationPage.width; spacing: 16; padding: 16
                Rectangle {
                    width: parent.width - 32; height: 80; radius: 16; color: isDarkMode ? "#1A2A1A" : "#E0F5E0"; anchors.horizontalCenter: parent.horizontalCenter
                    Row { anchors.fill: parent; anchors.margins: 14; spacing: 10
                        Text { text: "D"; font.pixelSize: 20; font.weight: Font.Bold; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                        Column { spacing: 4; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "合作医疗机构在线问诊"; font.pixelSize: 15; font.weight: Font.Medium; color: "#22C55E" }
                            Text { text: "可一键授权医生查看您的健康数据"; font.pixelSize: 12; color: textSecondary } } }
                }
                Text { text: "选择科室"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary; x: 16 }
                Row {
                    width: parent.width - 32; x: 16; spacing: 8
                    Repeater {
                        model: [
                            { name: "内科", icon: "I" },
                            { name: "心血管科", icon: "C" },
                            { name: "骨科", icon: "O" },
                            { name: "皮肤科", icon: "K" }
                        ]
                        delegate: Rectangle {
                            width: (parent.width - 24) / 4; height: 72; radius: 14; color: deptMA.pressed ? pressedColor : cardColor
                            scale: deptMA.pressed ? 0.95 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                            Column { anchors.centerIn: parent; spacing: 4
                                Text { text: modelData.icon; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: modelData.name; font.pixelSize: 12; color: textPrimary; anchors.horizontalCenter: parent.horizontalCenter } }
                            MouseArea { id: deptMA; anchors.fill: parent; onClicked: console.log("Selected:", modelData.name) }
                        }
                    }
                }
                Text { text: "推荐医生"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary; x: 16 }
                Repeater {
                    model: [
                        { name: "张医生", dept: "内科", title: "主任医师", rating: 4.8, online: true },
                        { name: "李医生", dept: "心血管科", title: "副主任医师", rating: 4.6, online: true },
                        { name: "王医生", dept: "骨科", title: "主治医师", rating: 4.5, online: false }
                    ]
                    delegate: Rectangle {
                        width: consultationPage.width - 32; height: 80; radius: 16; color: docMA.pressed ? pressedColor : cardColor; anchors.horizontalCenter: parent.horizontalCenter
                        scale: docMA.pressed ? 0.98 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                        RowLayout { anchors.fill: parent; anchors.margins: 14; spacing: 12
                            Rectangle { width: 48; height: 48; radius: 24; color: index % 2 === 0 ? "#3B82F6" : "#7D5FFF"; Layout.alignment: Qt.AlignVCenter
                                Text { anchors.centerIn: parent; text: modelData.name.charAt(0); font.pixelSize: 20; font.weight: Font.Bold; color: "#FFFFFF" } }
                            Column { spacing: 4; Layout.alignment: Qt.AlignVCenter
                                Row { spacing: 6
                                    Text { text: modelData.name; font.pixelSize: 16; font.weight: Font.DemiBold; color: textPrimary }
                                    Text { text: modelData.title; font.pixelSize: 12; color: textSecondary } }
                                Row { spacing: 6
                                    Text { text: "*" + modelData.rating; font.pixelSize: 12; color: "#FBBF24" }
                                    Rectangle { width: 8; height: 8; radius: 4; color: modelData.online ? "#22C55E" : "#71717A"; anchors.verticalCenter: parent.verticalCenter }
                                    Text { text: modelData.online ? "在线" : "离线"; font.pixelSize: 12; color: modelData.online ? "#22C55E" : textSecondary } } }
                            Item { Layout.fillWidth: true }
                            Rectangle { width: 64; height: 32; radius: 16; color: modelData.online ? accentColor : deviceBg; Layout.alignment: Qt.AlignVCenter
                                Text { anchors.centerIn: parent; text: modelData.online ? "问诊" : "预约"; font.pixelSize: 13; color: "#FFFFFF" }
                                MouseArea { anchors.fill: parent; onClicked: console.log("Consult:", modelData.name) } } }
                        MouseArea { id: docMA; anchors.fill: parent }
                    }
                }
                Text { text: "问诊记录"; font.pixelSize: 14; font.weight: Font.Medium; color: textSecondary; x: 16 }
                Rectangle {
                    width: parent.width - 32; height: 72; radius: 16; color: cardColor; anchors.horizontalCenter: parent.horizontalCenter
                    Column { anchors.centerIn: parent; spacing: 4
                        Text { text: "暂无问诊记录"; font.pixelSize: 14; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: "开始您的第一次在线问诊"; font.pixelSize: 12; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter } }
                }
                Item { width: 1; height: 24 }
            }
        }
    }
}
