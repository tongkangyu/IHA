import QtQuick
import QtQuick.Controls

Item {
    id: aboutPage
    
    property var navigationStack: null
    
    // 使用全局主题
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color pressedColor: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    
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
                color: backMouseArea.pressed ? pressedColor : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: textPrimary
                }
                
                MouseArea {
                    id: backMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (navigationStack) {
                            navigationStack.popToRight()
                        }
                    }
                }
            }
            
            // 标题
            Text {
                text: "关于"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: textPrimary
                anchors.centerIn: parent
            }
        }
        
        // 内容区域
        Column {
            width: parent.width
            spacing: 16
            anchors.margins: 20
            
            Item { width: 1; height: 40 }
            
            // 应用图标和名称
            Rectangle {
                width: 80
                height: 80
                radius: 20
                color: "#FF6B35"
                anchors.horizontalCenter: parent.horizontalCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "IHA"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }
            }
            
            Text {
                text: "IHA"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text {
                text: "版本 0.1.18"
                font.pixelSize: 16
                color: textSecondary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Item { width: 1; height: 24 }
            
            // 作者信息
            Rectangle {
                width: parent.width - 40
                height: 72
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
                        radius: 20
                        color: "#7D5FFF"
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: "👤"
                            font.pixelSize: 20
                        }
                    }
                    
                    Column {
                        spacing: 2
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: "作者"
                            font.pixelSize: 13
                            color: textSecondary
                        }
                        
                        Text {
                            text: "超懒哥"
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            color: textPrimary
                        }
                    }
                }
            }
            
            // GitHub 地址
            Rectangle {
                width: parent.width - 40
                height: 72
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
                        radius: 8
                        color: "#24292E"
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: "G"
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            color: "#FFFFFF"
                        }
                    }
                    
                    Column {
                        spacing: 2
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: "GitHub"
                            font.pixelSize: 13
                            color: textSecondary
                        }
                        
                        Text {
                            text: "github.com/tongkangyu/IHA"
                            font.pixelSize: 14
                            color: "#007AFF"
                        }
                    }
                    
                    Item { width: parent.width - 280; height: 1 }
                    
                    Text {
                        text: "›"
                        font.pixelSize: 20
                        color: textSecondary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally("https://github.com/tongkangyu/IHA")
                }
            }
            
            Item { width: 1; height: 24 }
            
            // 版权信息
            Text {
                text: "© 2026 超懒哥. All rights reserved."
                font.pixelSize: 12
                color: textSecondary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
