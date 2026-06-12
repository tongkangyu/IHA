import QtQuick
import QtQuick.Controls

Rectangle {
    id: ordersPage
    
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
            color: ordersPage.color
            
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
                text: "我的订单"
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
                width: ordersPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                // 待付款订单
                Text {
                    text: "待付款"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
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
                                width: 60
                                height: 60
                                radius: 10
                                color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "⌚"
                                    font.pixelSize: 28
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 90
                                
                                Text { text: "智能运动手表 Pro"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "颜色: 星空黑"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                        }
                        
                        Item {
                            width: parent.width
                            height: 40
                            
                            Text {
                                text: "¥1,299.00"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                                color: dangerColor
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Rectangle {
                                width: 80
                                height: 32
                                radius: 16
                                color: dangerColor
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "去付款"
                                    font.pixelSize: 13
                                    color: "#FFFFFF"
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 8 }
                
                // 待收货订单
                Text {
                    text: "待收货"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
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
                                width: 60
                                height: 60
                                radius: 10
                                color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🎧"
                                    font.pixelSize: 28
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 90
                                
                                Text { text: "运动蓝牙耳机"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "颜色: 活力橙"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                        }
                        
                        Item {
                            width: parent.width
                            height: 40
                            
                            Text {
                                text: "¥299.00"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                                color: warningColor
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Rectangle {
                                width: 80
                                height: 32
                                radius: 16
                                color: warningColor
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "确认收货"
                                    font.pixelSize: 13
                                    color: "#FFFFFF"
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 8 }
                
                // 已完成订单
                Text {
                    text: "已完成"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                // 已完成订单1
                Rectangle {
                    width: parent.width - 32
                    height: 100
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8
                        
                        Row {
                            width: parent.width
                            spacing: 12
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 10
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "👕"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 80
                                
                                Text { text: "运动速干T恤"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "¥99.00 · 2026-02-15"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        Text {
                            text: "交易完成"
                            font.pixelSize: 12
                            color: successColor
                            anchors.right: parent.right
                        }
                    }
                }
                
                // 已完成订单2
                Rectangle {
                    width: parent.width - 32
                    height: 100
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8
                        
                        Row {
                            width: parent.width
                            spacing: 12
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 10
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "👟"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 80
                                
                                Text { text: "专业跑步鞋"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "¥599.00 · 2026-01-20"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        Text {
                            text: "交易完成"
                            font.pixelSize: 12
                            color: successColor
                            anchors.right: parent.right
                        }
                    }
                }
                
                // 已完成订单3
                Rectangle {
                    width: parent.width - 32
                    height: 100
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8
                        
                        Row {
                            width: parent.width
                            spacing: 12
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 10
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🧴"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 80
                                
                                Text { text: "运动水壶"; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "¥49.00 · 2026-01-05"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        Text {
                            text: "交易完成"
                            font.pixelSize: 12
                            color: successColor
                            anchors.right: parent.right
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}