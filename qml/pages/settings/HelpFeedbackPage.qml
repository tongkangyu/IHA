import QtQuick
import QtQuick.Controls

Rectangle {
    id: helpFeedbackPage
    
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
            color: helpFeedbackPage.color
            
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
                text: "帮助与反馈"
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
                width: helpFeedbackPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                // 搜索框
                Rectangle {
                    width: parent.width - 32
                    height: 44
                    radius: 12
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        Text {
                            text: "🔍"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Text {
                            text: "搜索帮助内容"
                            font.pixelSize: 15
                            color: textSecondary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                    }
                }
                
                // 常见问题
                Text {
                    text: "常见问题"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                Column {
                    width: parent.width
                    spacing: 12
                    
                    // 问题1
                    Rectangle {
                        width: parent.width - 32
                        height: 70
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 10
                                color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "❓"
                                    font.pixelSize: 20
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 80
                                
                                Text { text: "如何绑定设备？"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "在设备页面点击添加设备进行绑定"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                    
                    // 问题2
                    Rectangle {
                        width: parent.width - 32
                        height: 70
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 10
                                color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "❓"
                                    font.pixelSize: 20
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 80
                                
                                Text { text: "步数不准确怎么办？"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "检查设备佩戴位置和权限设置"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                    
                    // 问题3
                    Rectangle {
                        width: parent.width - 32
                        height: 70
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 10
                                color: isDarkMode ? "#2A5A3D" : "#E0F5E8"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "❓"
                                    font.pixelSize: 20
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 80
                                
                                Text { text: "数据同步失败？"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "请检查网络连接和设备蓝牙状态"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                    
                    // 问题4
                    Rectangle {
                        width: parent.width - 32
                        height: 70
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 10
                                color: isDarkMode ? "#5A2A3D" : "#F5E0E8"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "❓"
                                    font.pixelSize: 20
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 80
                                
                                Text { text: "如何修改个人信息？"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "在我的页面点击头像进入个人中心"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                }
                
                Item { width: 1; height: 8 }
                
                // 意见反馈
                Text {
                    text: "意见反馈"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                Column {
                    width: parent.width
                    spacing: 12
                    
                    // 功能建议
                    Rectangle {
                        width: parent.width - 32
                        height: 70
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 10
                                color: accentColor
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "💡"
                                    font.pixelSize: 20
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 100
                                
                                Text { text: "功能建议"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "告诉我们您想要的新功能"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Text {
                                text: "›"
                                font.pixelSize: 20
                                color: textSecondary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                    
                    // 问题反馈
                    Rectangle {
                        width: parent.width - 32
                        height: 70
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 10
                                color: warningColor
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🐛"
                                    font.pixelSize: 20
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 100
                                
                                Text { text: "问题反馈"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "报告应用中的问题或错误"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Text {
                                text: "›"
                                font.pixelSize: 20
                                color: textSecondary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                    
                    // 使用咨询
                    Rectangle {
                        width: parent.width - 32
                        height: 70
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 10
                                color: successColor
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "💬"
                                    font.pixelSize: 20
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 100
                                
                                Text { text: "使用咨询"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "咨询产品使用问题"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Text {
                                text: "›"
                                font.pixelSize: 20
                                color: textSecondary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                }
                
                Item { width: 1; height: 20 }
                
                // 联系方式
                Rectangle {
                    width: parent.width - 32
                    height: 120
                    radius: 16
                    color: isDarkMode ? "#1A1A1C" : "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        Text {
                            text: "📧 联系我们"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        Text {
                            text: "邮箱: support@iha-app.com"
                            font.pixelSize: 14
                            color: textSecondary
                        }
                        
                        Text {
                            text: "工作时间: 周一至周五 9:00-18:00"
                            font.pixelSize: 13
                            color: textSecondary
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}