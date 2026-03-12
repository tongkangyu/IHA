import QtQuick
import QtQuick.Controls

Rectangle {
    id: familyFriendsPage
    
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
            color: familyFriendsPage.color
            
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
                    onClicked: if (navigationStack) navigationStack.popToRight()
                }
            }
            
            Text {
                text: "我的亲友"
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
                width: familyFriendsPage.width
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
                            Text { text: "8"; font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                            Text { text: "亲友总数"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "5"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                            Text { text: "在线"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: "12"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                            Text { text: "互动次数"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                Text {
                    text: "亲友列表"
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
                        width: familyFriendsPage.width - 32
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
                                color: "#4A90D9"
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "爸"; font.pixelSize: 20; color: "#FFFFFF" }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                Text { text: "爸爸"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "今日步数: 8,542"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: successColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    Rectangle {
                        width: familyFriendsPage.width - 32
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
                                color: "#D94A8D"
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "妈"; font.pixelSize: 20; color: "#FFFFFF" }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                Text { text: "妈妈"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "今日步数: 6,231"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: successColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    Rectangle {
                        width: familyFriendsPage.width - 32
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
                                color: "#4AD98D"
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "明"; font.pixelSize: 20; color: "#FFFFFF" }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                Text { text: "小明"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "今日步数: 10,245"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: warningColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    Rectangle {
                        width: familyFriendsPage.width - 32
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
                                color: "#D9A84A"
                                anchors.verticalCenter: parent.verticalCenter
                                Text { anchors.centerIn: parent; text: "红"; font.pixelSize: 20; color: "#FFFFFF" }
                            }
                            
                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 140
                                Text { text: "小红"; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                Text { text: "今日步数: 9,876"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: successColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 20 }
                
                Rectangle {
                    width: parent.width - 32
                    height: 100
                    radius: 16
                    color: isDarkMode ? "#1A1A1C" : "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        Text { text: "添加亲友一起运动"; font.pixelSize: 15; font.weight: Font.Bold; color: textPrimary; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: "互相查看运动数据，共同进步"; font.pixelSize: 13; color: textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}