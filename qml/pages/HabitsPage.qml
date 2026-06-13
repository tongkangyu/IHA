import QtQuick
import QtQuick.Controls

Rectangle {
    id: habitsPage
    
    property var navigationStack: null
    property var dataList: []
    
    color: typeof window !== 'undefined' && window.darkMode ? "#0D0D0F" : "#F5F5F7"
    
    readonly property color cardColor: typeof window !== 'undefined' && window.darkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: typeof window !== 'undefined' && window.darkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: typeof window !== 'undefined' && window.darkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color pressedColor: typeof window !== 'undefined' && window.darkMode ? "#2A2A2C" : "#E5E5EA"
    readonly property color accentColor: "#007AFF"
    readonly property color successColor: "#34C759"
    readonly property color warningColor: "#FF9500"
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    
    readonly property int completedCount: {
        var c = 0
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].completed_today) c++
        return c
    }
    readonly property int pendingCount: dataList.length - completedCount
    readonly property int maxStreak: {
        var m = 0
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].streak > m) m = dataList[i].streak
        return m
    }
    
    function fetchHabits() {
        if (typeof userService === 'undefined' || !userService.isLoggedIn) return
        var xhr = new XMLHttpRequest()
        xhr.open("GET", (typeof apiBaseUrl !== 'undefined' ? apiBaseUrl : "http://localhost:8080/api") + "/habits")
        xhr.setRequestHeader("Authorization", "Bearer " + userService.getToken())
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var res = JSON.parse(xhr.responseText)
                if (res.code === 200) dataList = res.data
            }
        }
        xhr.send()
    }

    function toggleHabit(habitId) {
        if (typeof userService === 'undefined' || !userService.isLoggedIn) return
        var xhr = new XMLHttpRequest()
        var base = (typeof apiBaseUrl !== 'undefined' ? apiBaseUrl : "http://localhost:8080/api")
        xhr.open("POST", base + "/habits")
        xhr.setRequestHeader("Authorization", "Bearer " + userService.getToken())
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) fetchHabits()
        }
        xhr.send(JSON.stringify({habit_id: habitId, action: "toggle"}))
    }

    Component.onCompleted: fetchHabits()
    
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
                            Text { text: completedCount.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                            Text { text: "今日完成"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: pendingCount.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                            Text { text: "待完成"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: maxStreak.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
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
                    
                    Repeater {
                        model: dataList
                        
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
                                    id: habitIcon
                                    width: 48
                                    height: 48
                                    radius: 12
                                    color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text { anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 20; color: accentColor }
                                }
                                
                                Column {
                                    spacing: 4
                                    anchors.left: habitIcon.right
                                    anchors.leftMargin: 16
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text { text: modelData.name; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                    Text { text: (modelData.target_time ? modelData.target_time : "") + " - 连续" + modelData.streak + "天"; font.pixelSize: 13; color: textSecondary }
                                }
                                
                                Rectangle {
                                    width: 48
                                    height: 48
                                    radius: 24
                                    color: modelData.completed_today ? successColor : (isDarkMode ? "#3A3A3C" : "#E5E5EA")
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text { anchors.centerIn: parent; text: modelData.completed_today ? "\u2713" : ""; font.pixelSize: 22; font.weight: Font.Bold; color: "#FFFFFF" }
                                    MouseArea { anchors.fill: parent; onClicked: toggleHabit(modelData.habit_id) }
                                }
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
