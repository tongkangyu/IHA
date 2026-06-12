import QtQuick
import QtQuick.Controls

Item {
    id: loginPage
    property var navigationStack: null
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color accentColor: "#FF6B35"
    readonly property color inputBg: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color pressedColor: isDarkMode ? "#303032" : "#F0F0F5"

    property bool isRegisterMode: false

    Rectangle { anchors.fill: parent; color: bgColor }

    Column {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            width: parent.width; height: 56; color: headerColor
            Row {
                anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 16
                Rectangle {
                    width: 36; height: 36; radius: 18; color: backMA.pressed ? pressedColor : "transparent"; anchors.verticalCenter: parent.verticalCenter
                    Text { anchors.centerIn: parent; text: "<"; font.pixelSize: 24; font.weight: Font.Bold; color: textPrimary }
                    MouseArea { id: backMA; anchors.fill: parent; onClicked: if (navigationStack) navigationStack.goBack() }
                }
                Text { text: "账户与登录"; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
            }
        }

        Column {
            width: parent.width
            anchors.top: parent.top; anchors.topMargin: 56
            leftPadding: 32; rightPadding: 32; topPadding: 32; bottomPadding: 32
            spacing: 16

            Rectangle {
                width: 64; height: 64; radius: 16; color: accentColor
                Text { anchors.centerIn: parent; text: "H"; font.pixelSize: 32; font.weight: Font.Bold; color: "#FFFFFF" }
            }

            Text { text: "全生态健康守护"; font.pixelSize: 28; font.weight: Font.Bold; color: textPrimary }

            Text { text: "人\u00B7车\u00B7家 全场景智能健康管理平台"; font.pixelSize: 14; color: textSecondary }

            Item { width: 1; height: 16 }

            TextField {
                id: phoneInput
                width: parent.width - 64
                height: 52
                font.pixelSize: 16
                color: textPrimary
                placeholderText: "手机号"
                placeholderTextColor: textSecondary
                horizontalAlignment: TextInput.AlignLeft
                verticalAlignment: TextInput.AlignVCenter
                inputMethodHints: Qt.ImhDialableCharactersOnly
                background: Rectangle { radius: 14; color: inputBg; border.width: 0 }
                leftPadding: 16; rightPadding: 16
            }

            TextField {
                id: passwordInput
                width: parent.width - 64
                height: 52
                font.pixelSize: 16
                color: textPrimary
                placeholderText: "密码"
                placeholderTextColor: textSecondary
                horizontalAlignment: TextInput.AlignLeft
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                background: Rectangle { radius: 14; color: inputBg; border.width: 0 }
                leftPadding: 16; rightPadding: 48
                Rectangle {
                    anchors.right: parent.right; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter
                    width: 36; height: 36; radius: 18; color: "transparent"
                    Text { anchors.centerIn: parent; text: passwordInput.echoMode === TextInput.Password ? "S" : "H"; font.pixelSize: 14; color: textSecondary }
                    MouseArea { anchors.fill: parent; onClicked: passwordInput.echoMode = passwordInput.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password }
                }
            }

            TextField {
                id: nameInput
                width: parent.width - 64
                height: 52
                font.pixelSize: 16
                color: textPrimary
                placeholderText: "昵称"
                placeholderTextColor: textSecondary
                horizontalAlignment: TextInput.AlignLeft
                verticalAlignment: TextInput.AlignVCenter
                visible: isRegisterMode
                opacity: isRegisterMode ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                background: Rectangle { radius: 14; color: inputBg; border.width: 0 }
                leftPadding: 16; rightPadding: 16
            }

            Item { width: 1; height: 8 }

            Rectangle {
                width: parent.width - 64; height: 52; radius: 26; color: accentColor
                scale: loginBtnMA.pressed ? 0.98 : 1.0
                Behavior on scale { SpringAnimation { spring: 3.0; damping: 0.5 } }
                Text { anchors.centerIn: parent; text: isRegisterMode ? "注册" : "登录"; font.pixelSize: 16; font.weight: Font.DemiBold; color: "#FFFFFF" }
                MouseArea {
                    id: loginBtnMA; anchors.fill: parent
                    onClicked: {
                        if (phoneInput.text.trim() === "" || passwordInput.text.trim() === "") return
                        if (isRegisterMode) {
                            if (nameInput.text.trim() === "") return
                            if (typeof userService !== 'undefined') userService.registerUser(phoneInput.text.trim(), passwordInput.text, nameInput.text.trim())
                        } else {
                            if (typeof userService !== 'undefined') userService.login(phoneInput.text.trim(), passwordInput.text)
                        }
                    }
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 4
                Text { text: isRegisterMode ? "已有账号？" : "没有账号？"; font.pixelSize: 14; color: textSecondary }
                Text {
                    text: isRegisterMode ? "去登录" : "立即注册"; font.pixelSize: 14; color: accentColor
                    MouseArea { anchors.fill: parent; onClicked: isRegisterMode = !isRegisterMode }
                }
            }

            Item { width: 1; height: 16 }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 12
                Rectangle { width: 80; height: 1; color: isDarkMode ? "#27272A" : "#E5E5EA"; anchors.verticalCenter: parent.verticalCenter }
                Text { text: "其他方式"; font.pixelSize: 12; color: textSecondary }
                Rectangle { width: 80; height: 1; color: isDarkMode ? "#27272A" : "#E5E5EA"; anchors.verticalCenter: parent.verticalCenter }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 24
                Rectangle {
                    width: 48; height: 48; radius: 24; color: cardColor
                    Text { anchors.centerIn: parent; text: "W"; font.pixelSize: 20; font.weight: Font.Bold; color: "#07C160" }
                    MouseArea { anchors.fill: parent; onClicked: console.log("WeChat login") }
                }
                Rectangle {
                    width: 48; height: 48; radius: 24; color: cardColor
                    Text { anchors.centerIn: parent; text: "A"; font.pixelSize: 20; font.weight: Font.Bold; color: "#1A1A1A" }
                    MouseArea { anchors.fill: parent; onClicked: console.log("Apple login") }
                }
            }

            Item { width: 1; height: 24 }
        }
    }
}
