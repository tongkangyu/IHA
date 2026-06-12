import QtQuick
import QtQuick.Controls

Rectangle {
    id: badgesPage
    
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
            color: badgesPage.color
            
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
                text: "我的勋章"
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
                width: badgesPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                // 勋章统计
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
                            Text { text: "12"; font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                            Text { text: "已获勋章"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "3"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                            Text { text: "进行中"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "8"; font.pixelSize: 24; font.weight: Font.Bold; color: textSecondary }
                            Text { text: "未解锁"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                // 已获得勋章
                Text {
                    text: "已获得勋章"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                // 勋章网格
                Grid {
                    width: parent.width - 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 4
                    spacing: 12
                    
                    // 勋章 1
                    Rectangle {
                        width: (parent.width - 36) / 4
                        height: (parent.width - 36) / 4 + 24
                        color: "transparent"
                        
                        Column {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                width: parent.width
                                height: parent.width
                                radius: parent.width / 2
                                color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "500"
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: textPrimary
                                }
                            }
                            
                            Text {
                                text: "500步"
                                font.pixelSize: 10
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // 勋章 2
                    Rectangle {
                        width: (parent.width - 36) / 4
                        height: (parent.width - 36) / 4 + 24
                        color: "transparent"
                        
                        Column {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                width: parent.width
                                height: parent.width
                                radius: parent.width / 2
                                color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🏃"
                                    font.pixelSize: 24
                                    color: textPrimary
                                }
                            }
                            
                            Text {
                                text: "首次运动"
                                font.pixelSize: 10
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // 勋章 3
                    Rectangle {
                        width: (parent.width - 36) / 4
                        height: (parent.width - 36) / 4 + 24
                        color: "transparent"
                        
                        Column {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                width: parent.width
                                height: parent.width
                                radius: parent.width / 2
                                color: isDarkMode ? "#5A2A3D" : "#F5E0E8"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "365"
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: textPrimary
                                }
                            }
                            
                            Text {
                                text: "365天"
                                font.pixelSize: 10
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // 勋章 4
                    Rectangle {
                        width: (parent.width - 36) / 4
                        height: (parent.width - 36) / 4 + 24
                        color: "transparent"
                        
                        Column {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                width: parent.width
                                height: parent.width
                                radius: parent.width / 2
                                color: isDarkMode ? "#2A5A3D" : "#E0F5E8"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "5K"
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: textPrimary
                                }
                            }
                            
                            Text {
                                text: "运动达人"
                                font.pixelSize: 10
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // 勋章 5
                    Rectangle {
                        width: (parent.width - 36) / 4
                        height: (parent.width - 36) / 4 + 24
                        color: "transparent"
                        
                        Column {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                width: parent.width
                                height: parent.width
                                radius: parent.width / 2
                                color: isDarkMode ? "#1A3A5A" : "#E0E8F5"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "💤"
                                    font.pixelSize: 24
                                    color: textPrimary
                                }
                            }
                            
                            Text {
                                text: "早睡早起"
                                font.pixelSize: 10
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // 勋章 6
                    Rectangle {
                        width: (parent.width - 36) / 4
                        height: (parent.width - 36) / 4 + 24
                        color: "transparent"
                        
                        Column {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                width: parent.width
                                height: parent.width
                                radius: parent.width / 2
                                color: isDarkMode ? "#4A2A5A" : "#E8E0F5"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "30"
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: textPrimary
                                }
                            }
                            
                            Text {
                                text: "30天打卡"
                                font.pixelSize: 10
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // 勋章 7
                    Rectangle {
                        width: (parent.width - 36) / 4
                        height: (parent.width - 36) / 4 + 24
                        color: "transparent"
                        
                        Column {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                width: parent.width
                                height: parent.width
                                radius: parent.width / 2
                                color: isDarkMode ? "#5A4A2A" : "#F5EDE0"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🏆"
                                    font.pixelSize: 24
                                    color: textPrimary
                                }
                            }
                            
                            Text {
                                text: "冠军"
                                font.pixelSize: 10
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // 勋章 8
                    Rectangle {
                        width: (parent.width - 36) / 4
                        height: (parent.width - 36) / 4 + 24
                        color: "transparent"
                        
                        Column {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                width: parent.width
                                height: parent.width
                                radius: parent.width / 2
                                color: isDarkMode ? "#2A4A4A" : "#E0F5F5"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🏊"
                                    font.pixelSize: 24
                                    color: textPrimary
                                }
                            }
                            
                            Text {
                                text: "首次游泳"
                                font.pixelSize: 10
                                color: textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 8 }
                
                // 进行中
                Text {
                    text: "进行中"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                // 进行中的勋章
                Column {
                    width: parent.width
                    spacing: 12
                    
                    // 进行中 1
                    Rectangle {
                        width: parent.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🎯"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 130
                                
                                Text { text: "100天打卡"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                
                                Rectangle {
                                    width: parent.width
                                    height: 6
                                    radius: 3
                                    color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                    
                                    Rectangle {
                                        width: parent.width * 0.85
                                        height: 6
                                        radius: 3
                                        color: accentColor
                                    }
                                }
                                
                                Text { text: "85/100"; font.pixelSize: 12; color: textSecondary }
                            }
                        }
                    }
                    
                    // 进行中 2
                    Rectangle {
                        width: parent.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "📏"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 130
                                
                                Text { text: "步行100公里"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                
                                Rectangle {
                                    width: parent.width
                                    height: 6
                                    radius: 3
                                    color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                    
                                    Rectangle {
                                        width: parent.width * 0.62
                                        height: 6
                                        radius: 3
                                        color: successColor
                                    }
                                }
                                
                                Text { text: "62/100 公里"; font.pixelSize: 12; color: textSecondary }
                            }
                        }
                    }
                    
                    // 进行中 3
                    Rectangle {
                        width: parent.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🔥"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 130
                                
                                Text { text: "燃烧10000卡路里"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                
                                Rectangle {
                                    width: parent.width
                                    height: 6
                                    radius: 3
                                    color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                    
                                    Rectangle {
                                        width: parent.width * 0.45
                                        height: 6
                                        radius: 3
                                        color: warningColor
                                    }
                                }
                                
                                Text { text: "4,500/10,000 卡路里"; font.pixelSize: 12; color: textSecondary }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}