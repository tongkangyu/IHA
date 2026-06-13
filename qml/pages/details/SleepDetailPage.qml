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
    property int sleepScore: (typeof healthDataManager !== 'undefined') ? healthDataManager.healthScore : 0
    property int sleepHours: (typeof healthDataManager !== 'undefined') ? Math.floor(healthDataManager.todaySleepMinutes / 60) : 0
    property int sleepMinutes: (typeof healthDataManager !== 'undefined') ? healthDataManager.todaySleepMinutes % 60 : 0
    property string sleepQuality: "良好"
    
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
                color: sleepBackMouseArea.pressed ? pressedColor : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: textPrimary
                }
                
                MouseArea {
                    id: sleepBackMouseArea
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
                text: "睡眠"
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
                
                // 睡眠评分卡片
                Rectangle {
                    width: parent.width - 32
                    height: 200
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        // 圆形进度
                        Rectangle {
                            width: 120
                            height: 120
                            radius: 60
                            color: progressBg
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                width: 100
                                height: 100
                                radius: 50
                                color: cardColor
                                anchors.centerIn: parent
                                
                                Column {
                                    anchors.centerIn: parent
                                    
                                    Text {
                                        text: sleepScore
                                        font.pixelSize: 36
                                        font.weight: Font.Bold
                                        color: "#7D5FFF"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    
                                    Text {
                                        text: "分"
                                        font.pixelSize: 14
                                        color: textSecondary
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                        
                        Row {
                            spacing: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Text {
                                text: "睡眠质量" + sleepQuality
                                font.pixelSize: 16
                                color: textPrimary
                            }
                            
                            Text {
                                text: " ↑5"
                                font.pixelSize: 14
                                color: "#22C55E"
                            }
                        }
                    }
                }
                
                // 睡眠时长
                Rectangle {
                    width: parent.width - 32
                    height: 120
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 20
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: "睡眠时长"
                                font.pixelSize: 14
                                color: textSecondary
                            }
                            
                            Row {
                                spacing: 2
                                Text {
                                    text: sleepHours
                                    font.pixelSize: 36
                                    font.weight: Font.Bold
                                    color: textPrimary
                                }
                                Text {
                                    text: "时"
                                    font.pixelSize: 16
                                    color: textSecondary
                                    anchors.baseline: parent.children[0].baseline
                                }
                                Text {
                                    text: sleepMinutes
                                    font.pixelSize: 36
                                    font.weight: Font.Bold
                                    color: textPrimary
                                }
                                Text {
                                    text: "分"
                                    font.pixelSize: 16
                                    color: textSecondary
                                    anchors.baseline: parent.children[2].baseline
                                }
                            }
                        }
                        
                        Item { width: parent.width - 250; height: 1 }
                        
                        Column {
                            spacing: 8
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Row {
                                spacing: 8
                                Rectangle { width: 12; height: 12; radius: 2; color: "#1E3A5F" }
                                Text { text: "深睡 2h15m"; font.pixelSize: 12; color: textSecondary }
                            }
                            Row {
                                spacing: 8
                                Rectangle { width: 12; height: 12; radius: 2; color: "#3B5998" }
                                Text { text: "浅睡 3h40m"; font.pixelSize: 12; color: textSecondary }
                            }
                            Row {
                                spacing: 8
                                Rectangle { width: 12; height: 12; radius: 2; color: "#9B8FD7" }
                                Text { text: "REM 2h12m"; font.pixelSize: 12; color: textSecondary }
                            }
                        }
                    }
                }
                
                // 睡眠阶段图
                Rectangle {
                    width: parent.width - 32
                    height: 160
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Text {
                            text: "睡眠阶段"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                        }
                        
                        // 时间轴
                        Row {
                            width: parent.width
                            height: 80
                            spacing: 0
                            
                            Repeater {
                                model: [
                                    { duration: 30, stage: "deep" },
                                    { duration: 45, stage: "light" },
                                    { duration: 20, stage: "rem" },
                                    { duration: 60, stage: "deep" },
                                    { duration: 90, stage: "light" },
                                    { duration: 30, stage: "rem" },
                                    { duration: 45, stage: "light" },
                                    { duration: 30, stage: "deep" }
                                ]
                                
                                Rectangle {
                                    width: parent.width * (modelData.duration / 350)
                                    height: {
                                        if (modelData.stage === "deep") return 80
                                        if (modelData.stage === "light") return 50
                                        return 30
                                    }
                                    radius: 4
                                    color: {
                                        if (modelData.stage === "deep") return "#1E3A5F"
                                        if (modelData.stage === "light") return "#3B5998"
                                        return "#9B8FD7"
                                    }
                                    anchors.bottom: parent.bottom
                                }
                            }
                        }
                        
                        Row {
                            width: parent.width
                            Text { text: "23:00"; font.pixelSize: 10; color: textSecondary }
                            Item { width: parent.width - 80; height: 1 }
                            Text { text: "06:07"; font.pixelSize: 10; color: textSecondary }
                        }
                    }
                }
                
                // 睡眠建议
                Rectangle {
                    width: parent.width - 32
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        width: parent.width
                        spacing: 0
                        
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#7D5FFF"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "!"
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        text: "入睡时间"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Text {
                                        text: "23:07 (偏晚)"
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
                        
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#22C55E"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "Z"
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        text: "睡眠建议"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Text {
                                        text: "建议提前30分钟入睡"
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