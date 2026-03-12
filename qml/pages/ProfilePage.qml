import QtQuick
import QtQuick.Controls

Item {
    id: profilePage
    
    // 使用全局主题
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
        
        // 顶部标题栏
        Rectangle {
            width: parent.width
            height: 56
            color: headerColor
            
            Row {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                
                Text {
                    text: "我的"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            
            // 右上角添加按钮
            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: addMouseArea.pressed ? pressedColor : btnColor
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "+"
                    font.pixelSize: 20
                    color: textPrimary
                }
                
                MouseArea {
                    id: addMouseArea
                    anchors.fill: parent
                }
            }
        }
        
        ScrollView {
            width: parent.width
            height: parent.height - 56
            clip: true
            
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            
            Column {
                width: profilePage.width
                spacing: 16
                
                // 用户信息卡片
                Rectangle {
                    id: userCard
                    width: parent.width - 32
                    height: 90
                    radius: 20
                    color: userCardMouseArea.pressed ? pressedColor : cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    // 头像
                    Rectangle {
                        id: userAvatar
                        x: 16
                        width: 58
                        height: 58
                        radius: 29
                        color: "#7D5FFF"
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: "👤"
                            font.pixelSize: 28
                        }
                    }
                    
                    // 用户名和描述
                    Column {
                        anchors.left: userAvatar.right
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4
                        
                        Text {
                            text: typeof window !== 'undefined' ? window.userName : "超懒哥"
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        Text {
                            text: {
                                var gender = typeof window !== 'undefined' ? window.userGender : "男"
                                var height = typeof window !== 'undefined' ? window.userHeight : 175
                                var age = typeof window !== 'undefined' ? window.userAge : 19
                                return gender + " | " + height + "厘米 | " + age + "岁"
                            }
                            font.pixelSize: 13
                            color: textSecondary
                        }
                    }
                    
                    // 右箭头
                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        text: "›"
                        font.pixelSize: 24
                        color: arrowColor
                    }
                    
                    MouseArea {
                        id: userCardMouseArea
                        anchors.fill: parent
                        onClicked: {
                            navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/ProfileInfoPage.qml")
                        }
                    }
                }
                
                // 快捷入口
                Row {
                    width: parent.width - 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8
                    
                    // 我的活动
                    Rectangle {
                        width: (parent.width - 24) / 4
                        height: 70
                        radius: 14
                        color: activitiesMA.pressed ? pressedColor : cardColor
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Text { text: "🏃"; font.pixelSize: 24; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "我的活动"; font.pixelSize: 12; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                        MouseArea { id: activitiesMA; anchors.fill: parent; onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyActivitiesPage.qml") }
                    }
                    
                    // 我的课程
                    Rectangle {
                        width: (parent.width - 24) / 4
                        height: 70
                        radius: 14
                        color: coursesMA.pressed ? pressedColor : cardColor
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Text { text: "📚"; font.pixelSize: 24; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "我的课程"; font.pixelSize: 12; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                        MouseArea { id: coursesMA; anchors.fill: parent; onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyCoursesPage.qml") }
                    }
                    
                    // 我的订单
                    Rectangle {
                        width: (parent.width - 24) / 4
                        height: 70
                        radius: 14
                        color: ordersMA.pressed ? pressedColor : cardColor
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Text { text: "📄"; font.pixelSize: 24; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "我的订单"; font.pixelSize: 12; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                        MouseArea { id: ordersMA; anchors.fill: parent; onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyOrdersPage.qml") }
                    }
                    
                    // 我的亲友
                    Rectangle {
                        width: (parent.width - 24) / 4
                        height: 70
                        radius: 14
                        color: familyMA.pressed ? pressedColor : cardColor
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Text { text: "❤️"; font.pixelSize: 24; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "我的亲友"; font.pixelSize: 12; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                        MouseArea { id: familyMA; anchors.fill: parent; onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyFamilyFriendsPage.qml") }
                    }
                }
                
                // 小习惯 + 运动健康周报
                Row {
                    width: parent.width - 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8
                    
                    // 小习惯
                    Rectangle {
                        width: (parent.width - 8) / 2
                        height: 120
                        radius: 16
                        color: cardColor
                        
                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 8
                            
                            Text {
                                text: "小习惯"
                                font.pixelSize: 15
                                font.weight: Font.DemiBold
                                color: textPrimary
                            }
                            
                            Text {
                                text: "加入打卡"
                                font.pixelSize: 12
                                color: textSecondary
                            }
                            
                            // 习惯卡片
                            Rectangle {
                                width: parent.width
                                height: 40
                                radius: 10
                                color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                
                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 8
                                    
                                    Text {
                                        text: "📞"
                                        font.pixelSize: 18
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    
                                    Text {
                                        text: "给爸妈打个电话"
                                        font.pixelSize: 13
                                        color: textPrimary
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }
                        
                        MouseArea { anchors.fill: parent; onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/HabitsPage.qml") }
                    }
                    
                    // 运动健康周报
                    Rectangle {
                        width: (parent.width - 8) / 2
                        height: 120
                        radius: 16
                        color: cardColor
                        
                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 8
                            
                            Row {
                                width: parent.width
                                
                                Text {
                                    text: "运动健康周报"
                                    font.pixelSize: 15
                                    font.weight: Font.DemiBold
                                    color: textPrimary
                                }
                                
                                Item { width: parent.width - 120; height: 1 }
                                
                                // 新内容红点
                                Rectangle {
                                    width: 8
                                    height: 8
                                    radius: 4
                                    color: "#EF4444"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            Text {
                                text: "02.23 ~ 03.01"
                                font.pixelSize: 12
                                color: textSecondary
                            }
                            
                            // 图标区域
                            Rectangle {
                                width: parent.width
                                height: 40
                                radius: 10
                                color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                                
                                Text {
                                    text: "📊"
                                    font.pixelSize: 24
                                    anchors.centerIn: parent
                                }
                            }
                        }
                        
                        MouseArea { anchors.fill: parent; onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/HealthReportPage.qml") }
                    }
                }
                
                // 我的勋章
                Rectangle {
                    width: parent.width - 32
                    height: 130
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Row {
                            width: parent.width - 8
                            
                            Text {
                                text: "我的勋章"
                                font.pixelSize: 15
                                font.weight: Font.DemiBold
                                color: textPrimary
                            }
                            
                            Item { width: parent.width - 100; height: 1 }
                            
                            Text {
                                text: "全部 ›"
                                font.pixelSize: 13
                                color: textSecondary
                            }
                        }
                        
                        // 勋章列表
                        Row {
                            spacing: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Repeater {
                                model: [
                                    { value: "500", name: "500次步数" },
                                    { value: "START", name: "首次游泳" },
                                    { value: "5000", name: "运动达人" },
                                    { value: "365", name: "365次打卡" }
                                ]
                                
                                Column {
                                    width: 64
                                    spacing: 4
                                    
                                    Rectangle {
                                        width: 52
                                        height: 52
                                        radius: 26
                                        color: index % 2 === 0 ? (isDarkMode ? "#3D2D6B" : "#E8E0F5") : (isDarkMode ? "#2A4A5A" : "#D4E8ED")
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.value
                                            font.pixelSize: modelData.value.length > 3 ? 10 : 14
                                            font.weight: Font.Bold
                                            color: textPrimary
                                        }
                                    }
                                    
                                    Text {
                                        text: modelData.name
                                        font.pixelSize: 10
                                        color: textSecondary
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }
                    
                    MouseArea { anchors.fill: parent; onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/MyBadgesPage.qml") }
                }
                
                // 功能菜单（参考图片风格）
                Rectangle {
                    width: parent.width - 32
                    height: menuColumn.height + 32
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    clip: true  // 裁剪子元素，防止圆角突破
                    
                    Column {
                        id: menuColumn
                        width: parent.width
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        
                        // App 设置
                        MenuItem {
                            width: parent.width
                            icon: "⚙"
                            iconColor: "#8A7AE6"
                            title: "App 设置"
                            isDarkMode: profilePage.isDarkMode
                            textPrimary: profilePage.textPrimary
                            pressedColor: profilePage.pressedColor
                            arrowColor: profilePage.arrowColor
                            onClicked: {
                                if (navigationStack) {
                                    navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/AppSettingsPage.qml")
                                }
                            }
                        }
                        
                        MenuSeparator {
                            separatorColor: dividerColor
                        }
                        
                        // 系统权限
                        MenuItem {
                            width: parent.width
                            icon: "🔒"
                            iconColor: "#81C784"
                            title: "系统权限"
                            isDarkMode: profilePage.isDarkMode
                            textPrimary: profilePage.textPrimary
                            pressedColor: profilePage.pressedColor
                            arrowColor: profilePage.arrowColor
                            onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/SystemPermissionsPage.qml")
                        }
                        
                        MenuSeparator {
                            separatorColor: dividerColor
                        }
                        
                        // 帮助与反馈
                        MenuItem {
                            width: parent.width
                            icon: "💬"
                            iconColor: "#FFB300"
                            title: "帮助与反馈"
                            isDarkMode: profilePage.isDarkMode
                            textPrimary: profilePage.textPrimary
                            pressedColor: profilePage.pressedColor
                            arrowColor: profilePage.arrowColor
                            onClicked: navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/HelpFeedbackPage.qml")
                        }
                        
                        MenuSeparator {
                            separatorColor: dividerColor
                        }
                        
                        // App 版本
                        MenuItem {
                            width: parent.width
                            icon: "☁"
                            iconColor: "#8A7AE6"
                            title: "App 版本"
                            badge: "0.1.19"
                            isDarkMode: profilePage.isDarkMode
                            textPrimary: profilePage.textPrimary
                            textSecondary: profilePage.textSecondary
                            pressedColor: profilePage.pressedColor
                        }
                        
                        MenuSeparator {
                            separatorColor: dividerColor
                        }
                        
                        // 关于
                        MenuItem {
                            width: parent.width
                            icon: "ⓘ"
                            iconColor: "#64B5F6"
                            title: "关于"
                            isDarkMode: profilePage.isDarkMode
                            textPrimary: profilePage.textPrimary
                            pressedColor: profilePage.pressedColor
                            arrowColor: profilePage.arrowColor
                            onClicked: {
                                navigationStack.pushFromRight("qrc:/qt/qml/IHA/qml/pages/settings/AboutPage.qml")
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
    
    // 菜单项组件（参考图片风格）
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
        
        // 圆形图标背景
        Rectangle {
            id: menuIcon
            x: 16
            width: 32
            height: 32
            radius: 16
            color: iconColor
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                anchors.centerIn: parent
                text: icon
                font.pixelSize: 16
                color: "#FFFFFF"
            }
        }
        
        // 标题
        Text {
            text: title
            font.pixelSize: 16
            color: textPrimary
            anchors.left: menuIcon.right
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // 版本号标签（右对齐）
        Text {
            text: badge
            font.pixelSize: 14
            color: textSecondary
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            visible: badge !== ""
        }
        
        // 右箭头（右对齐，有版本号时不显示）
        Text {
            text: ">"
            font.pixelSize: 16
            color: arrowColor
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            visible: badge === ""
        }
        
        MouseArea {
            id: itemMouseArea
            anchors.fill: parent
            onClicked: parent.clicked()
        }
    }
    
    // 分隔线组件
    component MenuSeparator: Rectangle {
        property color separatorColor: "#27272A"
        width: parent.width - 60
        height: 1
        color: separatorColor
        anchors.horizontalCenter: parent.horizontalCenter
    }
}