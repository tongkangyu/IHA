import QtQuick
import QtQuick.Controls

Item {
    id: root
    
    property var navigationStack: null
    
    // 使用全局主题
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color pressedColor: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color dividerColor: isDarkMode ? "#27272A" : "#E5E5EA"
    readonly property color progressBg: isDarkMode ? "#27272A" : "#E5E5EA"
    
    // 模拟数据
    property int todayCalories: 568
    property int caloriesGoal: 600
    property var hourlyData: [15, 28, 12, 35, 45, 22, 18, 55, 42, 38, 25, 30, 48, 52, 35, 28, 22, 45, 38, 32, 25, 18, 12, 8]
    property var weeklyData: [520, 580, 490, 620, 450, 568, 540]
    property var weekDays: ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    Column {
        anchors.fill: parent
        
        // 顶部导航栏
        Rectangle {
            width: parent.width
            height: 56
            color: headerColor
            
            // 返回按钮
            Rectangle {
                x: 8
                y: 10
                width: 36
                height: 36
                radius: 18
                color: backMouseArea.pressed ? pressedColor : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: textPrimary
                }
                
                MouseArea {
                    id: backMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (navigationStack) {
                            navigationStack.pop()
                        }
                    }
                }
            }
            
            // 标题
            Text {
                text: "卡路里"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: textPrimary
                anchors.centerIn: parent
            }
        }
        
        ScrollView {
            width: parent.width
            height: parent.height - 56
            clip: true
            
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            
            Column {
                width: root.width
                spacing: 16
                
                // 今日卡路里卡片
                Rectangle {
                    width: parent.width - 32
                    height: 180
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Row {
                            spacing: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                color: "#FF6B35"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: todayCalories.toLocaleString()
                                font.pixelSize: 48
                                font.weight: Font.Bold
                                color: textPrimary
                            }
                            
                            Text {
                                text: "千卡"
                                font.pixelSize: 16
                                color: textSecondary
                                anchors.baseline: parent.children[1].baseline
                            }
                        }
                        
                        Text {
                            text: "今日消耗"
                            font.pixelSize: 16
                            color: textSecondary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // 进度条
                        Rectangle {
                            width: 200
                            height: 8
                            radius: 4
                            color: progressBg
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                width: parent.width * Math.min(todayCalories / caloriesGoal, 1)
                                height: parent.height
                                radius: 4
                                color: "#FF6B35"
                            }
                        }
                        
                        Text {
                            text: "目标: " + caloriesGoal.toLocaleString() + " 千卡"
                            font.pixelSize: 14
                            color: textSecondary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                
                // 每小时消耗
                Rectangle {
                    width: parent.width - 32
                    height: 200
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Text {
                            text: "今日消耗趋势"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                        }
                        
                        // 柱状图
                        Canvas {
                            id: hourlyChart
                            width: parent.width
                            height: 120
                            
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                
                                var barWidth = (width - 24) / 24 - 2
                                var maxVal = 60
                                
                                for (var i = 0; i < 24; i++) {
                                    var barHeight = (hourlyData[i] / maxVal) * height
                                    var x = i * (barWidth + 2) + 12
                                    var y = height - barHeight
                                    
                                    ctx.fillStyle = i === new Date().getHours() ? "#FF6B35" : "#3B82F6"
                                    ctx.beginPath()
                                    ctx.roundedRect(x, y, barWidth, barHeight, 2, 2)
                                    ctx.fill()
                                }
                            }
                            
                            Component.onCompleted: requestPaint()
                        }
                        
                        Row {
                            width: parent.width
                            Text { text: "0时"; font.pixelSize: 10; color: textSecondary }
                            Item { width: parent.width - 80; height: 1 }
                            Text { text: "24时"; font.pixelSize: 10; color: textSecondary }
                        }
                    }
                }
                
                // 周数据统计
                Rectangle {
                    width: parent.width - 32
                    height: 200
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Text {
                            text: "本周统计"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                        }
                        
                        // 柱状图
                        Row {
                            width: parent.width
                            height: 120
                            spacing: 8
                            
                            Repeater {
                                model: 7
                                
                                Column {
                                    width: (parent.width - 48) / 7
                                    height: parent.height
                                    spacing: 4
                                    
                                    Rectangle {
                                        width: parent.width - 8
                                        height: parent.height - 30
                                        radius: 4
                                        color: progressBg
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        
                                        Rectangle {
                                            width: parent.width
                                            height: parent.height * (weeklyData[index] / 700)
                                            radius: 4
                                            color: index === 5 ? "#FF6B35" : "#3B82F6"
                                            anchors.bottom: parent.bottom
                                        }
                                    }
                                    
                                    Text {
                                        text: weekDays[index]
                                        font.pixelSize: 12
                                        color: index === 5 ? "#FF6B35" : textSecondary
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }
                }
                
                // 数据详情
                Rectangle {
                    width: parent.width - 32
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        width: parent.width
                        
                        // 活动消耗
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#FF6B35"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "R"
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 64
                                    
                                    Text {
                                        text: "活动消耗"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Text {
                                        text: "420 千卡"
                                        font.pixelSize: 16
                                        font.weight: Font.DemiBold
                                        color: textPrimary
                                    }
                                }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width - 32
                            height: 1
                            color: dividerColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // 静息消耗
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#22C55E"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "B"
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 64
                                    
                                    Text {
                                        text: "静息消耗"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Text {
                                        text: "148 千卡"
                                        font.pixelSize: 16
                                        font.weight: Font.DemiBold
                                        color: textPrimary
                                    }
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}