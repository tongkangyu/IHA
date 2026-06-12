import QtQuick
import QtQuick.Controls

Rectangle {
    id: healthReportPage
    
    color: typeof window !== 'undefined' && window.darkMode ? "#0D0D0F" : "#F5F5F7"
    
    readonly property color cardColor: typeof window !== 'undefined' && window.darkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: typeof window !== 'undefined' && window.darkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: typeof window !== 'undefined' && window.darkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color pressedColor: typeof window !== 'undefined' && window.darkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color accentColor: "#007AFF"
    readonly property color successColor: "#34C759"
    readonly property color warningColor: "#FF9500"
    readonly property color dangerColor: "#FF3B30"
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    
    Column {
        anchors.fill: parent
        
        // 顶部导航栏
        Rectangle {
            width: parent.width
            height: 56
            color: healthReportPage.color
            
            Rectangle {
                x: 8
                y: 10
                width: 36
                height: 36
                radius: 18
                color: backMA.pressed ? pressedColor : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: textPrimary
                }
                
                MouseArea {
                    id: backMA
                    anchors.fill: parent
                    onClicked: {
                        if (typeof navigationStack !== 'undefined') {
                            navigationStack.goBack()
                        }
                    }
                }
            }
            
            Text {
                text: "运动健康周报"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: textPrimary
                anchors.centerIn: parent
            }
        }
        
        Flickable {
            width: parent.width
            height: parent.height - 56
            contentHeight: contentCol.height
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds
            
            Column {
                id: contentCol
                width: healthReportPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                // 周期选择
                Rectangle {
                    width: parent.width - 32
                    height: 50
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        Text {
                            text: "‹"
                            font.pixelSize: 20
                            color: textSecondary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Text {
                            text: "2026.03.03 ~ 2026.03.09"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            color: textPrimary
                            anchors.verticalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: "›"
                            font.pixelSize: 20
                            color: textSecondary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                
                // 运动概览
                Rectangle {
                    width: parent.width - 32
                    height: 180
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16
                        
                        Text {
                            text: "📊 本周运动概览"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        Row {
                            width: parent.width
                            spacing: 20
                            
                            Column {
                                spacing: 4
                                Text { text: "52,340"; font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                                Text { text: "总步数"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: "38.5"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                                Text { text: "公里"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: "1,850"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                                Text { text: "卡路里"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        // 进度条
                        Rectangle {
                            width: parent.width
                            height: 8
                            radius: 4
                            color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                            
                            Rectangle {
                                width: parent.width * 0.75
                                height: 8
                                radius: 4
                                color: accentColor
                            }
                        }
                        
                        Text {
                            text: "完成周目标的 75%"
                            font.pixelSize: 13
                            color: textSecondary
                        }
                    }
                }
                
                // 步数统计
                Rectangle {
                    width: parent.width - 32
                    height: 200
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        Text {
                            text: "📅 每日步数"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        // 简化的柱状图
                        Row {
                            width: parent.width
                            height: 120
                            spacing: 8
                            
                            Repeater {
                                model: [
                                    { day: "一", value: 0.6 },
                                    { day: "二", value: 0.8 },
                                    { day: "三", value: 0.5 },
                                    { day: "四", value: 0.9 },
                                    { day: "五", value: 0.7 },
                                    { day: "六", value: 1.0 },
                                    { day: "日", value: 0.4 }
                                ]
                                
                                Column {
                                    width: (parent.width - 48) / 7
                                    height: parent.height
                                    spacing: 4
                                    
                                    Item { width: 1; height: 10 }
                                    
                                    Rectangle {
                                        width: parent.width - 4
                                        height: (parent.parent.height - 50) * modelData.value
                                        radius: 4
                                        color: accentColor
                                        opacity: 0.3 + modelData.value * 0.7
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    
                                    Text {
                                        text: modelData.day
                                        font.pixelSize: 12
                                        color: textSecondary
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }
                }
                
                // 睡眠质量
                Rectangle {
                    width: parent.width - 32
                    height: 140
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        Text {
                            text: "😴 睡眠质量"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        Row {
                            width: parent.width
                            spacing: 20
                            
                            Column {
                                spacing: 4
                                Text { text: "7.2"; font.pixelSize: 24; font.weight: Font.Bold; color: "#A78BFA" }
                                Text { text: "平均时长(h)"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: "85%"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                                Text { text: "睡眠质量"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: "23:15"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                                Text { text: "平均入睡"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                    }
                }
                
                // 心率数据
                Rectangle {
                    width: parent.width - 32
                    height: 140
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        Text {
                            text: "❤️ 心率数据"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        Row {
                            width: parent.width
                            spacing: 20
                            
                            Column {
                                spacing: 4
                                Text { text: "72"; font.pixelSize: 24; font.weight: Font.Bold; color: dangerColor }
                                Text { text: "平均心率"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: "58"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                                Text { text: "最低心率"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: "145"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                                Text { text: "最高心率"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                    }
                }
                
                // 周总结
                Rectangle {
                    width: parent.width - 32
                    height: 100
                    radius: 16
                    color: isDarkMode ? "#1A1A1C" : "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Text {
                            text: "🎯 本周表现良好！"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: "比上周多走了 8,234 步，继续保持！"
                            font.pixelSize: 13
                            color: textSecondary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}