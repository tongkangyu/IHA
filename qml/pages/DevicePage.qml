import QtQuick
import QtQuick.Controls

Item {
    id: devicePage
    
    property string deviceName: "REDMI Watch 6"
    property string deviceStatus: "已连接"
    property int deviceBattery: 44
    property string deviceLastCharge: "距上次充电已4天"
    
    // 使用全局主题
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color btnColor: isDarkMode ? "#1E1E20" : "#E5E5EA"
    readonly property color dividerColor: isDarkMode ? "#27272A" : "#E5E5EA"
    readonly property color arrowColor: isDarkMode ? "#71717A" : "#C7C7CC"
    readonly property color deviceBg: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    
    Column {
        anchors.fill: parent
        
        // 顶部标题栏
        Rectangle {
            width: parent.width
            height: 56
            color: headerColor
            
            Row {
                anchors.fill: parent
                anchors.margins: 16
                
                Text {
                    text: "穿戴设备"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.verticalCenter: parent.verticalCenter
                }
                
                Item { width: parent.width - 150; height: 1 }
                
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: btnColor
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "+"
                        font.pixelSize: 20
                        color: textPrimary
                    }
                }
            }
        }
        
        ScrollView {
            width: parent.width
            height: parent.height - 56
            clip: true
            
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            
            Column {
                width: devicePage.width
                spacing: 16
                anchors.margins: 16
                
                // 设备信息卡片
                Rectangle {
                    width: parent.width - 32
                    height: 140
                    radius: 16
                    color: cardColor
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16
                        
                        // 设备预览
                        Rectangle {
                            width: 90
                            height: 110
                            radius: 12
                            color: deviceBg
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Column {
                                anchors.centerIn: parent
                                spacing: 4
                                
                                Text {
                                    text: "10:09"
                                    font.family: "Consolas"
                                    font.pixelSize: 16
                                    font.weight: Font.Bold
                                    color: textPrimary
                                }
                                
                                Text {
                                    text: "3月7日 周六"
                                    font.pixelSize: 10
                                    color: textSecondary
                                }
                            }
                        }
                        
                        // 设备信息
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: deviceName
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                color: textPrimary
                            }
                            
                            Text {
                                text: deviceStatus
                                font.pixelSize: 14
                                color: "#22C55E"
                            }
                            
                            Row {
                                spacing: 4
                                Text {
                                    text: deviceBattery + "%"
                                    font.pixelSize: 14
                                    color: textSecondary
                                }
                                
                                Rectangle {
                                    width: 24
                                    height: 12
                                    radius: 2
                                    color: isDarkMode ? "#27272A" : "#E5E5EA"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Rectangle {
                                        width: parent.width * (deviceBattery / 100)
                                        height: parent.height
                                        radius: 2
                                        color: deviceBattery > 20 ? "#22C55E" : "#F59E0B"
                                    }
                                }
                            }
                            
                            Text {
                                text: deviceLastCharge
                                font.pixelSize: 12
                                color: textSecondary
                            }
                        }
                    }
                    
                    // 同步按钮
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 16
                        width: 80
                        height: 32
                        radius: 16
                        color: "#FF6B35"
                        
                        Text {
                            anchors.centerIn: parent
                            text: "同步"
                            font.pixelSize: 14
                            color: "#FFFFFF"
                        }
                    }
                }
                
                // 功能菜单
                Rectangle {
                    width: parent.width - 32
                    radius: 16
                    color: cardColor
                    
                    Column {
                        width: parent.width
                        
                        Repeater {
                            model: [
                                { title: "应用商店", color: "#FF6B35" },
                                { title: "通知设置", color: "#3B82F6" },
                                { title: "运动健康设置", color: "#EF4444" },
                                { title: "系统设置", color: "#7D5FFF" },
                                { title: "更多设置", color: "#3B82F6" }
                            ]
                            
                            delegate: Rectangle {
                                width: parent.width
                                height: 56
                                color: "transparent"
                                
                                Rectangle {
                                    visible: index > 0
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.leftMargin: 52
                                    width: parent.width - 68
                                    height: 1
                                    color: dividerColor
                                }
                                
                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 32
                                        height: 32
                                        radius: 8
                                        color: modelData.color
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    
                                    Text {
                                        text: modelData.title
                                        font.pixelSize: 14
                                        color: textPrimary
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    
                                    Item { width: parent.width - 200; height: 1 }
                                    
                                    Text {
                                        text: ">"
                                        font.pixelSize: 16
                                        color: arrowColor
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}
