import QtQuick
import QtQuick.Controls

Rectangle {
    id: healthReportPage
    
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
    property string reportInsight: ""
    property var weekSteps: []
    property var weekSleep: []
    property var weekHR: []
    property int totalSteps: { var s=0; for(var i=0;i<weekSteps.length;i++) s+=weekSteps[i]; return s }
    property string totalKm: (totalSteps * 0.0007).toFixed(1)
    property int avgSleepMin: { if(!weekSleep.length) return 0; var s=0; for(var i=0;i<weekSleep.length;i++) s+=weekSleep[i]; return Math.round(s/weekSleep.length) }
    property int avgHR: { if(!weekHR.length) return 0; var s=0; for(var i=0;i<weekHR.length;i++) s+=weekHR[i]; return Math.round(s/weekHR.length) }
    property int minHR: { if(!weekHR.length) return 0; var m=999; for(var i=0;i<weekHR.length;i++) if(weekHR[i]<m) m=weekHR[i]; return m }
    property int maxHR: { if(!weekHR.length) return 0; var m=0; for(var i=0;i<weekHR.length;i++) if(weekHR[i]>m) m=weekHR[i]; return m }

    Component.onCompleted: {
        if (typeof healthDataManager !== 'undefined' && typeof userService !== 'undefined' && userService.isLoggedIn) {
            healthDataManager.fetchWeeklyReport(userService.getToken())
            weekSteps = healthDataManager.getWeeklySteps()
            weekSleep = healthDataManager.getWeeklySleep()
            weekHR = healthDataManager.getWeeklyHeartRate()
        }
    }

    Connections {
        target: typeof healthDataManager !== 'undefined' ? healthDataManager : null
        function onWeeklyReportReady(reportText) {
            healthReportPage.reportInsight = reportText
        }
    }

    Column {
        anchors.fill: parent
        
        // 顶部导航栏
        Rectangle {
            width: parent.width
            height: 56
            color: healthReportPage.color
            
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
                            navigationStack.goBack()
                        }
                    }
                }
            }
            
            Text {
                text: "运动健康周报"
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
                width: healthReportPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                // 周期选择
                Rectangle {
                    width: parent.width - 32
                    height: 50
                    radius: 16
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        Text {
                            text: "‹"
                            font.pixelSize: 20
                            color: textSecondary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Text {
                            text: {
                                var end = new Date()
                                var start = new Date(end.getTime() - 6*24*60*60*1000)
                                return Qt.formatDate(start,"yyyy.MM.dd") + " ~ " + Qt.formatDate(end,"yyyy.MM.dd")
                            }
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            color: textPrimary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Text {
                            text: "›"
                            font.pixelSize: 20
                            color: textSecondary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                
                // 运动概览
                Rectangle {
                    width: parent.width - 32
                    height: 180
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16
                        
                        Text {
                            text: "📊 本周运动概览"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        Row {
                            width: parent.width
                            spacing: 20
                            
                            Column {
                                spacing: 4
                                Text { text: totalSteps.toLocaleString(); font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                                Text { text: "总步数"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: totalKm; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                                Text { text: "公里"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: Math.round(totalSteps * 0.04).toLocaleString(); font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                                Text { text: "卡路里"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                        
                        // 进度条
                        Rectangle {
                            width: parent.width
                            height: 8
                            radius: 4
                            color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                            
                            Rectangle {
                                width: parent.width * 0.75
                                height: 8
                                radius: 4
                                color: accentColor
                            }
                        }
                        
                        Text {
                            text: "完成周目标的 75%"
                            font.pixelSize: 13
                            color: textSecondary
                        }
                    }
                }
                
                // 步数统计
                Rectangle {
                    width: parent.width - 32
                    height: 200
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        Text {
                            text: "📅 每日步数"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        // 简化的柱状图
                        Row {
                            width: parent.width
                            height: 120
                            spacing: 8
                            
                            Repeater {
                                model: {
                                    var days = ["一","二","三","四","五","六","日"]
                                    var maxV = 1
                                    for (var i = 0; i < weekSteps.length; i++) if (weekSteps[i] > maxV) maxV = weekSteps[i]
                                    var arr = []
                                    for (var j = 0; j < 7; j++) {
                                        var v = j < weekSteps.length ? weekSteps[j] / maxV : 0.5
                                        arr.push({day: days[j], value: v})
                                    }
                                    return arr
                                }
                                
                                Column {
                                    width: (parent.width - 48) / 7
                                    height: parent.height
                                    spacing: 4
                                    
                                    Item { width: 1; height: 10 }
                                    
                                    Rectangle {
                                        width: parent.width - 4
                                        height: (parent.parent.height - 50) * modelData.value
                                        radius: 4
                                        color: accentColor
                                        opacity: 0.3 + modelData.value * 0.7
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    
                                    Text {
                                        text: modelData.day
                                        font.pixelSize: 12
                                        color: textSecondary
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }
                }
                
                // 睡眠质量
                Rectangle {
                    width: parent.width - 32
                    height: 140
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        Text {
                            text: "😴 睡眠质量"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        Row {
                            width: parent.width
                            spacing: 20
                            
                            Column {
                                spacing: 4
                                Text { text: (avgSleepMin / 60.0).toFixed(1); font.pixelSize: 24; font.weight: Font.Bold; color: "#A78BFA" }
                                Text { text: "平均时长(h)"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: "85%"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                                Text { text: "睡眠质量"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: "23:15"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                                Text { text: "平均入睡"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                    }
                }
                
                // 心率数据
                Rectangle {
                    width: parent.width - 32
                    height: 140
                    radius: 20
                    color: cardColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12
                        
                        Text {
                            text: "❤️ 心率数据"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                        }
                        
                        Row {
                            width: parent.width
                            spacing: 20
                            
                            Column {
                                spacing: 4
                                Text { text: avgHR > 0 ? "" + avgHR : "72"; font.pixelSize: 24; font.weight: Font.Bold; color: dangerColor }
                                Text { text: "平均心率"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: minHR > 0 ? "" + minHR : "58"; font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                                Text { text: "最低心率"; font.pixelSize: 13; color: textSecondary }
                            }
                            
                            Column {
                                spacing: 4
                                Text { text: maxHR > 0 ? "" + maxHR : "145"; font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                                Text { text: "最高心率"; font.pixelSize: 13; color: textSecondary }
                            }
                        }
                    }
                }
                
                // 周总结
                Rectangle {
                    id: summaryCard
                    width: parent.width - 32
                    height: summaryCol.height + 32
                    radius: 16
                    color: isDarkMode ? "#1A1A1C" : "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Column {
                        id: summaryCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8
                        
                        Text {
                            text: healthReportPage.reportInsight !== "" ? "AI 健康洞察" : "本周表现良好"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: textPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            text: healthReportPage.reportInsight !== "" ? healthReportPage.reportInsight : "登录后可生成 AI 健康周报分析"
                            font.pixelSize: 13
                            color: textSecondary
                            width: parent.width
                            wrapMode: Text.Wrap
                            lineHeight: 1.5
                        }
                    }
                }
                
                Item { width: 1; height: 24 }
            }
        }
    }
}