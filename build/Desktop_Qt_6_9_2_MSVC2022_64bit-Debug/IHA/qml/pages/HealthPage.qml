import QtQuick
import QtQuick.Controls

Item {
    id: healthPage
    
    property var navigationStack: null
    
    // 模拟数据
    property int todaySteps: 9580
    property int stepsGoal: 10000
    property int todayCalories: 568
    property int caloriesGoal: 600
    property int todayActivity: 4
    property int activityGoal: 12
    
    // 页面入场动画
    opacity: 1
    
    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 16
        clip: true
        
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
        ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
        
        Column {
            id: contentColumn
            width: healthPage.width - 32
            spacing: 16
            
            // 顶部标题
            Row {
                width: parent.width
                
                Text {
                    text: "健康"
                    font.pixelSize: 32
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }
                
                Item { width: parent.width - 100; height: 1 }
                
                Rectangle {
                    id: addBtn
                    width: 36
                    height: 36
                    radius: 18
                    color: addMouseArea.pressed ? "#3A3A3C" : "#1E1E20"
                    anchors.verticalCenter: parent.verticalCenter
                    
                    scale: addMouseArea.pressed ? 0.85 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100 } }
                    Behavior on color { ColorAnimation { duration: 150 } }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "+"
                        font.pixelSize: 20
                        color: "#FFFFFF"
                    }
                    
                    MouseArea {
                        id: addMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
            }
            
            // 健康仪表盘
            Rectangle {
                id: gaugeCard
                width: parent.width
                height: 200
                radius: 24
                color: "#1E1E20"
                
                // 圆环容器
                Item {
                    id: ringContainer
                    anchors.centerIn: parent
                    width: 160
                    height: 160
                    
                    property real progress: todaySteps / stepsGoal
                    property int lineWidth: 14
                    property real ringRadius: (width - lineWidth) / 2
                    
                    // 背景圆环 - 使用 Rectangle 边框
                    Rectangle {
                        anchors.centerIn: parent
                        width: ringContainer.width - ringContainer.lineWidth
                        height: width
                        radius: width / 2
                        color: "transparent"
                        border.width: ringContainer.lineWidth
                        border.color: "#2A2A2C"
                    }
                    
                    // 进度圆环 - 使用 Canvas
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
                            
                            // 使用线性渐变模拟彩虹效果
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
                            color: "#FFFFFF"
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: Math.round(todaySteps / stepsGoal * 100) + "%"
                        }
                        
                        Text {
                            text: "健康指数"
                            font.pixelSize: 14
                            color: "#A1A1AA"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
            
            // 三个指标卡片
            Row {
                width: parent.width
                spacing: 10
                
                Repeater {
                    model: [
                        { title: "卡路里", value: todayCalories, goal: caloriesGoal, unit: "千卡", color: "#FF6B35", icon: "C", page: "qrc:/qt/qml/IHA/qml/pages/details/CaloriesDetailPage.qml" },
                        { title: "步数", value: todaySteps, goal: stepsGoal, unit: "步", color: "#FBBF24", icon: "S", page: "qrc:/qt/qml/IHA/qml/pages/details/StepsDetailPage.qml" },
                        { title: "活动", value: todayActivity, goal: activityGoal, unit: "次", color: "#22C55E", icon: "A", page: "qrc:/qt/qml/IHA/qml/pages/details/ActivityCountDetailPage.qml" }
                    ]
                    
                    delegate: Rectangle {
                        width: (parent.width - 20) / 3
                        height: 110
                        radius: 20
                        color: metricMouseArea.pressed ? "#303032" : "#1E1E20"
                        
                        scale: metricMouseArea.pressed ? 0.92 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }
                        Behavior on color { ColorAnimation { duration: 120 } }
                        
                        // 进度条
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            height: 3
                            radius: 1.5
                            color: "#2A2A2C"
                            
                            Rectangle {
                                width: parent.width * Math.min(modelData.value / modelData.goal, 1)
                                height: parent.height
                                radius: 1.5
                                color: modelData.color
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
                                    color: modelData.color
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.icon
                                        font.pixelSize: 14
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Text {
                                    text: modelData.title
                                    font.pixelSize: 13
                                    color: "#A1A1AA"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            Text {
                                text: modelData.value.toLocaleString()
                                font.pixelSize: 22
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                            
                            Text {
                                text: "目标 " + modelData.goal.toLocaleString()
                                font.pixelSize: 11
                                color: "#5A5A5C"
                            }
                        }
                        
                        MouseArea {
                            id: metricMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (navigationStack) {
                                    // 使用 delegate 的 Rectangle 作为卡片
                                    var cardRect = parent
                                    var cardPos = cardRect.mapToItem(null, 0, 0)
                                    console.log("Card pos:", cardPos.x, cardPos.y, cardRect.width, cardRect.height)
                                    navigationStack.pushFromCard(modelData.page, cardPos.x, cardPos.y, cardRect.width, cardRect.height)
                                }
                            }
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
                color: activityMouseArea.pressed ? "#303032" : "#1E1E20"
                
                scale: activityMouseArea.pressed ? 0.97 : 1.0
                Behavior on scale { NumberAnimation { duration: 80 } }
                
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
                            color: "#FFFFFF"
                        }
                        
                        Row {
                            spacing: 4
                            Text {
                                text: "85"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                                color: "#3B82F6"
                            }
                            Text {
                                text: "分钟"
                                font.pixelSize: 13
                                color: "#8A8A8C"
                                anchors.baseline: parent.children[0].baseline
                            }
                        }
                    }
                    
                    Item { width: parent.width - 200; height: 1 }
                    
                    Text {
                        text: "›"
                        font.pixelSize: 24
                        color: "#5A5A5C"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    id: activityMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (navigationStack) {
                            var cardPos = activityCard.mapToItem(null, 0, 0)
                            navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/details/ActivityDetailPage.qml", cardPos.x, cardPos.y, activityCard.width, activityCard.height)
                        }
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
                    color: sleepMouseArea.pressed ? "#303032" : "#1E1E20"
                    
                    scale: sleepMouseArea.pressed ? 0.96 : 1.0
                    Behavior on scale { NumberAnimation { duration: 80 } }
                    
                    // 渐变背景
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#2A2040" }
                            GradientStop { position: 1.0; color: "#1E1E20" }
                        }
                    }
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 10
                        
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
                                color: "#FFFFFF"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        Row {
                            spacing: 2
                            Text {
                                text: "7"
                                font.pixelSize: 32
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                            Text {
                                text: "时"
                                font.pixelSize: 14
                                color: "#8A8A8C"
                                anchors.baseline: parent.children[0].baseline
                            }
                            Text {
                                text: "7"
                                font.pixelSize: 32
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                            Text {
                                text: "分"
                                font.pixelSize: 14
                                color: "#8A8A8C"
                                anchors.baseline: parent.children[2].baseline
                            }
                        }
                        
                        // 睡眠质量进度 - 使用相对宽度避免超出
                        Item {
                            width: parent.width
                            height: 4
                            
                            Row {
                                anchors.fill: parent
                                spacing: 2
                                
                                Rectangle { width: parent.width * 0.25; height: 4; radius: 2; color: "#4A3A80" }
                                Rectangle { width: parent.width * 0.35; height: 4; radius: 2; color: "#5A4A90" }
                                Rectangle { width: parent.width * 0.25; height: 4; radius: 2; color: "#6A5AA0" }
                                Rectangle { width: parent.width * 0.15 - 6; height: 4; radius: 2; color: "#7D5FFF" }
                            }
                        }
                        
                        // 占位，与心率曲线高度对齐
                        Item { width: 1; height: 20 }
                    }
                    
                    MouseArea {
                        id: sleepMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (navigationStack) {
                                var cardPos = sleepCard.mapToItem(null, 0, 0)
                                navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/details/SleepDetailPage.qml", cardPos.x, cardPos.y, sleepCard.width, sleepCard.height)
                            }
                        }
                    }
                }
                
                // 心率卡片
                Rectangle {
                    id: heartCard
                    width: (parent.width - 10) / 2
                    height: 150
                    radius: 24
                    color: heartMouseArea.pressed ? "#303032" : "#1E1E20"
                    
                    scale: heartMouseArea.pressed ? 0.96 : 1.0
                    Behavior on scale { NumberAnimation { duration: 80 } }
                    
                    // 渐变背景
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#301515" }
                            GradientStop { position: 1.0; color: "#1E1E20" }
                        }
                    }
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 10
                        
                        Row {
                            spacing: 10
                            
                            Rectangle {
                                id: heartIcon
                                width: 32
                                height: 32
                                radius: 16
                                color: "#EF4444"
                                
                                // 心跳动画
                                SequentialAnimation on scale {
                                    running: true
                                    loops: Animation.Infinite
                                    NumberAnimation { from: 1.0; to: 1.15; duration: 150; easing.type: Easing.OutQuad }
                                    NumberAnimation { from: 1.15; to: 1.0; duration: 150 }
                                    PauseAnimation { duration: 600 }
                                }
                                
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
                                color: "#FFFFFF"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        Row {
                            spacing: 4
                            Text {
                                text: "72"
                                font.pixelSize: 36
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                            Text {
                                text: "次/分"
                                font.pixelSize: 14
                                color: "#8A8A8C"
                                anchors.baseline: parent.children[0].baseline
                            }
                        }
                        
                        // 心率曲线 - 高度与睡眠条区域对齐
                        Canvas {
                            width: heartCard.width - 36
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
                    
                    MouseArea {
                        id: heartMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (navigationStack) {
                                var cardPos = heartCard.mapToItem(null, 0, 0)
                                navigationStack.pushFromCard("qrc:/qt/qml/IHA/qml/pages/details/HeartRateDetailPage.qml", cardPos.x, cardPos.y, heartCard.width, heartCard.height)
                            }
                        }
                    }
                }
            }
            
            Item { width: 1; height: 32 }
        }
    }
}