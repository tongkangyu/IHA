import QtQuick
import QtQuick.Controls

Rectangle {
    id: coursesPage
    
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
            color: coursesPage.color
            
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
                            navigationStack.popToRight()
                        }
                    }
                }
            }
            
            Text {
                text: "我的课程"
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
                width: coursesPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                // 课程统计
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
                            Text { text: "6"; font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                            Text { text: "已学课程"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "12"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                            Text { text: "学习小时"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "3"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                            Text { text: "获得证书"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                // 正在学习
                Text {
                    text: "正在学习"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                // 课程1
                Rectangle {
                    width: parent.width - 32
                    height: 120
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16
                        
                        Rectangle {
                            width: 80
                            height: 88
                            radius: 12
                            color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🧘"
                                font.pixelSize: 36
                            }
                        }
                        
                        Column {
                            spacing: 8
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 120
                            
                            Text { text: "瑜伽入门课程"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "共12节课 · 已学8节"; font.pixelSize: 13; color: textSecondary }
                            
                            Rectangle {
                                width: parent.width
                                height: 6
                                radius: 3
                                color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                
                                Rectangle {
                                    width: parent.width * 0.67
                                    height: 6
                                    radius: 3
                                    color: accentColor
                                }
                            }
                            
                            Text { text: "进度 67%"; font.pixelSize: 12; color: textSecondary }
                        }
                    }
                }
                
                // 课程2
                Rectangle {
                    width: parent.width - 32
                    height: 120
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16
                        
                        Rectangle {
                            width: 80
                            height: 88
                            radius: 12
                            color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                anchors.centerIn: parent
                                text: "💪"
                                font.pixelSize: 36
                            }
                        }
                        
                        Column {
                            spacing: 8
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 120
                            
                            Text { text: "居家健身计划"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "共20节课 · 已学5节"; font.pixelSize: 13; color: textSecondary }
                            
                            Rectangle {
                                width: parent.width
                                height: 6
                                radius: 3
                                color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                
                                Rectangle {
                                    width: parent.width * 0.25
                                    height: 6
                                    radius: 3
                                    color: successColor
                                }
                            }
                            
                            Text { text: "进度 25%"; font.pixelSize: 12; color: textSecondary }
                        }
                    }
                }
                
                Item { width: 1; height: 8 }
                
                // 已完成课程
                Text {
                    text: "已完成"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                // 已完成课程1
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
                                text: "🏃"
                                font.pixelSize: 24
                            }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 90
                            
                            Text { text: "跑步基础训练"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "已获得证书"; font.pixelSize: 13; color: successColor }
                        }
                    }
                }
                
                // 已完成课程2
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
                                text: "🧠"
                                font.pixelSize: 24
                            }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 90
                            
                            Text { text: "冥想入门"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "已获得证书"; font.pixelSize: 13; color: successColor }
                        }
                    }
                }
                
                // 已完成课程3
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
                                text: "🥗"
                                font.pixelSize: 24
                            }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 90
                            
                            Text { text: "健康饮食指南"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                            Text { text: "已获得证书"; font.pixelSize: 13; color: successColor }
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}