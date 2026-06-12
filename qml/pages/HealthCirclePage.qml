import QtQuick
import QtQuick.Controls

Item {
    id: healthCirclePage
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
    property var memberList: typeof healthCircleManager !== 'undefined' ? healthCircleManager.members : null

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
                Text { text: "健康圈"; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
                Item { width: parent.width - 160; height: 1 }
                Rectangle {
                    width: 36; height: 36; radius: 18; color: addMA.pressed ? pressedColor : deviceBg; anchors.verticalCenter: parent.verticalCenter
                    Text { anchors.centerIn: parent; text: "+"; font.pixelSize: 22; color: textPrimary }
                    MouseArea { id: addMA; anchors.fill: parent; onClicked: inviteDialog.visible = true }
                }
            }
        }
        ScrollView {
            width: parent.width; height: parent.height - 56; clip: true
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            Column {
                width: healthCirclePage.width; spacing: 16; padding: 16
                Rectangle {
                    width: parent.width - 32; height: 80; radius: 20; color: cardColor; anchors.horizontalCenter: parent.horizontalCenter
                    Row { anchors.fill: parent; anchors.margins: 18; spacing: 14
                        Rectangle { width: 44; height: 44; radius: 22; color: "#7D5FFF"; anchors.verticalCenter: parent.verticalCenter
                            Text { anchors.centerIn: parent; text: "H"; font.pixelSize: 22; font.weight: Font.Bold; color: "#FFFFFF" } }
                        Column { spacing: 4; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "我的健康圈"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                            Text { text: (memberList ? memberList.rowCount() : 0) + " 位成员"; font.pixelSize: 13; color: textSecondary } } }
                }
                Repeater {
                    model: memberList
                    delegate: Rectangle {
                        width: healthCirclePage.width - 32; height: 100; radius: 20; color: memberMA.pressed ? pressedColor : cardColor; anchors.horizontalCenter: parent.horizontalCenter
                        scale: memberMA.pressed ? 0.98 : 1.0; Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                        Row { anchors.fill: parent; anchors.margins: 16; spacing: 14
                            Rectangle { width: 52; height: 52; radius: 26; color: index % 2 === 0 ? "#7D5FFF" : "#3B82F6"; anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: model.name.charAt(0); font.pixelSize: 22; font.weight: Font.Bold; color: "#FFFFFF" }
                                Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; width: 14; height: 14; radius: 7; color: model.isOnline ? "#22C55E" : "#71717A"; border.width: 2; border.color: cardColor } }
                            Column { spacing: 4; anchors.verticalCenter: parent.verticalCenter
                                Row { spacing: 8
                                    Text { text: model.name; font.pixelSize: 17; font.weight: Font.DemiBold; color: textPrimary }
                                    Rectangle { width: 40; height: 18; radius: 9; color: isDarkMode ? "#2A2A3A" : "#E0E0F5"
                                        Text { anchors.centerIn: parent; text: model.relationship; font.pixelSize: 10; color: "#7D5FFF" } } }
                                Text { text: model.isOnline ? "在线" : "离线"; font.pixelSize: 13; color: model.isOnline ? "#22C55E" : textSecondary }
                                Row { spacing: 4
                                    Text { text: "步数"; font.pixelSize: 11; color: textSecondary }
                                    Text { text: (model.healthSummary && model.healthSummary.steps) ? model.healthSummary.steps : "--"; font.pixelSize: 11; color: textPrimary; font.weight: Font.Medium }
                                    Text { text: "\u00B7"; font.pixelSize: 11; color: textSecondary }
                                    Text { text: "心率"; font.pixelSize: 11; color: textSecondary }
                                    Text { text: (model.healthSummary && model.healthSummary.heartRate) ? model.healthSummary.heartRate : "--"; font.pixelSize: 11; color: textPrimary; font.weight: Font.Medium } } } }
                        MouseArea { id: memberMA; anchors.fill: parent; onClicked: if (navigationStack) navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/DataAuthorizationPage.qml") }
                    }
                }
                Item { width: 1; height: 24 }
            }
        }
    }
    Rectangle {
        id: inviteDialog; visible: false; anchors.fill: parent; color: "#80000000"; z: 100
        MouseArea { anchors.fill: parent; onClicked: inviteDialog.visible = false }
        Rectangle {
            width: parent.width - 64; height: 200; radius: 20; color: cardColor; anchors.centerIn: parent
            Column { anchors.fill: parent; anchors.margins: 20; spacing: 16
                Text { text: "邀请成员"; font.pixelSize: 18; font.weight: Font.Bold; color: textPrimary }
                Rectangle { width: parent.width; height: 44; radius: 12; color: deviceBg
                    TextEdit { id: invitePhone; anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12; font.pixelSize: 14; color: textPrimary; verticalAlignment: TextEdit.AlignVCenter; inputMethodHints: Qt.ImhDialableCharactersOnly
                        Text { anchors.fill: parent; font.pixelSize: 14; color: textSecondary; text: (!invitePhone.activeFocus && invitePhone.text.length === 0) ? "输入手机号" : ""; verticalAlignment: Text.AlignVCenter } } }
                Rectangle { width: parent.width; height: 44; radius: 12; color: deviceBg
                    TextEdit { id: inviteRelation; anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12; font.pixelSize: 14; color: textPrimary; verticalAlignment: TextEdit.AlignVCenter
                        Text { anchors.fill: parent; font.pixelSize: 14; color: textSecondary; text: (!inviteRelation.activeFocus && inviteRelation.text.length === 0) ? "关系（如：母亲、父亲、医生）" : ""; verticalAlignment: Text.AlignVCenter } } }
                Rectangle { width: parent.width; height: 44; radius: 22; color: accentColor
                    Text { anchors.centerIn: parent; text: "发送邀请"; font.pixelSize: 16; font.weight: Font.DemiBold; color: "#FFFFFF" }
                    MouseArea { anchors.fill: parent; onClicked: { inviteDialog.visible = false } } }
            }
        }
    }
}
