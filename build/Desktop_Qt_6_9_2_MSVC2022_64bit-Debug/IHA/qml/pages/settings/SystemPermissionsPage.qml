import QtQuick
import QtQuick.Controls

Rectangle {
    id: permissionsPage
    
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
            color: permissionsPage.color
            
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
                text: "系统权限"
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
                width: permissionsPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                // 权限说明
                Rectangle {
                    width: parent.width - 32
                    height: 80
                    radius: 16
                    color: isDarkMode ? "#1A1A1C" : "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 6
                        
                        Text {
                            text: "为了更好地为您提供服务，请授予以下权限"
                            font.pixelSize: 14
                            color: textPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: "您可以在系统设置中随时更改权限"
                            font.pixelSize: 12
                            color: textSecondary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                
                // 权限列表
                Column {
                    width: parent.width
                    spacing: 12
                    
                    // 健康数据权限
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
                                radius: 12
                                color: successColor
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "❤️"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                
                                Text { text: "健康数据"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "读取心率、步数、睡眠等数据"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 60
                                height: 32
                                radius: 16
                                color: successColor
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "已开启"
                                    font.pixelSize: 12
                                    color: "#FFFFFF"
                                }
                            }
                        }
                    }
                    
                    // 运动权限
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
                                radius: 12
                                color: accentColor
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
                                width: parent.width - 140
                                
                                Text { text: "运动与健身"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "记录您的运动数据"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 60
                                height: 32
                                radius: 16
                                color: successColor
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "已开启"
                                    font.pixelSize: 12
                                    color: "#FFFFFF"
                                }
                            }
                        }
                    }
                    
                    // 通知权限
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
                                radius: 12
                                color: warningColor
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🔔"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                
                                Text { text: "通知"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "接收提醒和消息推送"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 60
                                height: 32
                                radius: 16
                                color: successColor
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "已开启"
                                    font.pixelSize: 12
                                    color: "#FFFFFF"
                                }
                            }
                        }
                    }
                    
                    // 位置权限
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
                                radius: 12
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "📍"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                
                                Text { text: "位置"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "记录运动轨迹（可选）"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 60
                                height: 32
                                radius: 16
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "未开启"
                                    font.pixelSize: 12
                                    color: textSecondary
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // 跳转到系统设置
                            }
                        }
                    }
                    
                    // 相机权限
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
                                radius: 12
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "📷"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                
                                Text { text: "相机"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "拍摄头像、分享运动成果（可选）"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 60
                                height: 32
                                radius: 16
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "未开启"
                                    font.pixelSize: 12
                                    color: textSecondary
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // 跳转到系统设置
                            }
                        }
                    }
                    
                    // 相册权限
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
                                radius: 12
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🖼️"
                                    font.pixelSize: 24
                                }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                
                                Text { text: "相册"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "保存运动截图（可选）"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 60
                                height: 32
                                radius: 16
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "未开启"
                                    font.pixelSize: 12
                                    color: textSecondary
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // 跳转到系统设置
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 20 }
                
                // 提示
                Rectangle {
                    width: parent.width - 32
                    height: 80
                    radius: 16
                    color: isDarkMode ? "#1A1A1C" : "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 6
                        
                        Text {
                            text: "💡 提示"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            color: textPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: "部分权限为可选权限，不影响基本功能使用"
                            font.pixelSize: 12
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