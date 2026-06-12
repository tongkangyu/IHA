import QtQuick
import QtQuick.Controls

Item {
    id: assistantPage

    property var navigationStack: null

    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#8E8E93"
    readonly property color headerColor: isDarkMode ? "#121214" : "#F5F5F7"
    readonly property color accentColor: "#FF6B35"
    readonly property color btnColor: isDarkMode ? "#1E1E20" : "#E5E5EA"
    readonly property color thinkingColor: isDarkMode ? "#2A2A2C" : "#E8E8E8"

    ListModel {
        id: messageModel
    }

    property bool isWaiting: false

    function updateWaiting() {
        if (typeof aiService !== 'undefined') {
            isWaiting = aiService.isLoading
        } else {
            isWaiting = false
        }
    }

    Rectangle { anchors.fill: parent; color: bgColor }

    Connections {
        target: typeof aiService !== 'undefined' ? aiService : null

        function onIsLoadingChanged() { updateWaiting() }

        function onConversationLoaded() {
            messageModel.clear()
            var messages = aiService.getConversationForQML()
            if (messages.length === 0) {
                messageModel.append({ type: "ai", content: "您好！我是您的全生态健康管家。我可以帮您分析健康数据、提供运动建议、结合环境数据给出联动建议。请问有什么可以帮您的？" })
            } else {
                for (var i = 0; i < messages.length; i++) {
                    messageModel.append({ type: messages[i].type, content: messages[i].content })
                }
            }
            messageList.positionViewAtEnd()
        }

        function onResponseReceived(response) {
            removeThinkingMessage()
            messageModel.append({ type: "ai", content: response })
            messageList.positionViewAtEnd()
        }

        function onErrorOccurred(error) {
            removeThinkingMessage()
            messageModel.append({ type: "ai", content: "抱歉，出现了错误：" + error })
            messageList.positionViewAtEnd()
        }
    }

    Component.onCompleted: {
        updateWaiting()
        if (typeof aiService !== 'undefined') {
            aiService.loadConversation()
        } else {
            messageModel.append({ type: "ai", content: "您好！我是您的健康助理。我可以帮您分析健康数据、提供运动建议、解答健康相关问题。请问有什么可以帮您的？" })
        }
    }

    function removeThinkingMessage() {
        if (messageModel.count > 0) {
            var last = messageModel.get(messageModel.count - 1)
            if (last.type === "thinking") {
                messageModel.remove(messageModel.count - 1)
            }
        }
    }

    function getHealthContext() {
        if (typeof healthDataManager === 'undefined') return ""

        var stepsPercent = Math.round(healthDataManager.todaySteps / healthDataManager.stepsGoal * 100)
        var caloriesPercent = Math.round(healthDataManager.todayCalories / healthDataManager.caloriesGoal * 100)
        var activityPercent = Math.round(healthDataManager.todayActivity / healthDataManager.activityGoal * 100)
        var sleepHours = Math.floor(healthDataManager.todaySleepMinutes / 60)
        var sleepMins = healthDataManager.todaySleepMinutes % 60

        return "【今日健康数据】\n" +
               "• 步数: " + healthDataManager.todaySteps + "/" + healthDataManager.stepsGoal + "步 (" + stepsPercent + "%)\n" +
               "• 卡路里: " + healthDataManager.todayCalories + "/" + healthDataManager.caloriesGoal + "千卡 (" + caloriesPercent + "%)\n" +
               "• 活动次数: " + healthDataManager.todayActivity + "/" + healthDataManager.activityGoal + "次 (" + activityPercent + "%)\n" +
               "• 睡眠: " + sleepHours + "小时" + sleepMins + "分钟\n" +
               "• 心率: " + healthDataManager.todayHeartRate + "次/分钟\n" +
               "• 中高强度活动: " + healthDataManager.moderateActivityMinutes + "分钟"
    }

    function sendMessage(text) {
        if (text.trim() === "" || isWaiting) return

        var userMessage = text.trim()

        messageModel.append({ type: "user", content: userMessage })
        inputField.text = ""
        messageModel.append({ type: "thinking", content: "正在思考..." })
        messageList.positionViewAtEnd()

        if (typeof aiService !== 'undefined') {
            aiService.sendMessage(userMessage, getHealthContext())
        } else {
            thinkingTimer.start()
        }
    }

    Timer {
        id: thinkingTimer
        interval: 1500
        repeat: false
        onTriggered: {
            removeThinkingMessage()
            messageModel.append({ type: "ai", content: "AI服务未连接。请检查网络连接或联系开发者。" })
            messageList.positionViewAtEnd()
        }
    }

    Column {
        anchors.fill: parent

        Rectangle {
            width: parent.width; height: 56; color: headerColor
            Row {
                anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                Text { text: "健康助理"; font.pixelSize: 24; font.weight: Font.Bold; color: textPrimary; anchors.verticalCenter: parent.verticalCenter }
                Item { width: parent.width - 150; height: 1 }
                Rectangle {
                    width: 36; height: 36; radius: 18; color: clearMA.pressed ? (isDarkMode ? "#3A3A3C" : "#D0D0D0") : btnColor; anchors.verticalCenter: parent.verticalCenter
                    Text { anchors.centerIn: parent; text: "↻"; font.pixelSize: 18; color: textSecondary }
                    MouseArea {
                        id: clearMA; anchors.fill: parent
                        onClicked: {
                            if (typeof aiService !== 'undefined') aiService.clearConversation()
                            messageModel.clear()
                            messageModel.append({ type: "ai", content: "您好！我是您的全生态健康管家。我可以帮您分析健康数据、提供运动建议、结合环境数据给出联动建议。请问有什么可以帮您的？" })
                        }
                    }
                }
            }
        }

        ListView {
            id: messageList
            width: parent.width; height: parent.height - 156
            model: messageModel; spacing: 12; clip: true
            header: Item { height: 16 }
            footer: Item { height: 16 }

            delegate: Item {
                width: messageList.width; height: msgBubble.height + 12
                Rectangle {
                    id: msgBubble
                    anchors.right: model.type === "user" ? parent.right : undefined
                    anchors.rightMargin: model.type === "user" ? 16 : 0
                    anchors.left: model.type === "user" ? undefined : parent.left
                    anchors.leftMargin: model.type === "user" ? 0 : 16
                    width: Math.min(msgContent.implicitWidth + 24, parent.width * 0.8)
                    height: msgContent.implicitHeight + 24
                    radius: 16
                    color: model.type === "user" ? accentColor : model.type === "thinking" ? thinkingColor : cardColor
                    Text {
                        id: msgContent; anchors.fill: parent; anchors.margins: 12
                        text: model.content; font.pixelSize: 14
                        color: model.type === "user" ? "#FFFFFF" : textPrimary
                        wrapMode: Text.Wrap; verticalAlignment: Text.AlignTop
                    }
                    BusyIndicator {
                        visible: model.type === "thinking"; running: visible
                        width: 20; height: 20
                        anchors.right: parent.right; anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Rectangle {
            width: parent.width; height: 100; color: headerColor
            Column {
                x: 12; y: 12; width: parent.width - 24; spacing: 8

                Row {
                    spacing: 8
                    Repeater {
                        model: [
                            { text: "今日报告", prompt: "请分析一下我今天的健康数据，给我一个简要报告" },
                            { text: "运动建议", prompt: "根据我的健康数据，给我一些运动建议" },
                            { text: "睡眠分析", prompt: "分析一下我的睡眠质量，给出一些建议" }
                        ]
                        delegate: Rectangle {
                            width: btnText.width + 16; height: 28; radius: 14
                            color: quickMA.pressed ? (isDarkMode ? "#3A3A3C" : "#D0D0D0") : cardColor
                            Text { id: btnText; text: modelData.text; font.pixelSize: 12; color: textPrimary; anchors.centerIn: parent }
                            MouseArea { id: quickMA; anchors.fill: parent; onClicked: sendMessage(modelData.prompt) }
                        }
                    }
                }

                Item {
                    width: parent.width; height: 40
                    Rectangle {
                        id: inputRect; anchors.left: parent.left; anchors.right: sendBtn.left; anchors.rightMargin: 10
                        height: 40; radius: 20; color: cardColor
                        TextEdit {
                            id: inputField; anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                            font.pixelSize: 14; color: textPrimary; wrapMode: TextEdit.Wrap
                            verticalAlignment: TextEdit.AlignVCenter; activeFocusOnPress: true
                            Text { anchors.fill: parent; font.pixelSize: 14; color: textSecondary
                                text: (!inputField.activeFocus && inputField.text.length === 0) ? "输入健康相关问题..." : ""
                                verticalAlignment: Text.AlignVCenter }
                            Keys.onReturnPressed: sendMessage(text)
                        }
                    }
                    Rectangle {
                        id: sendBtn; anchors.right: parent.right; width: 40; height: 40; radius: 20
                        color: isWaiting ? (isDarkMode ? "#4A4A4C" : "#B0B0B0") : accentColor
                        Text { anchors.centerIn: parent; text: isWaiting ? "..." : "↑"; font.pixelSize: 20; font.weight: Font.Bold; color: "#FFFFFF" }
                        MouseArea { anchors.fill: parent; onClicked: sendMessage(inputField.text) }
                    }
                }
            }
        }
    }
}
