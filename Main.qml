import QtQuick
import QtQuick.Controls

Window {
    id: window
    
    width: 390
    height: 844
    visible: true
    title: "IHA - 智能健康助理"
    color: darkMode ? "#0D0D0F" : "#F5F5F7"
    
    // 全局深色模式
    property bool darkMode: true
    
    // 用户信息
    property string userName: "超懒哥"
    property string userGender: "男"  // 男 或 女
    property var userBirthday: new Date(2006, 3, 11)  // 2006年4月11日
    property int userHeight: 175  // 厘米
    property int userMaxHeartRate: 200  // 最大心率
    
    // 计算年龄
    readonly property int userAge: {
        var today = new Date()
        var age = today.getFullYear() - userBirthday.getFullYear()
        var m = today.getMonth() - userBirthday.getMonth()
        if (m < 0 || (m === 0 && today.getDate() < userBirthday.getDate())) {
            age--
        }
        return age
    }
    
    // 主题颜色
    readonly property color themeBgColor: darkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color themeCardColor: darkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color themeTextPrimary: darkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color themeTextSecondary: darkMode ? "#A1A1AA" : "#8E8E93"
    
    // 当前主页面索引
    property int currentTabIndex: 0
    
    // 上一个主页面索引（用于判断滑动方向）
    property int previousTabIndex: 0
    
    // 页面栈
    property var pageStack: []
    
    // 是否正在动画中
    property bool isAnimating: false
    
    // 全局助理消息模型（持久化对话记录）
    ListModel {
        id: assistantMessageModel
    }
    
    // 启动时加载对话记录
    Connections {
        target: typeof aiService !== 'undefined' ? aiService : null
        
        function onConversationLoaded() {
            console.log("Main: Conversation loaded signal received")
            
            // 清空现有消息
            assistantMessageModel.clear()
            
            // 从AI服务获取对话记录
            var messages = aiService.getConversationForQML()
            
            console.log("Main: Messages count from service:", messages.length)
            
            if (messages.length === 0) {
                // 如果没有历史记录，添加欢迎消息
                assistantMessageModel.append({ type: "ai", content: "您好！我是您的健康助理。我可以帮您分析健康数据、提供运动建议、解答健康相关问题。请问有什么可以帮您的？" })
            } else {
                // 恢复历史对话
                for (var i = 0; i < messages.length; i++) {
                    assistantMessageModel.append({
                        type: messages[i].type,
                        content: messages[i].content
                    })
                }
            }
        }
    }
    
    // 延迟加载对话记录（确保 aiService 已初始化）
    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: {
            if (typeof aiService !== 'undefined') {
                console.log("Main: Loading conversation...")
                aiService.loadConversation()
            }
        }
    }
    
    // 是否正在切换一级页面
    property bool isTabAnimating: false
    
    // 主页面路径
    readonly property var mainPages: [
        "qrc:/qt/qml/IHA/qml/pages/HealthPage.qml",
        "qrc:/qt/qml/IHA/qml/pages/AssistantPage.qml",
        "qrc:/qt/qml/IHA/qml/pages/DevicePage.qml",
        "qrc:/qt/qml/IHA/qml/pages/ProfilePage.qml"
    ]
    
    // 保存卡片位置信息（用于返回动画）
    property real savedCardX: 0
    property real savedCardY: 0
    property real savedCardW: 0
    property real savedCardH: 0
    
    // 导航对象
    QtObject {
        id: navigationStack
        
        function pushFromCard(pageUrl, cardX, cardY, cardW, cardH) {
            if (isAnimating) return
            isAnimating = true
            
            pageStack.push(pageUrl)
            
            // 保存卡片位置供返回使用
            savedCardX = cardX
            savedCardY = cardY
            savedCardW = cardW
            savedCardH = cardH
            
            // 计算缩放比例
            var scaleX = Math.max(0.05, cardW / width)
            var scaleY = Math.max(0.05, cardH / height)
            
            // 计算起始位置（卡片左上角相对于屏幕）
            var startX = cardX
            var startY = cardY
            
            // 设置初始状态
            detailContainer.x = startX
            detailContainer.y = startY
            detailScale.origin.x = 0  // 从左上角开始缩放
            detailScale.origin.y = 0
            detailScale.xScale = scaleX
            detailScale.yScale = scaleY
            detailLoader.opacity = 0
            
            // 显示遮罩
            overlayRect.visible = true
            overlayRect.opacity = 0
            
            // 显示容器
            detailContainer.visible = true
            detailContainer.z = 20
            
            // 加载页面
            detailLoader.source = pageUrl
            detailLoader.visible = true
            
            // 隐藏底部导航
            navBar.visible = false
            
            // 启动动画
            pushAnimation.start()
        }
        
        function push(pageUrl) {
            pushFromCard(pageUrl, width / 2, height / 2, width, height)
        }
        
        // 从右边滑入（用于设置页面）
        function pushFromRight(pageUrl) {
            if (isAnimating) return
            isAnimating = true
            
            pageStack.push(pageUrl)
            
            // 设置初始状态：在屏幕右边
            detailContainer.x = width
            detailContainer.y = 0
            detailScale.xScale = 1.0
            detailScale.yScale = 1.0
            detailLoader.opacity = 1
            
            // 显示遮罩
            overlayRect.visible = true
            overlayRect.opacity = 0
            
            // 显示容器
            detailContainer.visible = true
            detailContainer.z = 20
            
            // 加载页面
            detailLoader.source = pageUrl
            detailLoader.visible = true
            
            // 隐藏底部导航
            navBar.visible = false
            
            // 启动滑动动画
            slideInAnimation.start()
        }
        
        // 滑出返回（用于设置页面）
        function popToRight() {
            if (isAnimating) return
            if (pageStack.length > 0) {
                isAnimating = true
                pageStack.pop()
                slideOutAnimation.start()
            }
        }
        
        function pop() {
            if (isAnimating) return
            if (pageStack.length > 0) {
                isAnimating = true
                pageStack.pop()
                popAnimation.start()
            }
        }
        
        function reset() {
            pageStack = []
            detailContainer.visible = false
            detailLoader.visible = false
            detailLoader.source = ""
            overlayRect.visible = false
            mainPageLoader.visible = true
            mainPageLoader.source = mainPages[currentTabIndex]
            navBar.visible = true
        }
        
        // 切换一级页面的方法
        function switchTab(newIndex) {
            if (isTabAnimating || newIndex === currentTabIndex) return
            
            isTabAnimating = true
            previousTabIndex = currentTabIndex
            
            // 判断滑动方向：新索引大于当前索引，向左滑（新页面从右边进来）
            var goingLeft = newIndex > currentTabIndex
            
            // 设置旧页面加载器
            oldPageLoader.source = mainPages[currentTabIndex]
            oldPageLoader.visible = true
            oldPageLoader.x = 0
            
            // 设置新页面加载器
            mainPageLoader.source = mainPages[newIndex]
            mainPageLoader.visible = true
            mainPageLoader.x = goingLeft ? width : -width
            
            // 更新索引
            currentTabIndex = newIndex
            pageStack = []
            
            // 启动动画
            if (goingLeft) {
                slideLeftAnimation.start()
            } else {
                slideRightAnimation.start()
            }
        }
    }
    
    // Push 动画 - 从卡片展开
    ParallelAnimation {
        id: pushAnimation
        
        // X位置动画
        NumberAnimation {
            target: detailContainer
            property: "x"
            to: 0
            duration: 350
            easing.type: Easing.OutQuart
        }
        
        // Y位置动画
        NumberAnimation {
            target: detailContainer
            property: "y"
            to: 0
            duration: 350
            easing.type: Easing.OutQuart
        }
        
        // X缩放动画
        NumberAnimation {
            target: detailScale
            property: "xScale"
            to: 1.0
            duration: 350
            easing.type: Easing.OutQuart
        }
        
        // Y缩放动画
        NumberAnimation {
            target: detailScale
            property: "yScale"
            to: 1.0
            duration: 350
            easing.type: Easing.OutQuart
        }
        
        // 内容淡入
        NumberAnimation {
            target: detailLoader
            property: "opacity"
            to: 1.0
            duration: 200
            easing.type: Easing.OutCubic
        }
        
        // 遮罩淡入后快速淡出
        SequentialAnimation {
            NumberAnimation {
                target: overlayRect
                property: "opacity"
                to: 0.3
                duration: 150
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: overlayRect
                property: "opacity"
                to: 0
                duration: 150
                easing.type: Easing.InQuad
            }
        }
        
        onFinished: {
            detailContainer.x = 0
            detailContainer.y = 0
            detailScale.xScale = 1.0
            detailScale.yScale = 1.0
            overlayRect.visible = false
            isAnimating = false
        }
    }
    
    // Pop 动画 - 收缩回卡片
    ParallelAnimation {
        id: popAnimation
        
        // X位置动画 - 收缩到卡片位置
        NumberAnimation {
            target: detailContainer
            property: "x"
            to: savedCardX
            duration: 300
            easing.type: Easing.InQuart
        }
        
        // Y位置动画
        NumberAnimation {
            target: detailContainer
            property: "y"
            to: savedCardY
            duration: 300
            easing.type: Easing.InQuart
        }
        
        // X缩放动画 - 收缩到卡片大小
        NumberAnimation {
            target: detailScale
            property: "xScale"
            to: Math.max(0.05, savedCardW / width)
            duration: 300
            easing.type: Easing.InQuart
        }
        
        // Y缩放动画
        NumberAnimation {
            target: detailScale
            property: "yScale"
            to: Math.max(0.05, savedCardH / height)
            duration: 300
            easing.type: Easing.InQuart
        }
        
        // 内容淡出
        NumberAnimation {
            target: detailLoader
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.InQuad
        }
        
        // 遮罩淡出
        NumberAnimation {
            target: overlayRect
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.InQuad
        }
        
        onFinished: {
            detailContainer.visible = false
            detailLoader.visible = false
            detailLoader.source = ""
            overlayRect.visible = false
            detailContainer.x = 0
            detailContainer.y = 0
            detailScale.xScale = 1
            detailScale.yScale = 1
            detailLoader.opacity = 1
            isAnimating = false
            navBar.visible = true
        }
    }
    
    // 设置页面滑入动画（从右边滑入）
    ParallelAnimation {
        id: slideInAnimation
        
        NumberAnimation {
            target: detailContainer
            property: "x"
            from: width
            to: 0
            duration: 300
            easing.type: Easing.OutCubic
        }
        
        // 遮罩快速淡入淡出
        SequentialAnimation {
            NumberAnimation {
                target: overlayRect
                property: "opacity"
                to: 0.3
                duration: 100
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: overlayRect
                property: "opacity"
                to: 0
                duration: 150
                easing.type: Easing.InQuad
            }
        }
        
        onFinished: {
            overlayRect.visible = false
            isAnimating = false
        }
    }
    
    // 设置页面滑出动画（向右滑出）
    ParallelAnimation {
        id: slideOutAnimation
        
        NumberAnimation {
            target: detailContainer
            property: "x"
            from: 0
            to: width
            duration: 300
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: overlayRect
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.InQuad
        }
        
        onFinished: {
            detailContainer.visible = false
            detailLoader.visible = false
            detailLoader.source = ""
            overlayRect.visible = false
            detailContainer.x = 0
            isAnimating = false
            navBar.visible = true
        }
    }
    
    // 一级页面向左滑动动画（新页面从右边进来）
    ParallelAnimation {
        id: slideLeftAnimation
        
        NumberAnimation {
            target: oldPageLoader
            property: "x"
            to: -width
            duration: 300
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: mainPageLoader
            property: "x"
            to: 0
            duration: 300
            easing.type: Easing.OutCubic
        }
        
        onFinished: {
            oldPageLoader.visible = false
            oldPageLoader.source = ""
            isTabAnimating = false
        }
    }
    
    // 一级页面向右滑动动画（新页面从左边进来）
    ParallelAnimation {
        id: slideRightAnimation
        
        NumberAnimation {
            target: oldPageLoader
            property: "x"
            to: width
            duration: 300
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: mainPageLoader
            property: "x"
            to: 0
            duration: 300
            easing.type: Easing.OutCubic
        }
        
        onFinished: {
            oldPageLoader.visible = false
            oldPageLoader.source = ""
            isTabAnimating = false
        }
    }
    
    // 主内容区域
    Item {
        id: contentArea
        anchors.fill: parent
        anchors.bottomMargin: navBar.visible ? 56 : 0
        
        // 旧页面加载器（用于动画过渡）
        Loader {
            id: oldPageLoader
            width: parent.width
            height: parent.height
            visible: false
            z: 1
            
            onLoaded: {
                if (item && item.hasOwnProperty('navigationStack')) {
                    item.navigationStack = navigationStack
                }
            }
        }
        
        // 主页面加载器
        Loader {
            id: mainPageLoader
            width: parent.width
            height: parent.height
            visible: true
            source: mainPages[currentTabIndex]
            z: 2
            
            onLoaded: {
                if (item && item.hasOwnProperty('navigationStack')) {
                    item.navigationStack = navigationStack
                }
                // 传递全局消息模型给助理页面
                if (item && item.hasOwnProperty('messageModel')) {
                    item.messageModel = assistantMessageModel
                }
            }
        }
        
        // 遮罩层（在主页面和二级页面之间）
        Rectangle {
            id: overlayRect
            anchors.fill: parent
            color: "#000000"
            opacity: 0
            visible: false
            z: 10  // 在主页面上方，二级页面下方
            
            // 点击遮罩不响应
            MouseArea {
                anchors.fill: parent
                enabled: false
            }
            
            Behavior on opacity {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
        }
        
        // 二级页面容器（在主页面上面）
        Item {
            id: detailContainer
            width: parent.width
            height: parent.height
            visible: false
            clip: true
            z: 20
            
            // 使用 transform 实现缩放
            transform: Scale {
                id: detailScale
                origin.x: 0  // 从左上角缩放
                origin.y: 0
                xScale: 1
                yScale: 1
            }
            
            // 背景色
            Rectangle {
                anchors.fill: parent
                color: darkMode ? "#0D0D0F" : "#F5F5F7"
            }
            
            Loader {
                id: detailLoader
                anchors.fill: parent
                visible: false
                opacity: 1
                asynchronous: false
                source: ""
                
                onLoaded: {
                    if (item && item.hasOwnProperty('navigationStack')) {
                        item.navigationStack = navigationStack
                    }
                }
            }
        }
    }
    
    // 底部导航栏
    Rectangle {
        id: navBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 56
        color: darkMode ? "#121214" : "#F5F5F7"
        visible: true
        z: 5
        
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: darkMode ? "#27272A" : "#E5E5EA"
        }
        
        Row {
            anchors.fill: parent
            
            Repeater {
                model: [
                    { name: "健康", icon: "H" },
                    { name: "助理", icon: "A" },
                    { name: "设备", icon: "D" },
                    { name: "我的", icon: "U" }
                ]
                
                Item {
                    width: navBar.width / 4
                    height: navBar.height
                    
                    Rectangle {
                        id: indicator
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 24
                        height: 3
                        radius: 1.5
                        color: "#FF6B35"
                        visible: index === currentTabIndex
                    }
                    
                    Column {
                        id: navItem
                        anchors.centerIn: parent
                        spacing: 2
                        
                        property real itemScale: navItemMouseArea.pressed ? 0.85 : 1.0
                        
                        transform: Scale {
                            xScale: navItem.itemScale
                            yScale: navItem.itemScale
                            origin.x: navItem.width / 2
                            origin.y: navItem.height / 2
                        }
                        
                        Behavior on itemScale {
                            NumberAnimation { duration: 100 }
                        }
                        
                        Rectangle {
                            id: iconCircle
                            width: 24
                            height: 24
                            radius: 12
                            color: index === currentTabIndex ? "#FF6B35" : "#71717A"
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: modelData.icon
                                font.pixelSize: 12
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }
                        }
                        
                        Text {
                            id: navText
                            text: modelData.name
                            font.pixelSize: 12
                            color: index === currentTabIndex ? "#FF6B35" : "#71717A"
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }
                    
                    MouseArea {
                        id: navItemMouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (index !== currentTabIndex && !isTabAnimating) {
                                navigationStack.switchTab(index)
                            }
                        }
                    }
                }
            }
        }
    }
}