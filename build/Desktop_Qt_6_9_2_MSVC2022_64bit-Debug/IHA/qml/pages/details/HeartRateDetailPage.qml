import QtQuick
import QtQuick.Controls

Item {
    id: root
    
    property var navigationStack: null
    
    // 使用全局主题
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color pressedColor: isDarkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color dividerColor: isDarkMode ? "#27272A" : "#E5E5EA"
    readonly property color progressBg: isDarkMode ? "#27272A" : "#E5E5EA"
    
    // 模拟数据
    property int currentHeartRate: 72
    property int minHeartRate: 52
    property int maxHeartRate: 142
    property int avgHeartRate: 75
    property int restingHeartRate: 58
    
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
                color: heartBackMouseArea.pressed ? pressedColor : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: textPrimary
                }
                
                MouseArea {
                    id: heartBackMouseArea
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
                text: "心率"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: textPrimary
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
                
                // 当前心率卡片
                Rectangle {
                    width: parent.width - 32
                    height: 180
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Row {
                            spacing: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                width: 20
                                height: 20
                                radius: 10
                                color: "#EF4444"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: currentHeartRate
                                font.pixelSize: 56
                                font.weight: Font.Bold
                                color: textPrimary
                            }
                            
                            Text {
                                text: "次/分"
                                font.pixelSize: 16
                                color: textSecondary
                                anchors.baseline: parent.children[1].baseline
                            }
                        }
                        
                        Text {
                            text: "当前心率"
                            font.pixelSize: 16
                            color: textSecondary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: "正常范围"
                            font.pixelSize: 14
                            color: "#22C55E"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                
                // 心率曲线图
                Rectangle {
                    width: parent.width - 32
                    height: 200
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Text {
                            text: "今日心率曲线"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                        }
                        
                        // 心率图表区域
                        Canvas {
                            id: heartRateCanvas
                            width: parent.width
                            height: 120
                            
                            property var dataPoints: [62, 58, 55, 52, 54, 58, 65, 78, 95, 110, 98, 85, 92, 105, 142, 128, 95, 88, 82, 78, 75, 72, 70, 68]
                            
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                
                                // 绘制背景网格
                                ctx.strokeStyle = isDarkMode ? "#27272A" : "#E5E5EA"
                                ctx.lineWidth = 1
                                for (var i = 0; i < 5; i++) {
                                    var y = i * height / 4
                                    ctx.beginPath()
                                    ctx.moveTo(0, y)
                                    ctx.lineTo(width, y)
                                    ctx.stroke()
                                }
                                
                                // 绘制曲线
                                ctx.strokeStyle = "#EF4444"
                                ctx.lineWidth = 2
                                ctx.beginPath()
                                
                                var maxHR = 150
                                var minHR = 40
                                var range = maxHR - minHR
                                
                                for (var j = 0; j < dataPoints.length; j++) {
                                    var x = j * width / (dataPoints.length - 1)
                                    var pointY = height - ((dataPoints[j] - minHR) / range) * height
                                    
                                    if (j === 0) {
                                        ctx.moveTo(x, pointY)
                                    } else {
                                        ctx.lineTo(x, pointY)
                                    }
                                }
                                ctx.stroke()
                                
                                // 绘制最后一个点
                                ctx.fillStyle = "#EF4444"
                                ctx.beginPath()
                                ctx.arc(width, height - ((dataPoints[dataPoints.length-1] - minHR) / range) * height, 6, 0, Math.PI * 2)
                                ctx.fill()
                            }
                            
                            Component.onCompleted: requestPaint()
                        }
                        
                        Row {
                            width: parent.width
                            Text { text: "00:00"; font.pixelSize: 10; color: textSecondary }
                            Item { width: parent.width - 80; height: 1 }
                            Text { text: "现在"; font.pixelSize: 10; color: textSecondary }
                        }
                    }
                }
                
                // 心率范围统计
                Rectangle {
                    width: parent.width - 32
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        width: parent.width
                        
                        // 最低心率
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#3B82F6"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "↓"
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        text: "最低心率"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Row {
                                        spacing: 2
                                        Text {
                                            text: minHeartRate
                                            font.pixelSize: 18
                                            font.weight: Font.Bold
                                            color: textPrimary
                                        }
                                        Text {
                                            text: "次/分"
                                            font.pixelSize: 12
                                            color: textSecondary
                                            anchors.baseline: parent.children[0].baseline
                                        }
                                    }
                                }
                                
                                Item { width: parent.width - 220; height: 1 }
                                
                                Text {
                                    text: "03:42"
                                    font.pixelSize: 14
                                    color: textSecondary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width - 32
                            height: 1
                            color: dividerColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // 平均心率
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#22C55E"
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
                                    
                                    Text {
                                        text: "平均心率"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Row {
                                        spacing: 2
                                        Text {
                                            text: avgHeartRate
                                            font.pixelSize: 18
                                            font.weight: Font.Bold
                                            color: textPrimary
                                        }
                                        Text {
                                            text: "次/分"
                                            font.pixelSize: 12
                                            color: textSecondary
                                            anchors.baseline: parent.children[0].baseline
                                        }
                                    }
                                }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width - 32
                            height: 1
                            color: dividerColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // 最高心率
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#EF4444"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "↑"
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        text: "最高心率"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Row {
                                        spacing: 2
                                        Text {
                                            text: maxHeartRate
                                            font.pixelSize: 18
                                            font.weight: Font.Bold
                                            color: textPrimary
                                        }
                                        Text {
                                            text: "次/分"
                                            font.pixelSize: 12
                                            color: textSecondary
                                            anchors.baseline: parent.children[0].baseline
                                        }
                                    }
                                }
                                
                                Item { width: parent.width - 220; height: 1 }
                                
                                Text {
                                    text: "15:28"
                                    font.pixelSize: 14
                                    color: textSecondary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                        
                        Rectangle {
                            width: parent.width - 32
                            height: 1
                            color: dividerColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // 静息心率
                        Rectangle {
                            width: parent.width
                            height: 56
                            color: "transparent"
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: "#7D5FFF"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "R"
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                                
                                Column {
                                    spacing: 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        text: "静息心率"
                                        font.pixelSize: 14
                                        color: textSecondary
                                    }
                                    
                                    Row {
                                        spacing: 2
                                        Text {
                                            text: restingHeartRate
                                            font.pixelSize: 18
                                            font.weight: Font.Bold
                                            color: textPrimary
                                        }
                                        Text {
                                            text: "次/分"
                                            font.pixelSize: 12
                                            color: textSecondary
                                            anchors.baseline: parent.children[0].baseline
                                        }
                                    }
                                }
                                
                                Item { width: parent.width - 220; height: 1 }
                                
                                Text {
                                    text: "优秀"
                                    font.pixelSize: 14
                                    color: "#22C55E"
                                    anchors.verticalCenter: parent.verticalCenter
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