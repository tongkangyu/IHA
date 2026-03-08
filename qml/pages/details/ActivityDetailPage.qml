import QtQuick
import QtQuick.Controls

Item {
    id: root
    
    property var navigationStack: null
    
    // 模拟数据
    property int activityMinutes: 85
    property int activityGoal: 120
    property int todayActivity: 4
    property int activityGoalCount: 12
    property var weeklyData: [45, 62, 78, 55, 90, 85, 72]
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
                text: "中高强度活动"
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
                
                // 今日活动时长卡片
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
                                color: "#3B82F6"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: activityMinutes.toLocaleString()
                                font.pixelSize: 48
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                            
                            Text {
                                text: "分钟"
                                font.pixelSize: 16
                                color: "#A1A1AA"
                                anchors.baseline: parent.children[1].baseline
                            }
                        }
                        
                        Text {
                            text: "今日活动时长"
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
                                width: parent.width * Math.min(activityMinutes / activityGoal, 1)
                                height: parent.height
                                radius: 4
                                color: "#3B82F6"
                            }
                        }
                        
                        Text {
                            text: "目标: " + activityGoal + " 分钟"
                            font.pixelSize: 14
                            color: "#71717A"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                
                // 活动次数卡片
                Rectangle {
                    width: parent.width - 32
                    height: 100
                    radius: 16
                    color: "#1E1E20"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 20
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: "今日活动次数"
                                font.pixelSize: 14
                                color: "#A1A1AA"
                            }
                            
                            Row {
                                spacing: 4
                                Text {
                                    text: todayActivity
                                    font.pixelSize: 32
                                    font.weight: Font.Bold
                                    color: "#22C55E"
                                }
                                Text {
                                    text: "/" + activityGoalCount + " 次"
                                    font.pixelSize: 16
                                    color: "#A1A1AA"
                                    anchors.baseline: parent.children[0].baseline
                                }
                            }
                        }
                        
                        Item { width: parent.width - 200; height: 1 }
                        
                        // 活动次数进度环
                        Rectangle {
                            width: 64
                            height: 64
                            radius: 32
                            color: "#27272A"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Rectangle {
                                anchors.centerIn: parent
                                width: 52
                                height: 52
                                radius: 26
                                color: "#1E1E20"
                            }
                            
                            Canvas {
                                anchors.fill: parent
                                
                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.clearRect(0, 0, width, height)
                                    
                                    var centerX = width / 2
                                    var centerY = height / 2
                                    var radius = (width - 6) / 2
                                    var startAngle = -Math.PI / 2
                                    var endAngle = startAngle + (Math.PI * 2 * Math.min(todayActivity / activityGoalCount, 1))
                                    
                                    ctx.beginPath()
                                    ctx.arc(centerX, centerY, radius, startAngle, endAngle)
                                    ctx.strokeStyle = "#22C55E"
                                    ctx.lineWidth = 6
                                    ctx.lineCap = "round"
                                    ctx.stroke()
                                }
                                
                                Component.onCompleted: requestPaint()
                            }
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
                                            height: parent.height * (weeklyData[index] / 120)
                                            radius: 4
                                            color: index === 5 ? "#3B82F6" : "#6366F1"
                                            anchors.bottom: parent.bottom
                                        }
                                    }
                                    
                                    Text {
                                        text: weekDays[index]
                                        font.pixelSize: 12
                                        color: index === 5 ? "#3B82F6" : "#71717A"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }
                }
                
                // 活动类型
                Rectangle {
                    width: parent.width - 32
                    radius: 16
                    color: "#1E1E20"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        width: parent.width
                        
                        // 高强度活动
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#EF4444"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "H"
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 64
                                    
                                    Text {
                                        text: "高强度活动"
                                        font.pixelSize: 14
                                        color: "#A1A1AA"
                                    }
                                    
                                    Text {
                                        text: "25 分钟"
                                        font.pixelSize: 16
                                        font.weight: Font.DemiBold
                                        color: "#FFFFFF"
                                    }
                                }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width - 32
                            height: 1
                            color: "#27272A"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // 中强度活动
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#3B82F6"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "M"
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 64
                                    
                                    Text {
                                        text: "中强度活动"
                                        font.pixelSize: 14
                                        color: "#A1A1AA"
                                    }
                                    
                                    Text {
                                        text: "60 分钟"
                                        font.pixelSize: 16
                                        font.weight: Font.DemiBold
                                        color: "#FFFFFF"
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
