import QtQuick
import QtQuick.Controls

Item {
    id: appSettingsPage
    
    // 使用全局主题
    readonly property color bgColor: typeof window !== 'undefined' && window.darkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: typeof window !== 'undefined' && window.darkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: typeof window !== 'undefined' && window.darkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: typeof window !== 'undefined' && window.darkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color switchOnColor: "#007AFF"
    readonly property color switchOffColor: typeof window !== 'undefined' && window.darkMode ? "#3A3A3C" : "#E5E5EA"
    
    property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    
    Column {
        anchors.fill: parent
        
        // 顶部导航栏
        Rectangle {
            width: parent.width
            height: 56
            color: bgColor
            
            // 返回按钮
            Rectangle {
                x: 8
                y: 10
                width: 36
                height: 36
                radius: 18
                color: backMouseArea.pressed ? (isDarkMode ? "#2A2A2C" : "#E5E5EA") : "transparent"
                
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
                text: "App 设置"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: textPrimary
                anchors.centerIn: parent
            }
        }
        
        // 设置列表
        ScrollView {
            width: parent.width
            height: parent.height - 56
            clip: true
            
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            
            Column {
                width: appSettingsPage.width
                spacing: 12
                
                Item { width: 1; height: 4 }
                
                // 深色模式开关
                Rectangle {
                    width: parent.width - 32
                    height: 72
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12
                        
                        // 左侧文字
                        Column {
                            width: parent.width - 80
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4
                            
                            Text {
                                text: "深色模式"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: textPrimary
                            }
                            
                            Text {
                                text: "开启后界面将使用深色主题"
                                font.pixelSize: 13
                                color: textSecondary
                            }
                        }
                        
                        // 右侧开关
                        Rectangle {
                            id: darkModeSwitch
                            width: 52
                            height: 28
                            radius: 14
                            color: isDarkMode ? switchOnColor : switchOffColor
                            anchors.verticalCenter: parent.verticalCenter
                            
                            // 滑块
                            Rectangle {
                                width: 24
                                height: 24
                                radius: 12
                                color: "#FFFFFF"
                                anchors.verticalCenter: parent.verticalCenter
                                x: isDarkMode ? parent.width - 26 : 2
                                
                                Behavior on x {
                                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (typeof window !== 'undefined') {
                                        window.darkMode = !window.darkMode
                                    }
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 12 }
            }
        }
    }
}