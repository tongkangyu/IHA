import QtQuick
import QtQuick.Controls

Item {
    id: assistantPage
    
    Column {
        anchors.fill: parent
        
        // 顶部标题栏
        Rectangle {
            width: parent.width
            height: 56
            color: "#121214"
            
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: "助理"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#FFFFFF"
            }
        }
        
        // 消息列表
        ListView {
            id: messageList
            width: parent.width
            height: parent.height - 56 - 60
            model: ListModel {
                ListElement { type: "ai"; content: "您好！我是您的健康助理。"; time: "20:30" }
                ListElement { type: "user"; content: "我最近睡眠质量怎么样？"; time: "20:31" }
                ListElement { type: "ai"; content: "您最近一周的平均睡眠时长为7小时15分钟，睡眠质量评分85分。"; time: "20:31" }
            }
            spacing: 16
            clip: true
            anchors.margins: 16
            
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }
            
            delegate: Item {
                width: messageList.width - 32
                height: messageBubble.height + 8
                
                Rectangle {
                    id: messageBubble
                    width: Math.min(contentText.implicitWidth + 24, parent.width - 60)
                    height: contentText.implicitHeight + 16
                    radius: 12
                    
                    anchors.left: type === "ai" ? parent.left : undefined
                    anchors.right: type === "user" ? parent.right : undefined
                    color: type === "ai" ? "#1E1E20" : "#FF6B35"
                    
                    Text {
                        id: contentText
                        anchors.fill: parent
                        anchors.margins: 12
                        text: content
                        font.pixelSize: 14
                        color: "#FFFFFF"
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
        
        // 输入区域
        Rectangle {
            width: parent.width
            height: 60
            color: "#121214"
            
            Row {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8
                
                Rectangle {
                    width: parent.width - 60
                    height: 40
                    radius: 20
                    color: "#1E1E20"
                    anchors.verticalCenter: parent.verticalCenter
                    
                    TextInput {
                        anchors.fill: parent
                        anchors.margins: 16
                        font.pixelSize: 14
                        color: "#FFFFFF"
                        placeholderText: "输入您的问题..."
                        placeholderTextColor: "#71717A"
                    }
                }
                
                Rectangle {
                    width: 44
                    height: 44
                    radius: 22
                    color: "#FF6B35"
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: ">"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                        rotation: -90
                    }
                }
            }
        }
    }
}