import QtQuick
import QtQuick.Controls

Item {
    id: healthPage
    
    property var navigationStack: null
    
    // 使用全局主题
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color pressedColor: isDarkMode ? "#3A3A3C" : "#E5E5EA"
    readonly property color btnColor: isDarkMode ? "#1E1E20" : "#E5E5EA"
    readonly property color progressBg: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color arrowColor: isDarkMode ? "#5A5A5C" : "#C7C7CC"
    readonly property color cardPressed: isDarkMode ? "#303032" : "#F0F0F5"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    
    // 默认值（防止 C++ 对象未初始化）
    property int todaySteps: (typeof healthDataManager !== 'undefined') ? healthDataManager.todaySteps : 0
    property int stepsGoal: (typeof healthDataManager !== 'undefined') ? healthDataManager.stepsGoal : 10000
    property int todayCalories: (typeof healthDataManager !== 'undefined') ? healthDataManager.todayCalories : 0
    property int caloriesGoal: (typeof healthDataManager !== 'undefined') ? healthDataManager.caloriesGoal : 600
    property int todayActivity: (typeof healthDataManager !== 'undefined') ? healthDataManager.todayActivity : 0
    property int activityGoal: (typeof healthDataManager !== 'undefined') ? healthDataManager.activityGoal : 12
    property int todaySleepMinutes: (typeof healthDataManager !== 'undefined') ? healthDataManager.todaySleepMinutes : 420
    property int todayHeartRate: (typeof healthDataManager !== 'undefined') ? healthDataManager.todayHeartRate : 72
    property int moderateActivityMinutes: (typeof healthDataManager !== 'undefined') ? healthDataManager.moderateActivityMinutes : 0

    Component.onCompleted: {
        if (typeof healthDataManager !== 'undefined' && typeof userService !== 'undefined' && userService.isLoggedIn) {
            healthDataManager.fetchFromBackend(userService.getToken())
        }
    }

    Column {
        anchors.fill: parent
        
        // 顶部标题栏 - 固定在顶部
        Rectangle {
            width: parent.width
            height: 56
            color: headerColor
            
            Row {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                
                Text {
                    text: "健康"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        
        // 可滚动内容区域
        ScrollView {
            id: scrollView
            width: parent.width
            height: parent.height - 56
            clip: true
            
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
            
            Column {
                id: contentColumn
                width: healthPage.width - 32
                spacing: 16
                x: 16
                
                // 健康仪表盘
                Rectangle {
                    id: gaugeCard
                    width: parent.width
                    height: 200
                    radius: 24
                    color: cardColor
                    
                    // 圆环容器
                    Item {
                        id: ringContainer
                        anchors.centerIn: parent
                        width: 160
                        height: 160
                        
                        property real progress: (typeof healthDataManager !== 'undefined') ? healthDataManager.healthScore / 100.0 : 0
                        property int lineWidth: 14
                        property real ringRadius: (width - lineWidth) / 2
                        
                        // 背景圆环
                        Rectangle {
                            anchors.centerIn: parent
                            width: ringContainer.width - ringContainer.lineWidth
                            height: width
                            radius: width / 2
                            color: "transparent"
                            border.width: ringContainer.lineWidth
                            border.color: progressBg
                        }
                        
                        // 进度圆环
                        Canvas {
                            id: progressCanvas
                            anchors.fill: parent
                            
                            property real progressValue: ringContainer.progress
                            
                            onProgressValueChanged: requestPaint()
                            
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                
                                if (progressValue <= 0) return
                                
                                var centerX = width / 2
                                var centerY = height / 2
                                var radius = ringContainer.ringRadius
                                var startAngle = -Math.PI / 2
                                var endAngle = startAngle + (Math.PI * 2 * Math.min(progressValue, 1))
                                
                                var gradient = ctx.createLinearGradient(0, 0, width, height)
                                gradient.addColorStop(0, "#FF6B35")
                                gradient.addColorStop(0.5, "#22C55E")
                                gradient.addColorStop(1, "#3B82F6")
                                
                                ctx.beginPath()
                                ctx.arc(centerX, centerY, radius, startAngle, endAngle)
                                ctx.strokeStyle = gradient
                                ctx.lineWidth = ringContainer.lineWidth
                                ctx.lineCap = "round"
                                ctx.stroke()
                            }
                            
                            Component.onCompleted: requestPaint()
                        }
                        
                        // 中心文字
                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            
                            Text {
                                font.pixelSize: 42
                                font.weight: Font.Bold
                                color: textPrimary
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: (typeof healthDataManager !== 'undefined' ? healthDataManager.healthScore : 0) + "%"
                            }
                            
                            Text {
                                text: "健康指数"
                                font.pixelSize: 14
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
                
                // 三个指标卡片
                Row {
                    width: parent.width
                    spacing: 10
                    
                    // 卡路里卡片
                    Rectangle {
                        id: caloriesCard
                        width: (parent.width - 20) / 3
                        height: 110
                        radius: 20
                        color: caloriesMouseArea.pressed ? cardPressed : cardColor
                        
                        MouseArea {
                            id: caloriesMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (navigationStack) {
                                    // 获取卡片在屏幕上的位置
                                    var pos = caloriesCard.mapToItem(null, 0, 0)
                                    navigationStack.pushFromCard(
                                        "qrc:/qt/qml/IHA/qml/pages/details/CaloriesDetailPage.qml",
                                        pos.x, pos.y, caloriesCard.width, caloriesCard.height
                                    )
                                }
                            }
                        }
                        
                        // 进度条
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            height: 3
                            radius: 1.5
                            color: progressBg
                            
                            Rectangle {
                                width: parent.width * Math.min(caloriesGoal > 0 ? todayCalories / caloriesGoal : 0, 1)
                                height: parent.height
                                radius: 1.5
                                color: "#FF6B35"
                            }
                        }
                        
                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            anchors.bottomMargin: 16
                            spacing: 6
                            
                            Row {
                                spacing: 6
                                
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: "#FF6B35"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "C"
                                        font.pixelSize: 14
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Text {
                                    text: "卡路里"
                                    font.pixelSize: 13
                                    color: textSecondary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            Text {
                                text: todayCalories.toLocaleString()
                                font.pixelSize: 22
                                font.weight: Font.Bold
                                color: textPrimary
                            }
                            
                            Text {
                                text: "目标 " + caloriesGoal.toLocaleString()
                                font.pixelSize: 11
                                color: textSecondary
                            }
                        }
                    }
                    
                    // 步数卡片
                    Rectangle {
                        id: stepsCard
                        width: (parent.width - 20) / 3
                        height: 110
                        radius: 20
                        color: stepsMouseArea.pressed ? cardPressed : cardColor
                        
                        MouseArea {
                            id: stepsMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (navigationStack) {
                                    var pos = stepsCard.mapToItem(null, 0, 0)
                                    navigationStack.pushFromCard(
                                        "qrc:/qt/qml/IHA/qml/pages/details/StepsDetailPage.qml",
                                        pos.x, pos.y, stepsCard.width, stepsCard.height
                                    )
                                }
                            }
                        }
                        
                        // 进度条
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            height: 3
                            radius: 1.5
                            color: progressBg
                            
                            Rectangle {
                                width: parent.width * Math.min(stepsGoal > 0 ? todaySteps / stepsGoal : 0, 1)
                                height: parent.height
                                radius: 1.5
                                color: "#FBBF24"
                            }
                        }
                        
                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            anchors.bottomMargin: 16
                            spacing: 6
                            
                            Row {
                                spacing: 6
                                
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: "#FBBF24"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "S"
                                        font.pixelSize: 14
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Text {
                                    text: "步数"
                                    font.pixelSize: 13
                                    color: textSecondary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            Text {
                                text: todaySteps.toLocaleString()
                                font.pixelSize: 22
                                font.weight: Font.Bold
                                color: textPrimary
                            }
                            
                            Text {
                                text: "目标 " + stepsGoal.toLocaleString()
                                font.pixelSize: 11
                                color: textSecondary
                            }
                        }
                    }
                    
                    // 活动卡片
                    Rectangle {
                        id: activityCardSmall
                        width: (parent.width - 20) / 3
                        height: 110
                        radius: 20
                        color: activityMouseArea.pressed ? cardPressed : cardColor
                        
                        MouseArea {
                            id: activityMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (navigationStack) {
                                    var pos = activityCardSmall.mapToItem(null, 0, 0)
                                    navigationStack.pushFromCard(
                                        "qrc:/qt/qml/IHA/qml/pages/details/ActivityCountDetailPage.qml",
                                        pos.x, pos.y, activityCardSmall.width, activityCardSmall.height
                                    )
                                }
                            }
                        }
                        
                        // 进度条
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            height: 3
                            radius: 1.5
                            color: progressBg
                            
                            Rectangle {
                                width: parent.width * Math.min(activityGoal > 0 ? todayActivity / activityGoal : 0, 1)
                                height: parent.height
                                radius: 1.5
                                color: "#22C55E"
                            }
                        }
                        
                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            anchors.bottomMargin: 16
                            spacing: 6
                            
                            Row {
                                spacing: 6
                                
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: "#22C55E"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "A"
                                        font.pixelSize: 14
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Text {
                                    text: "活动"
                                    font.pixelSize: 13
                                    color: textSecondary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            Text {
                                text: todayActivity.toLocaleString()
                                font.pixelSize: 22
                                font.weight: Font.Bold
                                color: textPrimary
                            }
                            
                            Text {
                                text: "目标 " + activityGoal.toLocaleString()
                                font.pixelSize: 11
                                color: textSecondary
                            }
                        }
                    }
                }
                
                // 中高强度活动
                Rectangle {
                    id: activityCard
                    width: parent.width
                    height: 64
                    radius: 20
                    color: activityCardMouseArea.pressed ? cardPressed : cardColor
                    
                    MouseArea {
                        id: activityCardMouseArea
                        anchors.fill: parent
                        onClicked: {
                            if (navigationStack) {
                                var pos = activityCard.mapToItem(null, 0, 0)
                                navigationStack.pushFromCard(
                                    "qrc:/qt/qml/IHA/qml/pages/details/ActivityDetailPage.qml",
                                    pos.x, pos.y, activityCard.width, activityCard.height
                                )
                            }
                        }
                    }
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 14
                        
                        Rectangle {
                            width: 36
                            height: 36
                            radius: 18
                            color: "#3B82F6"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                anchors.centerIn: parent
                                text: "T"
                                font.pixelSize: 16
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                        }
                        
                        Column {
                            spacing: 2
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: "中高强度活动"
                                font.pixelSize: 15
                                font.weight: Font.Medium
                                color: textPrimary
                            }
                            
                            Row {
                                spacing: 4
                                Text {
                                    id: activityMinutesValue
                                    text: moderateActivityMinutes.toString()
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#3B82F6"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "分钟"
                                    font.pixelSize: 13
                                    color: textSecondary
                                    anchors.baseline: activityMinutesValue.baseline
                                    anchors.baselineOffset: -3
                                }
                            }
                        }
                        
                        Item { width: parent.width - 200; height: 1 }
                        
                        Text {
                            text: "›"
                            font.pixelSize: 24
                            color: arrowColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                
                // 睡眠和心率卡片
                Row {
                    width: parent.width
                    spacing: 10
                    
                    // 睡眠卡片
                    Rectangle {
                        id: sleepCard
                        width: (parent.width - 10) / 2
                        height: 150
                        radius: 24
                        color: sleepMouseArea.pressed ? cardPressed : cardColor
                        
                        MouseArea {
                            id: sleepMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (navigationStack) {
                                    var pos = sleepCard.mapToItem(null, 0, 0)
                                    navigationStack.pushFromCard(
                                        "qrc:/qt/qml/IHA/qml/pages/details/SleepDetailPage.qml",
                                        pos.x, pos.y, sleepCard.width, sleepCard.height
                                    )
                                }
                            }
                        }
                        
                        Column {
                            x: 18
                            y: 18
                            width: parent.width - 36
                            spacing: 8
                            
                            // 标题行
                            Row {
                                spacing: 10
                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: 16
                                    color: "#7D5FFF"
                                    Text {
                                        anchors.centerIn: parent
                                        text: "Z"
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                Text {
                                    text: "睡眠"
                                    font.pixelSize: 16
                                    font.weight: Font.Medium
                                    color: textPrimary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            // 时间数据 - 左对齐
                            Item {
                                width: parent.width
                                height: 40
                                
                                Row {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    spacing: 2
                                    
                                    Text {
                                        id: sleepHours
                                        text: Math.floor(todaySleepMinutes / 60).toString()
                                        font.pixelSize: 32
                                        font.weight: Font.Bold
                                        color: textPrimary
                                    }
                                    Text {
                                        text: "时"
                                        font.pixelSize: 14
                                        color: textSecondary
                                        anchors.bottom: sleepHours.bottom
                                        anchors.bottomMargin: 4
                                    }
                                    Text {
                                        id: sleepMins
                                        text: (todaySleepMinutes % 60).toString().padStart(2, '0')
                                        font.pixelSize: 32
                                        font.weight: Font.Bold
                                        color: textPrimary
                                    }
                                    Text {
                                        text: "分"
                                        font.pixelSize: 14
                                        color: textSecondary
                                        anchors.bottom: sleepMins.bottom
                                        anchors.bottomMargin: 4
                                    }
                                }
                            }
                            
                            // 睡眠质量进度条
                            Row {
                                width: parent.width
                                height: 6
                                spacing: 2
                                Rectangle { width: parent.width * 0.25 - 2; height: 6; radius: 3; color: isDarkMode ? "#4A3A80" : "#C4B8E0" }
                                Rectangle { width: parent.width * 0.35 - 2; height: 6; radius: 3; color: isDarkMode ? "#5A4A90" : "#B4A8D0" }
                                Rectangle { width: parent.width * 0.25 - 2; height: 6; radius: 3; color: isDarkMode ? "#6A5AA0" : "#A498C0" }
                                Rectangle { width: parent.width * 0.15 - 8; height: 6; radius: 3; color: "#7D5FFF" }
                            }
                        }
                    }
                    
                    // 心率卡片
                    Rectangle {
                        id: heartCard
                        width: (parent.width - 10) / 2
                        height: 150
                        radius: 24
                        color: heartMouseArea.pressed ? cardPressed : cardColor
                        
                        MouseArea {
                            id: heartMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (navigationStack) {
                                    var pos = heartCard.mapToItem(null, 0, 0)
                                    navigationStack.pushFromCard(
                                        "qrc:/qt/qml/IHA/qml/pages/details/HeartRateDetailPage.qml",
                                        pos.x, pos.y, heartCard.width, heartCard.height
                                    )
                                }
                            }
                        }
                        
                        Column {
                            x: 18
                            y: 18
                            width: parent.width - 36
                            spacing: 8
                            
                            // 标题行
                            Row {
                                spacing: 10
                                Rectangle {
                                    id: heartIcon
                                    width: 32
                                    height: 32
                                    radius: 16
                                    color: "#EF4444"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "♥"
                                        font.pixelSize: 16
                                        color: "#FFFFFF"
                                    }
                                }
                                Text {
                                    text: "心率"
                                    font.pixelSize: 16
                                    font.weight: Font.Medium
                                    color: textPrimary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            // 心率数据 - 左对齐
                            Item {
                                width: parent.width
                                height: 44
                                
                                Row {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    spacing: 4
                                    
                                    Text {
                                        id: heartRateValue
                                        text: todayHeartRate.toString()
                                        font.pixelSize: 36
                                        font.weight: Font.Bold
                                        color: textPrimary
                                    }
                                    Text {
                                        text: "次/分"
                                        font.pixelSize: 14
                                        color: textSecondary
                                        anchors.bottom: heartRateValue.bottom
                                        anchors.bottomMargin: 6
                                    }
                                }
                            }
                            
                            // 心率曲线
                            Canvas {
                                width: parent.width
                                height: 24
                                
                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.clearRect(0, 0, width, height)
                                    ctx.strokeStyle = "#EF4444"
                                    ctx.lineWidth = 2
                                    ctx.lineCap = "round"
                                    
                                    ctx.beginPath()
                                    ctx.moveTo(0, height * 0.6)
                                    
                                    for (var i = 0; i < width; i += 20) {
                                        ctx.lineTo(i + 5, height * 0.6)
                                        ctx.lineTo(i + 8, height * 0.2)
                                        ctx.lineTo(i + 10, height * 0.9)
                                        ctx.lineTo(i + 12, height * 0.4)
                                        ctx.lineTo(i + 15, height * 0.6)
                                    }
                                    ctx.stroke()
                                }
                                
                                Component.onCompleted: requestPaint()
                            }
                        }
                    }
                }
                
                // 底部间距
                Item { width: 1; height: 32 }
            }
        }
    }
}