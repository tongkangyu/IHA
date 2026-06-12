import QtQuick
import QtQuick.Controls

Item {
    id: profilePage

    property var navigationStack: null

    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color btnColor: isDarkMode ? "#1E1E20" : "#E5E5EA"
    readonly property color pressedColor: isDarkMode ? "#2A2A2C" : "#D1D1D6"
    readonly property color dividerColor: isDarkMode ? "#27272A" : "#E5E5EA"
    readonly property color arrowColor: isDarkMode ? "#707070" : "#C7C7CC"

    Column {
        anchors.fill: parent

        Rectangle {
            width: parent.width; height: 56; color: headerColor
            Row {
                anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                Text { text: "我的"; font.pixelSize: 24; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
            }
        }

        ScrollView {
            width: parent.width; height: parent.height - 56; clip: true
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }

            Column {
                width: profilePage.width; spacing: 16

                Rectangle {
                    id: userCard
                    width: parent.width - 32; height: 90; radius: 20
                    color: userCardMouseArea.pressed ? pressedColor : cardColor
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        id: userAvatar; x: 16; width: 58; height: 58; radius: 29; color: "#7D5FFF"; anchors.verticalCenter: parent.verticalCenter
                        Text { anchors.centerIn: parent; text: "U"; font.pixelSize: 28; font.weight: Font.Bold; color: "#FFFFFF" }
                    }

                    Column {
                        anchors.left: userAvatar.right; anchors.leftMargin: 14; anchors.verticalCenter: parent.verticalCenter; spacing: 4
                        Text { text: typeof window !== 'undefined' ? window.userName : "超懒哥"; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary }
                        Text {
                            text: {
                                var gender = typeof window !== 'undefined' ? window.userGender : "男"
                                var h = typeof window !== 'undefined' ? window.userHeight : 175
                                var age = typeof window !== 'undefined' ? window.userAge : 19
                                return gender + " | " + h + "厘米 | " + age + "岁"
                            }
                            font.pixelSize: 13; color: textSecondary
                        }
                    }

                    Text { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: ">"; font.pixelSize: 24; color: arrowColor }

                    MouseArea {
                        id: userCardMouseArea; anchors.fill: parent
                        onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/ProfileInfoPage.qml") }
                    }
                }

                Row {
                    width: parent.width - 32; anchors.horizontalCenter: parent.horizontalCenter; spacing: 8

                    Rectangle {
                        width: (parent.width - 32) / 5; height: 70; radius: 14; color: activitiesMA.pressed ? pressedColor : cardColor
                        Column { anchors.centerIn: parent; spacing: 6
                            Text { text: "R"; font.pixelSize: 20; font.weight: Font.Bold; color: "#FF6B35"; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "我的活动"; font.pixelSize: 11; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter } }
                        MouseArea { id: activitiesMA; anchors.fill: parent; onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyActivitiesPage.qml") } }
                    }

                    Rectangle {
                        width: (parent.width - 32) / 5; height: 70; radius: 14; color: circleMA.pressed ? pressedColor : cardColor
                        Column { anchors.centerIn: parent; spacing: 6
                            Text { text: "H"; font.pixelSize: 20; font.weight: Font.Bold; color: "#EF4444"; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "健康圈"; font.pixelSize: 11; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter } }
                        MouseArea { id: circleMA; anchors.fill: parent; onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/HealthCirclePage.qml") } }
                    }

                    Rectangle {
                        width: (parent.width - 32) / 5; height: 70; radius: 14; color: consultMA.pressed ? pressedColor : cardColor
                        Column { anchors.centerIn: parent; spacing: 6
                            Text { text: "D"; font.pixelSize: 20; font.weight: Font.Bold; color: "#22C55E"; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "在线问诊"; font.pixelSize: 11; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter } }
                        MouseArea { id: consultMA; anchors.fill: parent; onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/OnlineConsultationPage.qml") } }
                    }

                    Rectangle {
                        width: (parent.width - 32) / 5; height: 70; radius: 14; color: coursesMA.pressed ? pressedColor : cardColor
                        Column { anchors.centerIn: parent; spacing: 6
                            Text { text: "B"; font.pixelSize: 20; font.weight: Font.Bold; color: "#3B82F6"; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "我的课程"; font.pixelSize: 11; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter } }
                        MouseArea { id: coursesMA; anchors.fill: parent; onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyCoursesPage.qml") } }
                    }

                    Rectangle {
                        width: (parent.width - 32) / 5; height: 70; radius: 14; color: ordersMA.pressed ? pressedColor : cardColor
                        Column { anchors.centerIn: parent; spacing: 6
                            Text { text: "O"; font.pixelSize: 20; font.weight: Font.Bold; color: "#FBBF24"; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "我的订单"; font.pixelSize: 11; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter } }
                        MouseArea { id: ordersMA; anchors.fill: parent; onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyOrdersPage.qml") } }
                    }
                }

                Row {
                    width: parent.width - 32; anchors.horizontalCenter: parent.horizontalCenter; spacing: 8

                    Rectangle {
                        width: (parent.width - 8) / 2; height: 120; radius: 16; color: cardColor
                        Column { anchors.fill: parent; anchors.margins: 14; spacing: 8
                            Text { text: "小习惯"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                            Text { text: "加入打卡"; font.pixelSize: 12; color: textSecondary }
                            Rectangle {
                                width: parent.width; height: 40; radius: 10; color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                Row { anchors.fill: parent; anchors.margins: 10; spacing: 8
                                    Text { text: "P"; font.pixelSize: 16; font.weight: Font.Bold; color: "#7D5FFF"; anchors.verticalCenter: parent.verticalCenter }
                                    Text { text: "给爸妈打个电话"; font.pixelSize: 13; color: textPrimary; anchors.verticalCenter: parent.verticalCenter } } } }
                        MouseArea { anchors.fill: parent; onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/HabitsPage.qml") } }
                    }

                    Rectangle {
                        width: (parent.width - 8) / 2; height: 120; radius: 16; color: cardColor
                        Column { anchors.fill: parent; anchors.margins: 14; spacing: 8
                            Row { width: parent.width
                                Text { text: "运动健康周报"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                                Item { width: parent.width - 120; height: 1 }
                                Rectangle { width: 8; height: 8; radius: 4; color: "#EF4444"; anchors.verticalCenter: parent.verticalCenter } }
                            Text { text: "02.23 ~ 03.01"; font.pixelSize: 12; color: textSecondary }
                            Rectangle {
                                width: parent.width; height: 40; radius: 10; color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                                Text { text: "W"; font.pixelSize: 20; font.weight: Font.Bold; color: "#3B82F6"; anchors.centerIn: parent } } }
                        MouseArea { anchors.fill: parent; onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/HealthReportPage.qml") } }
                    }
                }

                Rectangle {
                    width: parent.width - 32; height: 130; radius: 20; color: cardColor; anchors.horizontalCenter: parent.horizontalCenter
                    Column { anchors.fill: parent; anchors.margins: 16; spacing: 12
                        Row { width: parent.width - 8
                            Text { text: "我的勋章"; font.pixelSize: 15; font.weight: Font.DemiBold; color: textPrimary }
                            Item { width: parent.width - 100; height: 1 }
                            Text { text: "全部 >"; font.pixelSize: 13; color: textSecondary } }
                        Row { spacing: 12; anchors.horizontalCenter: parent.horizontalCenter
                            Repeater {
                                model: [ { value: "500", name: "500次步数" }, { value: "START", name: "首次游泳" }, { value: "5000", name: "运动达人" }, { value: "365", name: "365次打卡" } ]
                                Column { width: 64; spacing: 4
                                    Rectangle {
                                        width: 52; height: 52; radius: 26
                                        color: index % 2 === 0 ? (isDarkMode ? "#3D2D6B" : "#E8E0F5") : (isDarkMode ? "#2A4A5A" : "#D4E8ED")
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        Text { anchors.centerIn: parent; text: modelData.value; font.pixelSize: modelData.value.length > 3 ? 10 : 14; font.weight: Font.Bold; color: textPrimary } }
                                    Text { text: modelData.name; font.pixelSize: 10; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter } } } } }
                    MouseArea { anchors.fill: parent; onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyBadgesPage.qml") } }
                }

                Rectangle {
                    width: parent.width - 32; height: menuColumn.height + 32; radius: 20; color: cardColor; anchors.horizontalCenter: parent.horizontalCenter; clip: true
                    Column {
                        id: menuColumn; width: parent.width; anchors.top: parent.top; anchors.topMargin: 8

                        MenuItem {
                            width: parent.width; icon: "K"; iconColor: "#22C55E"; title: "数据授权管理"
                            isDarkMode: profilePage.isDarkMode; textPrimary: profilePage.textPrimary; pressedColor: profilePage.pressedColor; arrowColor: profilePage.arrowColor
                            onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/DataAuthorizationPage.qml") }
                        }
                        MenuSeparator { separatorColor: dividerColor }

                        MenuItem {
                            width: parent.width; icon: "I"; iconColor: "#3B82F6"; title: "IoT设备管理"
                            isDarkMode: profilePage.isDarkMode; textPrimary: profilePage.textPrimary; pressedColor: profilePage.pressedColor; arrowColor: profilePage.arrowColor
                            onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/DevicePage.qml") }
                        }
                        MenuSeparator { separatorColor: dividerColor }

                        MenuItem {
                            width: parent.width; icon: "L"; iconColor: "#FF6B35"; title: "账户与登录"
                            isDarkMode: profilePage.isDarkMode; textPrimary: profilePage.textPrimary; pressedColor: profilePage.pressedColor; arrowColor: profilePage.arrowColor
                            onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/LoginPage.qml") }
                        }
                        MenuSeparator { separatorColor: dividerColor }

                        MenuItem {
                            width: parent.width; icon: "G"; iconColor: "#8A7AE6"; title: "App 设置"
                            isDarkMode: profilePage.isDarkMode; textPrimary: profilePage.textPrimary; pressedColor: profilePage.pressedColor; arrowColor: profilePage.arrowColor
                            onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/AppSettingsPage.qml") }
                        }
                        MenuSeparator { separatorColor: dividerColor }

                        MenuItem {
                            width: parent.width; icon: "P"; iconColor: "#81C784"; title: "系统权限"
                            isDarkMode: profilePage.isDarkMode; textPrimary: profilePage.textPrimary; pressedColor: profilePage.pressedColor; arrowColor: profilePage.arrowColor
                            onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/SystemPermissionsPage.qml") }
                        }
                        MenuSeparator { separatorColor: dividerColor }

                        MenuItem {
                            width: parent.width; icon: "F"; iconColor: "#FFB300"; title: "帮助与反馈"
                            isDarkMode: profilePage.isDarkMode; textPrimary: profilePage.textPrimary; pressedColor: profilePage.pressedColor; arrowColor: profilePage.arrowColor
                            onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/HelpFeedbackPage.qml") }
                        }
                        MenuSeparator { separatorColor: dividerColor }

                        MenuItem {
                            width: parent.width; icon: "V"; iconColor: "#8A7AE6"; title: "App 版本"
                            badge: typeof appVersion !== 'undefined' ? appVersion : "0.2.0"
                            isDarkMode: profilePage.isDarkMode; textPrimary: profilePage.textPrimary; textSecondary: profilePage.textSecondary; pressedColor: profilePage.pressedColor
                        }
                        MenuSeparator { separatorColor: dividerColor }

                        MenuItem {
                            width: parent.width; icon: "A"; iconColor: "#64B5F6"; title: "关于"
                            isDarkMode: profilePage.isDarkMode; textPrimary: profilePage.textPrimary; pressedColor: profilePage.pressedColor; arrowColor: profilePage.arrowColor
                            onClicked: { if (profilePage.navigationStack) profilePage.navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/AboutPage.qml") }
                        }
                    }
                }

                Item { width: 1; height: 24 }
            }
        }
    }

    component MenuItem: Rectangle {
        property string icon: ""
        property string iconColor: "#6366F1"
        property string title: ""
        property string badge: ""
        property bool isDarkMode: true
        property color textPrimary: "#FFFFFF"
        property color textSecondary: "#A1A1AA"
        property color pressedColor: "#2A2A2C"
        property color arrowColor: "#707070"

        signal clicked()

        height: 56
        color: itemMouseArea.pressed ? pressedColor : "transparent"

        Rectangle {
            id: menuIcon; x: 16; width: 32; height: 32; radius: 16; color: iconColor; anchors.verticalCenter: parent.verticalCenter
            Text { anchors.centerIn: parent; text: icon; font.pixelSize: 16; font.weight: Font.Bold; color: "#FFFFFF" }
        }

        Text { text: title; font.pixelSize: 16; color: textPrimary; anchors.left: menuIcon.right; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter }

        Text { text: badge; font.pixelSize: 14; color: textSecondary; anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; visible: badge !== "" }

        Text { text: ">"; font.pixelSize: 16; color: arrowColor; anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; visible: badge === "" }

        MouseArea { id: itemMouseArea; anchors.fill: parent; onClicked: parent.clicked() }
    }

    component MenuSeparator: Rectangle {
        property color separatorColor: "#27272A"
        width: parent.width - 60; height: 1; color: separatorColor; anchors.horizontalCenter: parent.horizontalCenter
    }
}
