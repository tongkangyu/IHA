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
    property int todaySteps: (typeof healthDataManager !== 'undefined') ? healthDataManager.todaySteps : 0
    property int stepsGoal: (typeof healthDataManager !== 'undefined') ? healthDataManager.stepsGoal : 10000
    property var weeklyData: []
    property var weekDays: ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

    Component.onCompleted: {
        if (typeof healthDataManager !== 'undefined') weeklyData = healthDataManager.getWeeklySteps()
    }
    
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
                text: "步数"
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
                
                // 今日步数卡片
                Rectangle {
                    width: parent.width - 32
                    height: 180
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Text {
                            text: todaySteps.toLocaleString()
                            font.pixelSize: 48
                            font.weight: Font.Bold
                            color: "#FBBF24"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: "今日步数"
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
                                width: parent.width * Math.min(todaySteps / stepsGoal, 1)
                                height: parent.height
                                radius: 4
                                color: "#FBBF24"
                            }
                        }
                        
                        Text {
                            text: "目标: " + stepsGoal.toLocaleString() + " 步"
                            font.pixelSize: 14
                            color: textSecondary
                            anchors.horizontalCenter: parent.horizontalCenter
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
                                            height: parent.height * (weeklyData[index] / 12000)
                                            radius: 4
                                            color: index === 5 ? "#FBBF24" : "#3B82F6"
                                            anchors.bottom: parent.bottom
                                        }
                                    }
                                    
                                    Text {
                                        text: weekDays[index]
                                        font.pixelSize: 12
                                        color: index === 5 ? "#FBBF24" : textSecondary
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
                        
                        // 距离
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
                                        text: "D"
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
                                        text: "距离"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Text {
                                        text: "6.8 公里"
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
                        
                        // 消耗
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
                                        text: "C"
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
                                        text: "消耗"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Text {
                                        text: "568 千卡"
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
                        
                        // 活动时长
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
                                    anchors.left: parent.left
                                    anchors.leftMargin: 64
                                    
                                    Text {
                                        text: "活动时长"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Text {
                                        text: "85 分钟"
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