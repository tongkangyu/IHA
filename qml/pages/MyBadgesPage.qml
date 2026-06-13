import QtQuick
import QtQuick.Controls

Rectangle {
    id: badgesPage
    
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
    
    readonly property var earnedBadges: {
        var arr = []
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].status === "EARNED") arr.push(dataList[i])
        return arr
    }
    readonly property var inProgressBadges: {
        var arr = []
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].status === "IN_PROGRESS") arr.push(dataList[i])
        return arr
    }
    readonly property var lockedBadges: {
        var arr = []
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].status === "LOCKED") arr.push(dataList[i])
        return arr
    }
    
    Component.onCompleted: {
        if (typeof userService === 'undefined' || !userService.isLoggedIn) return
        var xhr = new XMLHttpRequest()
        xhr.open("GET", (typeof apiBaseUrl !== 'undefined' ? apiBaseUrl : "http://localhost:8080/api") + "/badges")
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
            color: badgesPage.color
            
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
                text: "我的勋章"
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
                width: badgesPage.width
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
                            Text { text: earnedBadges.length.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: accentColor }
                            Text { text: "已获勋章"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: inProgressBadges.length.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: warningColor }
                            Text { text: "进行中"; font.pixelSize: 13; color: textSecondary }
                        }
                        
                        Column {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Text { text: lockedBadges.length.toString(); font.pixelSize: 24; font.weight: Font.Bold; color: textSecondary }
                            Text { text: "未解锁"; font.pixelSize: 13; color: textSecondary }
                        }
                    }
                }
                
                Text {
                    text: "已获得勋章"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
                
                Grid {
                    width: parent.width - 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 4
                    spacing: 12
                    
                    Repeater {
                        model: earnedBadges
                        
                        Rectangle {
                            width: (parent.width - 36) / 4
                            height: (parent.width - 36) / 4 + 24
                            color: "transparent"
                            
                            Column {
                                anchors.fill: parent
                                spacing: 4
                                
                                Rectangle {
                                    width: parent.width
                                    height: parent.width
                                    radius: parent.width / 2
                                    color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.icon
                                        font.pixelSize: 14
                                        font.weight: Font.Bold
                                        color: textPrimary
                                    }
                                }
                                
                                Text {
                                    text: modelData.name
                                    font.pixelSize: 10
                                    color: textSecondary
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    elide: Text.ElideRight
                                    width: parent.width
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 8 }
                
                Text {
                    text: "进行中"
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
                        model: inProgressBadges
                        
                        Rectangle {
                            width: parent.width - 32
                            height: 80
                            radius: 16
                            color: cardColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16
                                
                                Rectangle {
                                    width: 48
                                    height: 48
                                    radius: 24
                                    color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.icon
                                        font.pixelSize: 24
                                    }
                                }
                                
                                Column {
                                    spacing: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 130
                                    
                                    Text { text: modelData.name; font.pixelSize: 16; font.weight: Font.Medium; color: textPrimary }
                                    
                                    Rectangle {
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                        
                                        Rectangle {
                                            width: modelData.target > 0 ? parent.width * (modelData.progress / modelData.target) : 0
                                            height: 6
                                            radius: 3
                                            color: accentColor
                                        }
                                    }
                                    
                                    Text { text: modelData.progress + "/" + modelData.target; font.pixelSize: 12; color: textSecondary }
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
