import QtQuick
import QtQuick.Controls

Item {
    id: profilePage
    
    Column {
        anchors.fill: parent
        
        // 顶部标题栏
        Rectangle {
            width: parent.width
            height: 56
            color: "#121214"
            
            Row {
                anchors.fill: parent
                anchors.margins: 16
                
                Text {
                    text: "我的"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                    anchors.verticalCenter: parent.verticalCenter
                }
                
                Item { width: parent.width - 100; height: 1 }
                
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: "#1E1E20"
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "+"
                        font.pixelSize: 20
                        color: "#FFFFFF"
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
                width: profilePage.width
                spacing: 16
                anchors.margins: 16
                
                // 用户信息
                Rectangle {
                    width: parent.width - 32
                    height: 80
                    radius: 16
                    color: "#1E1E20"
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16
                        
                        Rectangle {
                            width: 56
                            height: 56
                            radius: 28
                            color: "#7D5FFF"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                anchors.centerIn: parent
                                text: "U"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: "超懒哥"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                            
                            Text {
                                text: "男 | 175厘米 | 19岁"
                                font.pixelSize: 12
                                color: "#A1A1AA"
                            }
                        }
                    }
                }
                
                // 快捷入口
                Row {
                    width: parent.width - 32
                    spacing: 8
                    
                    Repeater {
                        model: ["我的活动", "我的课程", "我的订单", "我的亲友"]
                        
                        Rectangle {
                            width: (parent.width - 24) / 4
                            height: 72
                            radius: 12
                            color: "#1E1E20"
                            
                            Column {
                                anchors.centerIn: parent
                                spacing: 4
                                
                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: "#2A2A2C"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                
                                Text {
                                    text: modelData
                                    font.pixelSize: 12
                                    color: "#A1A1AA"
                                }
                            }
                        }
                    }
                }
                
                // VIP 横幅
                Rectangle {
                    width: parent.width - 32
                    height: 100
                    radius: 16
                    color: "#2D251F"
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8
                        
                        Row {
                            width: parent.width
                            
                            Text {
                                text: "VIP 小米运动健康会员"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                color: "#FFFFFF"
                            }
                            
                            Item { width: parent.width - 250; height: 1 }
                            
                            Rectangle {
                                width: 72
                                height: 28
                                radius: 14
                                color: "#FF6B35"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "立即开通"
                                    font.pixelSize: 12
                                    color: "#FFFFFF"
                                }
                            }
                        }
                        
                        Text {
                            text: "公立医生在线问诊 >"
                            font.pixelSize: 12
                            color: "#A1A1AA"
                        }
                    }
                }
                
                // 功能菜单
                Rectangle {
                    width: parent.width - 32
                    radius: 16
                    color: "#1E1E20"
                    
                    Column {
                        width: parent.width
                        
                        Repeater {
                            model: [
                                { title: "健康问诊", color: "#7D5FFF", badge: "NEW" },
                                { title: "App 设置", color: "#A78BFA", badge: "" },
                                { title: "系统权限", color: "#84CC16", badge: "" },
                                { title: "帮助与反馈", color: "#F59E0B", badge: "" },
                                { title: "App 版本", color: "#6366F1", badge: "V3.53.1" },
                                { title: "关于", color: "#0EA5E9", badge: "" }
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
                                    color: "#27272A"
                                }
                                
                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 16
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 32
                                        height: 32
                                        radius: 16
                                        color: modelData.color
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    
                                    Text {
                                        text: modelData.title
                                        font.pixelSize: 14
                                        color: "#FFFFFF"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    
                                    Item { width: parent.width - 200; height: 1 }
                                    
                                    // 标签
                                    Rectangle {
                                        visible: modelData.badge !== ""
                                        width: 36
                                        height: 18
                                        radius: 9
                                        color: modelData.badge === "NEW" ? "#F9E8C5" : "transparent"
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.badge
                                            font.pixelSize: 10
                                            font.weight: Font.Bold
                                            color: modelData.badge === "NEW" ? "#333333" : "#71717A"
                                        }
                                    }
                                    
                                    Text {
                                        text: ">"
                                        font.pixelSize: 16
                                        color: "#71717A"
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