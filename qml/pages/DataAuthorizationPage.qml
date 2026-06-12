import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: dataAuthPage
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
    property bool toggleSteps: true
    property bool toggleHeartRate: true
    property bool toggleSleep: false
    property bool toggleBloodPressure: false
    property bool toggleBloodOxygen: false
    property bool toggleWeight: true
    property bool toggleLocation: false
    property bool toggleEnvironment: true

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
                Text { text: "数据授权"; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
            }
        }
        Flickable {
            width: parent.width; height: parent.height - 56; clip: true
            contentWidth: width; contentHeight: daContent.height; boundsBehavior: Flickable.DragOverBounds
            Column {
                id: daContent; width: dataAuthPage.width - 32; x: 16; spacing: 10; padding: 16
                Rectangle {
                    width: parent.width - 32; height: 72; radius: 16; color: isDarkMode ? "#1A2A3A" : "#E0F0FF"
                    Row { anchors.fill: parent; anchors.margins: 14; spacing: 10
                        Text { text: "L"; font.pixelSize: 16; font.weight: Font.Bold; color: "#3B82F6"; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "您可以精细控制每位成员可查看的数据类型和时间范围"; font.pixelSize: 13; color: "#3B82F6"; wrapMode: Text.Wrap; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 50 } }
                }
                ToggleRow { title: "步数数据"; desc: "每日步数、目标完成率"; icon: "R"; iconColor: "#FF6B35"; isOn: toggleSteps; onToggle: toggleSteps = !toggleSteps }
                ToggleRow { title: "心率数据"; desc: "实时心率、静息心率"; icon: "H"; iconColor: "#EF4444"; isOn: toggleHeartRate; onToggle: toggleHeartRate = !toggleHeartRate }
                ToggleRow { title: "睡眠数据"; desc: "睡眠时长、睡眠质量"; icon: "M"; iconColor: "#7D5FFF"; isOn: toggleSleep; onToggle: toggleSleep = !toggleSleep }
                ToggleRow { title: "血压数据"; desc: "收缩压、舒张压"; icon: "B"; iconColor: "#EF4444"; isOn: toggleBloodPressure; onToggle: toggleBloodPressure = !toggleBloodPressure }
                ToggleRow { title: "血氧数据"; desc: "血氧饱和度"; icon: "O"; iconColor: "#3B82F6"; isOn: toggleBloodOxygen; onToggle: toggleBloodOxygen = !toggleBloodOxygen }
                ToggleRow { title: "体重数据"; desc: "体重、BMI、体脂率"; icon: "S"; iconColor: "#7D5FFF"; isOn: toggleWeight; onToggle: toggleWeight = !toggleWeight }
                ToggleRow { title: "位置信息"; desc: "实时位置、运动轨迹"; icon: "P"; iconColor: "#22C55E"; isOn: toggleLocation; onToggle: toggleLocation = !toggleLocation }
                ToggleRow { title: "环境数据"; desc: "室内温湿度、空气质量"; icon: "E"; iconColor: "#3B82F6"; isOn: toggleEnvironment; onToggle: toggleEnvironment = !toggleEnvironment }
                Item { width: 1; height: 24 }
            }
        }
    }

    component ToggleRow: Rectangle {
        width: parent.width - 32; height: 64; radius: 16; color: dataAuthPage.cardColor
        property string title: ""; property string desc: ""; property string icon: ""; property color iconColor: "#FF6B35"
        property bool isOn: false; signal toggle()
        RowLayout {
            anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; spacing: 12
            Rectangle { width: 36; height: 36; radius: 10; color: dataAuthPage.deviceBg; Layout.alignment: Qt.AlignVCenter
                Text { anchors.centerIn: parent; text: icon; font.pixelSize: 16; font.weight: Font.Bold; color: iconColor } }
            Column { spacing: 2; Layout.alignment: Qt.AlignVCenter
                Text { text: title; font.pixelSize: 15; font.weight: Font.Medium; color: dataAuthPage.textPrimary }
                Text { text: desc; font.pixelSize: 11; color: dataAuthPage.textSecondary } }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 48; height: 28; radius: 14; Layout.alignment: Qt.AlignVCenter
                color: isOn ? dataAuthPage.accentColor : (dataAuthPage.isDarkMode ? "#3A3A3C" : "#D0D0D0")
                Behavior on color { ColorAnimation { duration: 200 } }
                Rectangle {
                    x: isOn ? parent.width - 24 : 4; y: 2; width: 24; height: 24; radius: 12; color: "#FFFFFF"
                    Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                }
                MouseArea { anchors.fill: parent; onClicked: toggle() }
            }
        }
    }
}
