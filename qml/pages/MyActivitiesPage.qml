import QtQuick
import QtQuick.Controls

Rectangle {
    id: activitiesPage
    
    color: typeof window !== 'undefined' && window.darkMode ? "#0D0D0F" : "#F5F5F7"
    
    readonly property color cardColor: typeof window !== 'undefined' && window.darkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: typeof window !== 'undefined' && window.darkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: typeof window !== 'undefined' && window.darkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color pressedColor: typeof window !== 'undefined' && window.darkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color accentColor: "#007AFF"
    readonly property color successColor: "#34C759"
    readonly property color warningColor: "#FF9500"
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    
    Column {
        anchors.fill: parent
        
        // 顶部导航栏
        Rectangle {
            width: parent.width
            height: 56
            color: activitiesPage.color
            
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
                text: "我的活动"
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
                width: activitiesPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                // 活动统计
                Rectangle {
                    width: parent.width - 32
                    height: 100
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 30
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "15"; font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                            Text { text: "参与活动"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "8"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                            Text { text: "已完成"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "3"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                            Text { text: "进行中"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                // 进行中的活动
                Text {
                    text: "进行中"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                // 活动1
                Rectangle {
                    width: parent.width - 32
                    height: 140
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 10
                        
                        Row {
                            width: parent.width
                            spacing: 12
                            
                            Rectangle {
                                width: 50
                                height: 50
                                radius: 12
                                color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🏃"
                                    font.pixelSize: 26
                                }
                            }
                            
                            Column {
                                spacing: 2
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 70
                                
                                Text { text: "春季跑步挑战赛"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "剩余3天"; font.pixelSize: 13; color: warningColor }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width
                            height: 6
                            radius: 3
                            color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                            
                            Rectangle {
                                width: parent.width * 0.72
                                height: 6
                                radius: 3
                                color: accentColor
                            }
                        }
                        
                        Text {
                            text: "已完成 36/50 公里"
                            font.pixelSize: 13
                            color: textSecondary
                        }
                    }
                }
                
                // 活动2
                Rectangle {
                    width: parent.width - 32
                    height: 140
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 10
                        
                        Row {
                            width: parent.width
                            spacing: 12
                            
                            Rectangle {
                                width: 50
                                height: 50
                                radius: 12
                                color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🚴"
                                    font.pixelSize: 26
                                }
                            }
                            
                            Column {
                                spacing: 2
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 70
                                
                                Text { text: "骑行达人赛"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "剩余5天"; font.pixelSize: 13; color: warningColor }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width
                            height: 6
                            radius: 3
                            color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                            
                            Rectangle {
                                width: parent.width * 0.45
                                height: 6
                                radius: 3
                                color: successColor
                            }
                        }
                        
                        Text {
                            text: "已完成 45/100 公里"
                            font.pixelSize: 13
                            color: textSecondary
                        }
                    }
                }
                
                // 活动3
                Rectangle {
                    width: parent.width - 32
                    height: 140
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 10
                        
                        Row {
                            width: parent.width
                            spacing: 12
                            
                            Rectangle {
                                width: 50
                                height: 50
                                radius: 12
                                color: isDarkMode ? "#2A5A3D" : "#E0F5E8"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🎯"
                                    font.pixelSize: 26
                                }
                            }
                            
                            Column {
                                spacing: 2
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 70
                                
                                Text { text: "每日打卡挑战"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "剩余12天"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width
                            height: 6
                            radius: 3
                            color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                            
                            Rectangle {
                                width: parent.width * 0.6
                                height: 6
                                radius: 3
                                color: warningColor
                            }
                        }
                        
                        Text {
                            text: "已打卡 18/30 天"
                            font.pixelSize: 13
                            color: textSecondary
                        }
                    }
                }
                
                Item { width: 1; height: 8 }
                
                // 已完成的活动
                Text {
                    text: "已完成"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                // 已完成活动1
                Rectangle {
                    width: parent.width - 32
                    height: 80
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Rectangle {
                            width: 48
                            height: 48
                            radius: 12
                            color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🏅"
                                font.pixelSize: 24
                            }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 90
                            
                            Text { text: "冬季健身挑战"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "获得第3名 · 2026年1月"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                // 已完成活动2
                Rectangle {
                    width: parent.width - 32
                    height: 80
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Rectangle {
                            width: 48
                            height: 48
                            radius: 12
                            color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🏆"
                                font.pixelSize: 24
                            }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 90
                            
                            Text { text: "元旦健步走"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "完成挑战 · 2026年1月"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}