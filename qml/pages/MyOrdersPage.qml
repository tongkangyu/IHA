import QtQuick
import QtQuick.Controls

Rectangle {
    id: ordersPage
    
    property var dataList: []
    
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
    
    readonly property var pendingOrders: {
        var arr = []
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].status === "PENDING") arr.push(dataList[i])
        return arr
    }
    readonly property var shippedOrders: {
        var arr = []
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].status === "SHIPPED") arr.push(dataList[i])
        return arr
    }
    readonly property var completedOrders: {
        var arr = []
        for (var i = 0; i < dataList.length; i++)
            if (dataList[i].status === "COMPLETED") arr.push(dataList[i])
        return arr
    }
    
    Component.onCompleted: {
        if (typeof userService === 'undefined' || !userService.isLoggedIn) return
        var xhr = new XMLHttpRequest()
        xhr.open("GET", (typeof apiBaseUrl !== 'undefined' ? apiBaseUrl : "http://localhost:8080/api") + "/orders")
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
            color: ordersPage.color
            
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
                text: "我的订单"
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
                width: ordersPage.width
                spacing: 16
                
                Item { width: 1; height: 8 }
                
                Text {
                    text: "待付款"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    visible: pendingOrders.length > 0
                }
                
                Column {
                    width: parent.width
                    spacing: 12
                    visible: pendingOrders.length > 0
                    
                    Repeater {
                        model: pendingOrders
                        
                        Rectangle {
                            width: ordersPage.width - 32
                            height: 140
                            radius: 16
                            color: cardColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 10
                                
                                Row {
                                    width: parent.width
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 60
                                        height: 60
                                        radius: 10
                                        color: isDarkMode ? "#2A4A5A" : "#D4E8ED"
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "购"
                                            font.pixelSize: 28
                                            color: accentColor
                                        }
                                    }
                                    
                                    Column {
                                        spacing: 4
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 90
                                        
                                        Text { text: modelData.product_name; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                        Text { text: modelData.create_time; font.pixelSize: 13; color: textSecondary }
                                    }
                                }
                                
                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                }
                                
                                Item {
                                    width: parent.width
                                    height: 40
                                    
                                    Text {
                                        text: "\u00A5" + modelData.price.toFixed(2)
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: dangerColor
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    
                                    Rectangle {
                                        width: 80
                                        height: 32
                                        radius: 16
                                        color: dangerColor
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "去付款"
                                            font.pixelSize: 13
                                            color: "#FFFFFF"
                                        }
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 8; visible: pendingOrders.length > 0 }
                
                Text {
                    text: "待收货"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    visible: shippedOrders.length > 0
                }
                
                Column {
                    width: parent.width
                    spacing: 12
                    visible: shippedOrders.length > 0
                    
                    Repeater {
                        model: shippedOrders
                        
                        Rectangle {
                            width: ordersPage.width - 32
                            height: 140
                            radius: 16
                            color: cardColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 10
                                
                                Row {
                                    width: parent.width
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 60
                                        height: 60
                                        radius: 10
                                        color: isDarkMode ? "#3D2D6B" : "#E8E0F5"
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "运"
                                            font.pixelSize: 28
                                            color: warningColor
                                        }
                                    }
                                    
                                    Column {
                                        spacing: 4
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 90
                                        
                                        Text { text: modelData.product_name; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                        Text { text: modelData.create_time; font.pixelSize: 13; color: textSecondary }
                                    }
                                }
                                
                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: isDarkMode ? "#2A2A2C" : "#E5E5EA"
                                }
                                
                                Item {
                                    width: parent.width
                                    height: 40
                                    
                                    Text {
                                        text: "\u00A5" + modelData.price.toFixed(2)
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: warningColor
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    
                                    Rectangle {
                                        width: 80
                                        height: 32
                                        radius: 16
                                        color: warningColor
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "确认收货"
                                            font.pixelSize: 13
                                            color: "#FFFFFF"
                                        }
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Item { width: 1; height: 8; visible: shippedOrders.length > 0 }
                
                Text {
                    text: "已完成"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: textPrimary
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    visible: completedOrders.length > 0
                }
                
                Column {
                    width: parent.width
                    spacing: 12
                    visible: completedOrders.length > 0
                    
                    Repeater {
                        model: completedOrders
                        
                        Rectangle {
                            width: ordersPage.width - 32
                            height: 100
                            radius: 16
                            color: cardColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 8
                                
                                Row {
                                    width: parent.width
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 48
                                        height: 48
                                        radius: 10
                                        color: isDarkMode ? "#3A3A3C" : "#E5E5EA"
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "完"
                                            font.pixelSize: 24
                                            color: successColor
                                        }
                                    }
                                    
                                    Column {
                                        spacing: 4
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 80
                                        
                                        Text { text: modelData.product_name; font.pixelSize: 15; font.weight: Font.Medium; color: textPrimary }
                                        Text { text: "\u00A5" + modelData.price.toFixed(2) + " · " + modelData.create_time; font.pixelSize: 13; color: textSecondary }
                                    }
                                }
                                
                                Text {
                                    text: "交易完成"
                                    font.pixelSize: 12
                                    color: successColor
                                    anchors.right: parent.right
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
