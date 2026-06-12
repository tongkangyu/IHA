import QtQuick
import QtQuick.Controls

Rectangle {
    id: habitsPage
    
    property var navigationStack: null
    
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
        
        Rectangle {
            width: parent.width
            height: 56
            color: habitsPage.color
            
            Rectangle {
                x: 8
                y: 10
                width: 36
                height: 36
                radius: 18
                color: backMA.pressed ? pressedColor : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "<"
                    font.pixelSize: 24
                    color: textPrimary
                }
                
                MouseArea {
                    id: backMA
                    anchors.fill: parent
                    onClicked: if (navigationStack) navigationStack.goBack()
                }
            }
            
            Text {
                text: "小习惯"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: textPrimary
                anchors.centerIn: parent
            }
            
            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: addMA.pressed ? pressedColor : "transparent"
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "+"
                    font.pixelSize: 24
                    color: textPrimary
                }
                
                MouseArea {
                    id: addMA
                    anchors.fill: parent
                }
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
                width: habitsPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
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
                            Text { text: "5"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                            Text { text: "今日完成"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "3"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                            Text { text: "待完成"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "15"; font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                            Text { text: "连续天数"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                Text {
                    text: "今日习惯"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                Column {
                    width: parent.width
                    spacing: 12
                    
                    Rectangle {
                        width: habitsPage.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Item {
                            anchors.fill: parent
                            anchors.margins: 16
                            
                            Rectangle {
                                id: icon1
                                width: 48
                                height: 48
                                radius: 12
                                color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "早"; font.pixelSize: 20; color: "#7D5FFF" }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.left: icon1.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                Text { text: "早起打卡"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "06:30 - 连续15天"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: successColor
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "\u2713"; font.pixelSize: 22; font.weight: Font.Bold; color: "#FFFFFF" }
                            }
                        }
                    }
                    
                    Rectangle {
                        width: habitsPage.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Item {
                            anchors.fill: parent
                            anchors.margins: 16
                            
                            Rectangle {
                                id: icon2
                                width: 48
                                height: 48
                                radius: 12
                                color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "水"; font.pixelSize: 20; color: "#4A90D9" }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.left: icon2.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                Text { text: "喝水8杯"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "全天 - 连续12天"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: successColor
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "\u2713"; font.pixelSize: 22; font.weight: Font.Bold; color: "#FFFFFF" }
                            }
                        }
                    }
                    
                    Rectangle {
                        width: habitsPage.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Item {
                            anchors.fill: parent
                            anchors.margins: 16
                            
                            Rectangle {
                                id: icon3
                                width: 48
                                height: 48
                                radius: 12
                                color: isDarkMode ? "#2D6B4A" : "#D4EDD8"
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "读"; font.pixelSize: 20; color: "#34C759" }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.left: icon3.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                Text { text: "阅读30分钟"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "20:00 - 连续8天"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: successColor
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "\u2713"; font.pixelSize: 22; font.weight: Font.Bold; color: "#FFFFFF" }
                            }
                        }
                    }

                    Rectangle {
                        width: habitsPage.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter

                        Item {
                            anchors.fill: parent
                            anchors.margins: 16

                            Rectangle {
                                id: icon4
                                width: 48
                                height: 48
                                radius: 12
                                color: isDarkMode ? "#6B4A2D" : "#EDD8D4"
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "跑"; font.pixelSize: 20; color: "#FF9500" }
                            }

                            Column {
                                spacing: 4
                                anchors.left: icon4.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                Text { text: "运动健身"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "18:00 - 连续20天"; font.pixelSize: 13; color: textSecondary }
                            }

                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    Rectangle {
                        width: habitsPage.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter

                        Item {
                            anchors.fill: parent
                            anchors.margins: 16

                            Rectangle {
                                id: icon5
                                width: 48
                                height: 48
                                radius: 12
                                color: isDarkMode ? "#2D3D6B" : "#D4D8ED"
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "睡"; font.pixelSize: 20; color: "#5856D6" }
                            }

                            Column {
                                spacing: 4
                                anchors.left: icon5.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                Text { text: "早睡打卡"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "22:30 - 连续10天"; font.pixelSize: 13; color: textSecondary }
                            }

                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    Rectangle {
                        width: habitsPage.width - 32
                        height: 80
                        radius: 16
                        color: cardColor
                        anchors.horizontalCenter: parent.horizontalCenter

                        Item {
                            anchors.fill: parent
                            anchors.margins: 16

                            Rectangle {
                                id: icon6
                                width: 48
                                height: 48
                                radius: 12
                                color: isDarkMode ? "#6B2D5A" : "#EDD4E8"
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "静"; font.pixelSize: 20; color: "#AF52DE" }
                            }

                            Column {
                                spacing: 4
                                anchors.left: icon6.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                Text { text: "冥想10分钟"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "07:00 - 连续5天"; font.pixelSize: 13; color: textSecondary }
                            }

                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 20 }
                
                Rectangle {
                    width: parent.width - 32
                    height: 80
                    radius: 16
                    color: isDarkMode ? "#1A1A1C" : "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        Text { text: "坚持打卡，养成好习惯"; font.pixelSize: 14; color: textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: "连续打卡可获得勋章奖励"; font.pixelSize: 12; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}