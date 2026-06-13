import QtQuick
import QtQuick.Controls

Rectangle {
    id: coursesPage
    
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
    
    readonly property var inProgressCourses: {
        var arr = []
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].status !== "COMPLETED") arr.push(dataList[i])
        return arr
    }
    readonly property var completedCourses: {
        var arr = []
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].status === "COMPLETED") arr.push(dataList[i])
        return arr
    }
    
    Component.onCompleted: {
        if (typeof userService === 'undefined' || !userService.isLoggedIn) return
        var xhr = new XMLHttpRequest()
        xhr.open("GET", (typeof apiBaseUrl !== 'undefined' ? apiBaseUrl : "http://localhost:8080/api") + "/courses")
        xhr.setRequestHeader("Authorization", "Bearer " + userService.getToken())
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var res = JSON.parse(xhr.responseText)
                if (res.code === 200) dataList = res.data
            }
        }
        xhr.send()
    }
    
    Column {
        anchors.fill: parent
        
        Rectangle {
            width: parent.width
            height: 56
            color: coursesPage.color
            
            Rectangle {
                x: 8
                y: 10
                width: 36
                height: 36
                radius: 18
                color: backMA.pressed ? pressedColor : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "\u2039"
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
                text: "我的课程"
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
                width: coursesPage.width
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
                            Text { text: dataList.length.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                            Text { text: "已学课程"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            property int totalCompleted: {
                                var t = 0
                                for (var i = 0; i < dataList.length; i++) t += dataList[i].completed_lessons
                                return t
                            }
                            Text { text: parent.totalCompleted.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: successColor }
                            Text { text: "已学课时"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: completedCourses.length.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                            Text { text: "获得证书"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                Text {
                    text: "正在学习"
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
                        model: inProgressCourses
                        
                        Rectangle {
                            width: coursesPage.width - 32
                            height: 120
                            radius: 16
                            color: cardColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16
                                
                                Rectangle {
                                    width: 80
                                    height: 88
                                    radius: 12
                                    color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.category ? modelData.category.charAt(0) : "课"
                                        font.pixelSize: 36
                                        color: accentColor
                                    }
                                }
                                
                                Column {
                                    spacing: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 120
                                    
                                    Text { text: modelData.name; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                    Text { text: "共" + modelData.total_lessons + "节课 · 已学" + modelData.completed_lessons + "节"; font.pixelSize: 13; color: textSecondary }
                                    
                                    Rectangle {
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                        
                                        Rectangle {
                                            width: modelData.total_lessons > 0 ? parent.width * (modelData.completed_lessons / modelData.total_lessons) : 0
                                            height: 6
                                            radius: 3
                                            color: accentColor
                                        }
                                    }
                                    
                                    Text { text: "进度 " + (modelData.total_lessons > 0 ? Math.round(modelData.completed_lessons / modelData.total_lessons * 100) : 0) + "%"; font.pixelSize: 12; color: textSecondary }
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 8 }
                
                Text {
                    text: "已完成"
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
                        model: completedCourses
                        
                        Rectangle {
                            width: coursesPage.width - 32
                            height: 80
                            radius: 16
                            color: cardColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12
                                
                                Rectangle {
                                    width: 48
                                    height: 48
                                    radius: 12
                                    color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.category ? modelData.category.charAt(0) : "课"
                                        font.pixelSize: 24
                                        color: successColor
                                    }
                                }
                                
                                Column {
                                    spacing: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 90
                                    
                                    Text { text: modelData.name; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                    Text { text: "已获得证书"; font.pixelSize: 13; color: successColor }
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
