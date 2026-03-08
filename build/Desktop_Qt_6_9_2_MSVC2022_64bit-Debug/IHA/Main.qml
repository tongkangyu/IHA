import QtQuick
import QtQuick.Controls

Window {
    id: window
    
    width: 390
    height: 844
    visible: true
    title: "IHA - 智能健康助理"
    color: "#0D0D0F"
    
    // 当前主页面索引
    property int currentTabIndex: 0
    
    // 页面栈
    property var pageStack: []
    
    // 是否正在动画中
    property bool isAnimating: false
    
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
            pageLoader.visible = false
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
            pageLoader.visible = true
            pageLoader.source = mainPages[currentTabIndex]
            navBar.visible = true
        }
    }
    
    // Push 动画
    ParallelAnimation {
        id: pushAnimation
        
        NumberAnimation {
            target: detailContainer
            property: "x"
            to: 0
            duration: 400
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: detailContainer
            property: "y"
            to: 0
            duration: 400
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: detailScale
            property: "xScale"
            to: 1.0
            duration: 400
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: detailScale
            property: "yScale"
            to: 1.0
            duration: 400
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: detailLoader
            property: "opacity"
            to: 1.0
            duration: 300
            easing.type: Easing.OutQuad
        }
        
        onStarted: {
            // 确保动画开始时状态正确
        }
        
        onFinished: {
            isAnimating = false
            navBar.visible = false
        }
    }
    
    // Pop 动画
    ParallelAnimation {
        id: popAnimation
        
        // 卡片动画参数（在 pushFromCard 中设置）
        property real targetX: 0
        property real targetY: 0
        property real targetScaleX: 0.3
        property real targetScaleY: 0.3
        
        NumberAnimation {
            target: detailContainer
            property: "x"
            to: popAnimation.targetX
            duration: 350
            easing.type: Easing.InCubic
        }
        
        NumberAnimation {
            target: detailContainer
            property: "y"
            to: popAnimation.targetY
            duration: 350
            easing.type: Easing.InCubic
        }
        
        NumberAnimation {
            target: detailScale
            property: "xScale"
            to: popAnimation.targetScaleX
            duration: 350
            easing.type: Easing.InCubic
        }
        
        NumberAnimation {
            target: detailScale
            property: "yScale"
            to: popAnimation.targetScaleY
            duration: 350
            easing.type: Easing.InCubic
        }
        
        NumberAnimation {
            target: detailLoader
            property: "opacity"
            to: 0
            duration: 250
            easing.type: Easing.InQuad
        }
        
        onStarted: {
            // 显示主页面（在动画后面）
            pageLoader.visible = true
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
    
    // 主内容区域
    Item {
        id: contentArea
        anchors.fill: parent
        anchors.bottomMargin: navBar.visible ? 56 : 0
        
        // 主页面加载器
        Loader {
            id: pageLoader
            anchors.fill: parent
            visible: true
            source: mainPages[currentTabIndex]
            
            onLoaded: {
                if (item && item.hasOwnProperty('navigationStack')) {
                    item.navigationStack = navigationStack
                }
            }
        }
        
        // 二级页面容器（在主页面上面）
        Item {
            id: detailContainer
            anchors.fill: parent
            visible: false  // 直接控制，不绑定
            clip: true
            z: 10  // 确保在主页面上方
            
            transform: Scale {
                id: detailScale
                origin.x: width / 2
                origin.y: height / 2
                xScale: 1
                yScale: 1
            }
            
            // 背景色
            Rectangle {
                anchors.fill: parent
                color: "#0D0D0F"
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
        color: "#CC121214"
        visible: true
        z: 5
        
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: "#27272A"
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
                            if (index !== currentTabIndex) {
                                currentTabIndex = index
                                pageStack = []
                                pageLoader.visible = true
                                pageLoader.source = mainPages[index]
                                navBar.visible = true
                            }
                        }
                    }
                }
            }
        }
    }
}
