import QtQuick
import QtQuick.Controls

Item {
    id: root
    
    property var navigationStack: null
    
    // 模拟数据
    property int todayActivityCount: 4
    property int activityCountGoal: 12
    property var activityList: [
        { type: "快走", time: "08:30", duration: "15分钟", icon: "W" },
        { type: "跑步", time: "12:15", duration: "20分钟", icon: "R" },
        { type: "骑行", time: "15:40", duration: "25分钟", icon: "B" },
        { type: "游泳", time: "18:00", duration: "30分钟", icon: "S" }
    ]
    property var weeklyData: [8, 12, 6, 10, 4, 4, 7]
    property var weekDays: ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    Column {
        anchors.fill: parent
        
        // 顶部导航栏
        Rectangle {
            width: parent.width
            height: 56
            color: "#121214"
            
            // 返回按钮
            Rectangle {
                x: 8
                y: 10
                width: 36
                height: 36
                radius: 18
                color: backMouseArea.pressed ? "#2A2A2C" : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }
                
                MouseArea {
                    id: backMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (navigationStack) {
                            navigationStack.pop()
                        }
                    }
                }
            }
            
            // 标题
            Text {
                text: "活动"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: "#FFFFFF"
                anchors.centerIn: parent
            }
        }
        
        ScrollView {
            width: parent.width
            height: parent.height - 56
            clip: true
            
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            
            Column {
                width: root.width
                spacing: 16
                
                // 今日活动次数卡片
                Rectangle {
                    width: parent.width - 32
                    height: 180
                    radius: 16
                    color: "#1E1E20"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Row {
                            spacing: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                color: "#22C55E"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: todayActivityCount.toLocaleString()
                                font.pixelSize: 48
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                            
                            Text {
                                text: "次"
                                font.pixelSize: 16
                                color: "#A1A1AA"
                                anchors.baseline: parent.children[1].baseline
                            }
                        }
                        
                        Text {
                            text: "今日活动"
                            font.pixelSize: 16
                            color: "#A1A1AA"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // 进度条
                        Rectangle {
                            width: 200
                            height: 8
                            radius: 4
                            color: "#27272A"
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                width: parent.width * Math.min(todayActivityCount / activityCountGoal, 1)
                                height: parent.height
                                radius: 4
                                color: "#22C55E"
                            }
                        }
                        
                        Text {
                            text: "目标: " + activityCountGoal + " 次"
                            font.pixelSize: 14
                            color: "#71717A"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                
                // 周数据统计
                Rectangle {
                    width: parent.width - 32
                    height: 200
                    radius: 16
                    color: "#1E1E20"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Text {
                            text: "本周统计"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: "#FFFFFF"
                        }
                        
                        // 柱状图
                        Row {
                            width: parent.width
                            height: 120
                            spacing: 8
                            
                            Repeater {
                                model: 7
                                
                                Column {
                                    width: (parent.width - 48) / 7
                                    height: parent.height
                                    spacing: 4
                                    
                                    Rectangle {
                                        width: parent.width - 8
                                        height: parent.height - 30
                                        radius: 4
                                        color: "#27272A"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        
                                        Rectangle {
                                            width: parent.width
                                            height: parent.height * (weeklyData[index] / 15)
                                            radius: 4
                                            color: index === 5 ? "#22C55E" : "#4ADE80"
                                            anchors.bottom: parent.bottom
                                        }
                                    }
                                    
                                    Text {
                                        text: weekDays[index]
                                        font.pixelSize: 12
                                        color: index === 5 ? "#22C55E" : "#71717A"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }
                }
                
                // 今日活动记录
                Rectangle {
                    width: parent.width - 32
                    radius: 16
                    color: "#1E1E20"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        width: parent.width
                        spacing: 0
                        
                        Repeater {
                            model: activityList
                            
                            delegate: Rectangle {
                                width: parent.width
                                height: 64
                                color: "transparent"
                                
                                Rectangle {
                                    visible: index > 0
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.leftMargin: 56
                                    width: parent.width - 72
                                    height: 1
                                    color: "#27272A"
                                }
                                
                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 40
                                        height: 40
                                        radius: 20
                                        color: "#22C55E"
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.icon
                                            font.pixelSize: 16
                                            font.weight: Font.Bold
                                            color: "#FFFFFF"
                                        }
                                    }
                                    
                                    Column {
                                        spacing: 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Text {
                                            text: modelData.type
                                            font.pixelSize: 16
                                            font.weight: Font.Medium
                                            color: "#FFFFFF"
                                        }
                                        
                                        Text {
                                            text: modelData.time + " · " + modelData.duration
                                            font.pixelSize: 13
                                            color: "#71717A"
                                        }
                                    }
                                    
                                    Item { width: parent.width - 200; height: 1 }
                                    
                                    Text {
                                        text: "1次"
                                        font.pixelSize: 14
                                        color: "#22C55E"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }
                        
                        // 空状态提示
                        Rectangle {
                            visible: activityList.length === 0
                            width: parent.width
                            height: 80
                            color: "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "暂无活动记录"
                                font.pixelSize: 14
                                color: "#71717A"
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}
