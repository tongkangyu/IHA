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
    
    // 是否正在切换一级页面
    property bool isTabAnimating: false
    
    // 主页面路径
    readonly property var mainPages: [
        "qrc:/qt/qml/IHA/qml/pages/HealthPage.qml",
        "qrc:/qt/qml/IHA/qml/pages/AssistantPage.qml",
        "qrc:/qt/qml/IHA/qml/pages/DevicePage.qml",
        "qrc:/qt/qml/IHA/qml/pages/ProfilePage.qml"
    ]
    
    // 导航对象
    QtObject {
        id: navigationStack
        
        function pushFromCard(pageUrl, cardX, cardY, cardW, cardH) {
            if (isAnimating) return
            isAnimating = true
            
            pageStack.push(pageUrl)
            
            // 计算缩放比例
            var scaleX = Math.max(0.1, cardW / width)
            var scaleY = Math.max(0.1, cardH / height)
            
            // 计算起始位置（卡片中心相对于屏幕中心）
            var startX = cardX + cardW / 2 - width / 2
            var startY = cardY + cardH / 2 - height / 2
            
            // 保存动画参数供返回动画使用
            popAnimation.targetX = startX
            popAnimation.targetY = startY
            popAnimation.targetScaleX = scaleX
            popAnimation.targetScaleY = scaleY
            
            // 设置初始状态
            detailContainer.x = startX
            detailContainer.y = startY
            detailScale.xScale = scaleX
            detailScale.yScale = scaleY
            detailLoader.opacity = 0
            
            // 显示容器
            detailContainer.visible = true
            mainPageLoader.visible = false
            navBar.visible = false
            
            // 加载页面
            detailLoader.source = pageUrl
            detailLoader.visible = true
            
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
            
            // 显示容器
            detailContainer.visible = true
            mainPageLoader.visible = false
            navBar.visible = false
            
            // 加载页面
            detailLoader.source = pageUrl
            detailLoader.visible = true
            
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
    
    // Push 动画 - 流畅的物理感动画
    ParallelAnimation {
        id: pushAnimation
        
        NumberAnimation {
            target: detailContainer
            property: "x"
            to: 0
            duration: 320
            easing.type: Easing.OutBack
            easing.overshoot: 0.5
        }
        
        NumberAnimation {
            target: detailContainer
            property: "y"
            to: 0
            duration: 320
            easing.type: Easing.OutBack
            easing.overshoot: 0.5
        }
        
        NumberAnimation {
            target: detailScale
            property: "xScale"
            to: 1.0
            duration: 320
            easing.type: Easing.OutBack
            easing.overshoot: 0.5
        }
        
        NumberAnimation {
            target: detailScale
            property: "yScale"
            to: 1.0
            duration: 320
            easing.type: Easing.OutBack
            easing.overshoot: 0.5
        }
        
        NumberAnimation {
            target: detailLoader
            property: "opacity"
            to: 1.0
            duration: 250
            easing.type: Easing.OutCubic
        }
        
        onFinished: {
            detailContainer.x = 0
            detailContainer.y = 0
            detailScale.xScale = 1.0
            detailScale.yScale = 1.0
            isAnimating = false
            navBar.visible = false
        }
    }
    
    // Pop 动画 - 流畅的物理感动画
    ParallelAnimation {
        id: popAnimation
        
        property real targetX: 0
        property real targetY: 0
        property real targetScaleX: 0.3
        property real targetScaleY: 0.3
        
        NumberAnimation {
            target: detailContainer
            property: "x"
            to: popAnimation.targetX
            duration: 280
            easing.type: Easing.InBack
            easing.overshoot: 0.3
        }
        
        NumberAnimation {
            target: detailContainer
            property: "y"
            to: popAnimation.targetY
            duration: 280
            easing.type: Easing.InBack
            easing.overshoot: 0.3
        }
        
        NumberAnimation {
            target: detailScale
            property: "xScale"
            to: popAnimation.targetScaleX
            duration: 280
            easing.type: Easing.InBack
            easing.overshoot: 0.3
        }
        
        NumberAnimation {
            target: detailScale
            property: "yScale"
            to: popAnimation.targetScaleY
            duration: 280
            easing.type: Easing.InBack
            easing.overshoot: 0.3
        }
        
        NumberAnimation {
            target: detailLoader
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.InQuad
        }
        
        onStarted: {
            mainPageLoader.visible = true
        }
        
        onFinished: {
            detailContainer.visible = false
            detailLoader.visible = false
            detailLoader.source = ""
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
    NumberAnimation {
        id: slideInAnimation
        target: detailContainer
        property: "x"
        from: width
        to: 0
        duration: 300
        easing.type: Easing.OutCubic
        
        onFinished: {
            isAnimating = false
        }
    }
    
    // 设置页面滑出动画（向右滑出）
    NumberAnimation {
        id: slideOutAnimation
        target: detailContainer
        property: "x"
        from: 0
        to: width
        duration: 300
        easing.type: Easing.OutCubic
        
        onStarted: {
            mainPageLoader.visible = true
            navBar.visible = true
        }
        
        onFinished: {
            detailContainer.visible = false
            detailLoader.visible = false
            detailLoader.source = ""
            detailContainer.x = 0
            isAnimating = false
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
            }
        }
        
        // 二级页面容器（在主页面上面）
        Item {
            id: detailContainer
            width: parent.width
            height: parent.height
            visible: false  // 直接控制，不绑定
            clip: true
            z: 10  // 确保在主页面上方
            
            // 使用 transform 实现缩放，以容器中心为原点
            transform: Scale {
                id: detailScale
                origin.x: detailContainer.width / 2
                origin.y: detailContainer.height / 2
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
        color: darkMode ? "#CC121214" : "#EFFFF5F7"
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
