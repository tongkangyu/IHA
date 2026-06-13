import QtQuick
import QtQuick.Controls
import Qt.labs.settings

Window {
    id: window

    width: 390
    height: 844
    visible: true
    title: "IHA - 智能健康守护"
    color: darkMode ? "#0D0D0F" : "#F5F5F7"

    property bool darkMode: typeof savedDarkMode !== 'undefined' ? savedDarkMode : true
    property bool isLoggedIn: typeof userService !== 'undefined' ? userService.isLoggedIn : false

    Settings {
        category: "Appearance"
        property alias darkMode: window.darkMode
    }

    property string userName: typeof userService !== 'undefined' && userService.isLoggedIn ? userService.userName : "超懒哥"
    property string userGender: typeof userService !== 'undefined' && userService.isLoggedIn ? userService.userGender : "男"
    property var userBirthday: {
        if (typeof userService !== 'undefined' && userService.isLoggedIn && userService.userBirthday !== "") {
            var parts = userService.userBirthday.split("-")
            return new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]))
        }
        return new Date(2006, 3, 11)
    }
    property int userHeight: typeof userService !== 'undefined' && userService.isLoggedIn ? userService.userHeight : 175
    property int userMaxHeartRate: 200

    readonly property int userAge: {
        var today = new Date()
        var age = today.getFullYear() - userBirthday.getFullYear()
        var m = today.getMonth() - userBirthday.getMonth()
        if (m < 0 || (m === 0 && today.getDate() < userBirthday.getDate())) age--
        return age
    }

    readonly property color themeBgColor: darkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color themeCardColor: darkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color themeTextPrimary: darkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color themeTextSecondary: darkMode ? "#A1A1AA" : "#8E8E93"

    property int currentTabIndex: 0
    property int previousTabIndex: 0
    property var pageStack: []
    property var pageStackTypes: []
    property bool isAnimating: false
    property bool isTabAnimating: false

    readonly property var mainPages: [
        "qrc:/qt/qml/IHA/qml/pages/HealthPage.qml",
        "qrc:/qt/qml/IHA/qml/pages/AssistantPage.qml",
        "qrc:/qt/qml/IHA/qml/pages/DevicePage.qml",
        "qrc:/qt/qml/IHA/qml/pages/ProfilePage.qml"
    ]

    property real savedCardX: 0
    property real savedCardY: 0
    property real savedCardW: 0
    property real savedCardH: 0

    Connections {
        target: typeof userService !== 'undefined' ? userService : null
        function onLoginStatusChanged() {
            window.userName = userService.isLoggedIn ? (userService.userName || "用户") : "用户"
        }
        function onUserInfoChanged() {
            window.userName = userService.userName || "用户"
            window.userGender = userService.userGender || "男"
            if (userService.userBirthday !== "") {
                var parts = userService.userBirthday.split("-")
                window.userBirthday = new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]))
            }
            if (userService.userHeight > 0) window.userHeight = userService.userHeight
        }
        function onLoginSuccess() {
            if (typeof healthDataManager !== 'undefined') {
                healthDataManager.fetchFromBackend(userService.getToken())
            }
        }
    }

    QtObject {
        id: navigationStack

        function pushFromCard(pageUrl, cardX, cardY, cardW, cardH) {
            if (isAnimating) { reset(); return }
            isAnimating = true
            pageStack.push(pageUrl); pageStackTypes.push("card")
            savedCardX = cardX; savedCardY = cardY; savedCardW = cardW; savedCardH = cardH
            var scaleX = Math.max(0.05, cardW / width)
            var scaleY = Math.max(0.05, cardH / height)
            detailContainer.x = cardX; detailContainer.y = cardY
            detailScale.origin.x = 0; detailScale.origin.y = 0
            detailScale.xScale = scaleX; detailScale.yScale = scaleY
            detailLoader.opacity = 0
            overlayRect.visible = true; overlayRect.opacity = 0
            detailContainer.visible = true; detailContainer.z = 20
            loadingIndicator.visible = false
            detailLoader.source = pageUrl; detailLoader.visible = true
            navBar.visible = false
            pushAnimation.start()
        }

        function push(pageUrl) { pushFromCard(pageUrl, width / 2, height / 2, width, height) }

        function pushFromRight(pageUrl) {
            if (isAnimating) { reset(); return }
            isAnimating = true
            pageStack.push(pageUrl); pageStackTypes.push("slide")
            detailContainer.x = width; detailContainer.y = 0
            detailScale.xScale = 1.0; detailScale.yScale = 1.0; detailLoader.opacity = 1
            overlayRect.visible = true; overlayRect.opacity = 0
            detailContainer.visible = true; detailContainer.z = 20
            loadingIndicator.visible = false
            detailLoader.source = pageUrl; detailLoader.visible = true
            navBar.visible = false
            slideInAnimation.start()
        }

        function goBack() {
            if (isAnimating) { reset(); return }
            if (pageStack.length === 0) return
            var type = pageStackTypes.length > 0 ? pageStackTypes[pageStackTypes.length - 1] : "slide"
            pageStack.pop(); pageStackTypes.pop()
            isAnimating = true
            if (type === "card") { popAnimation.start() }
            else { slideOutAnimation.start() }
        }

        function popToRight() {
            if (isAnimating) { reset(); return }
            if (pageStack.length > 0) { isAnimating = true; pageStack.pop(); if (pageStackTypes.length > 0) pageStackTypes.pop(); slideOutAnimation.start() }
        }

        function pop() {
            if (isAnimating) { reset(); return }
            if (pageStack.length > 0) { isAnimating = true; pageStack.pop(); if (pageStackTypes.length > 0) pageStackTypes.pop(); popAnimation.start() }
        }

        function reset() {
            isAnimating = false
            pageStack = []; pageStackTypes = []
            detailContainer.visible = false; detailLoader.visible = false; detailLoader.source = ""
            detailContainer.x = 0; detailContainer.y = 0
            detailScale.xScale = 1.0; detailScale.yScale = 1.0; detailLoader.opacity = 1
            overlayRect.visible = false; overlayRect.opacity = 0
            mainPageLoader.visible = true; mainPageLoader.source = mainPages[currentTabIndex]
            navBar.visible = true
        }

        function switchTab(newIndex) {
            if (isTabAnimating || newIndex === currentTabIndex) return
            isAnimating = false
            pageStack = []; pageStackTypes = []
            detailContainer.visible = false; detailLoader.visible = false; detailLoader.source = ""
            detailContainer.x = 0; detailContainer.y = 0
            detailScale.xScale = 1.0; detailScale.yScale = 1.0; detailLoader.opacity = 1
            overlayRect.visible = false; overlayRect.opacity = 0
            isTabAnimating = true; previousTabIndex = currentTabIndex
            var goingLeft = newIndex > currentTabIndex
            oldPageLoader.source = mainPages[currentTabIndex]; oldPageLoader.visible = true; oldPageLoader.x = 0
            mainPageLoader.source = mainPages[newIndex]; mainPageLoader.visible = true
            mainPageLoader.x = goingLeft ? width : -width
            currentTabIndex = newIndex; pageStack = []; pageStackTypes = []
            goingLeft ? slideLeftAnimation.start() : slideRightAnimation.start()
        }
    }

    ParallelAnimation {
        id: pushAnimation
        NumberAnimation { target: detailContainer; property: "x"; to: 0; duration: 350; easing.type: Easing.OutQuart }
        NumberAnimation { target: detailContainer; property: "y"; to: 0; duration: 350; easing.type: Easing.OutQuart }
        NumberAnimation { target: detailScale; property: "xScale"; to: 1.0; duration: 350; easing.type: Easing.OutQuart }
        NumberAnimation { target: detailScale; property: "yScale"; to: 1.0; duration: 350; easing.type: Easing.OutQuart }
        NumberAnimation { target: detailLoader; property: "opacity"; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
        SequentialAnimation {
            NumberAnimation { target: overlayRect; property: "opacity"; to: 0.3; duration: 150; easing.type: Easing.OutCubic }
            NumberAnimation { target: overlayRect; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InQuad }
        }
        onFinished: { detailContainer.x = 0; detailContainer.y = 0; detailScale.xScale = 1.0; detailScale.yScale = 1.0; overlayRect.visible = false; isAnimating = false }
    }

    ParallelAnimation {
        id: popAnimation
        NumberAnimation { target: detailContainer; property: "x"; to: savedCardX; duration: 300; easing.type: Easing.InQuart }
        NumberAnimation { target: detailContainer; property: "y"; to: savedCardY; duration: 300; easing.type: Easing.InQuart }
        NumberAnimation { target: detailScale; property: "xScale"; to: Math.max(0.05, savedCardW / width); duration: 300; easing.type: Easing.InQuart }
        NumberAnimation { target: detailScale; property: "yScale"; to: Math.max(0.05, savedCardH / height); duration: 300; easing.type: Easing.InQuart }
        NumberAnimation { target: detailLoader; property: "opacity"; to: 0; duration: 200; easing.type: Easing.InQuad }
        NumberAnimation { target: overlayRect; property: "opacity"; to: 0; duration: 200; easing.type: Easing.InQuad }
        onFinished: {
            detailContainer.visible = false; detailLoader.visible = false; detailLoader.source = ""
            overlayRect.visible = false; detailContainer.x = 0; detailContainer.y = 0
            detailScale.xScale = 1; detailScale.yScale = 1; detailLoader.opacity = 1
            isAnimating = false; navBar.visible = true
        }
    }

    ParallelAnimation {
        id: slideInAnimation
        NumberAnimation { target: detailContainer; property: "x"; from: width; to: 0; duration: 300; easing.type: Easing.OutCubic }
        SequentialAnimation {
            NumberAnimation { target: overlayRect; property: "opacity"; to: 0.3; duration: 100; easing.type: Easing.OutCubic }
            NumberAnimation { target: overlayRect; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InQuad }
        }
        onFinished: { overlayRect.visible = false; isAnimating = false }
    }

    ParallelAnimation {
        id: slideOutAnimation
        NumberAnimation { target: detailContainer; property: "x"; from: 0; to: width; duration: 300; easing.type: Easing.OutCubic }
        NumberAnimation { target: overlayRect; property: "opacity"; to: 0; duration: 200; easing.type: Easing.InQuad }
        onFinished: {
            detailContainer.visible = false; detailLoader.visible = false; detailLoader.source = ""
            overlayRect.visible = false; detailContainer.x = 0; isAnimating = false; navBar.visible = true
        }
    }

    ParallelAnimation {
        id: slideLeftAnimation
        NumberAnimation { target: oldPageLoader; property: "x"; to: -width; duration: 300; easing.type: Easing.OutCubic }
        NumberAnimation { target: mainPageLoader; property: "x"; to: 0; duration: 300; easing.type: Easing.OutCubic }
        onFinished: {
            oldPageLoader.visible = false; oldPageLoader.source = ""; isTabAnimating = false
            if (mainPageLoader.item) mainPageLoader.item.navigationStack = navigationStack
        }
    }

    ParallelAnimation {
        id: slideRightAnimation
        NumberAnimation { target: oldPageLoader; property: "x"; to: width; duration: 300; easing.type: Easing.OutCubic }
        NumberAnimation { target: mainPageLoader; property: "x"; to: 0; duration: 300; easing.type: Easing.OutCubic }
        onFinished: {
            oldPageLoader.visible = false; oldPageLoader.source = ""; isTabAnimating = false
            if (mainPageLoader.item) mainPageLoader.item.navigationStack = navigationStack
        }
    }

    Item {
        id: contentArea
        anchors.fill: parent
        anchors.bottomMargin: navBar.visible ? 56 : 0

        Loader {
            id: oldPageLoader
            width: parent.width; height: parent.height; visible: false; z: 1
            onLoaded: { if (item) item.navigationStack = navigationStack }
        }

        Loader {
            id: mainPageLoader
            width: parent.width; height: parent.height
            source: mainPages[currentTabIndex]; z: 2
            onLoaded: {
                if (item) item.navigationStack = navigationStack
            }
            onItemChanged: {
                if (item) item.navigationStack = navigationStack
            }
        }

        Rectangle {
            id: overlayRect
            anchors.fill: parent; color: "#000000"; opacity: 0; visible: false; z: 10
            MouseArea { anchors.fill: parent; enabled: false }
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        }

        Item {
            id: detailContainer
            width: parent.width; height: parent.height; visible: false; clip: true; z: 20
            transform: Scale { id: detailScale; origin.x: 0; origin.y: 0; xScale: 1; yScale: 1 }
            Rectangle { anchors.fill: parent; color: darkMode ? "#0D0D0F" : "#F5F5F7" }
            Loader {
                id: detailLoader
                anchors.fill: parent; visible: false; opacity: 1; asynchronous: false; source: ""
                onLoaded: {
                    if (item) item.navigationStack = navigationStack
                    loadingIndicator.visible = false
                }
            }

            BusyIndicator {
                id: loadingIndicator
                anchors.centerIn: parent
                visible: false
                running: visible
            }
        }
    }

    Rectangle {
        id: navBar
        anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
        height: 56; color: darkMode ? "#121214" : "#F5F5F7"; visible: true; z: 5

        Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: darkMode ? "#27272A" : "#E5E5EA" }

        Row {
            anchors.fill: parent
            Repeater {
                model: [ { name: "健康", icon: "H" }, { name: "助理", icon: "A" }, { name: "设备", icon: "D" }, { name: "我的", icon: "U" } ]
                delegate: Item {
                    width: navBar.width / 4; height: navBar.height
                    Rectangle {
                        id: indicator
                        anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
                        width: 24; height: 3; radius: 1.5; color: "#FF6B35"
                        visible: index === currentTabIndex
                    }
                    Column {
                        id: navItem
                        anchors.centerIn: parent; spacing: 2
                        property real itemScale: navItemMouseArea.pressed ? 0.85 : 1.0
                        transform: Scale { xScale: navItem.itemScale; yScale: navItem.itemScale; origin.x: navItem.width / 2; origin.y: navItem.height / 2 }
                        Behavior on itemScale { NumberAnimation { duration: 100 } }
                        Rectangle {
                            width: 24; height: 24; radius: 12
                            color: index === currentTabIndex ? "#FF6B35" : "#71717A"
                            anchors.horizontalCenter: parent.horizontalCenter
                            Behavior on color { ColorAnimation { duration: 200 } }
                            Text { anchors.centerIn: parent; text: modelData.icon; font.pixelSize: 12; font.weight: Font.Bold; color: "#FFFFFF" }
                        }
                        Text {
                            text: modelData.name; font.pixelSize: 12
                            color: index === currentTabIndex ? "#FF6B35" : "#71717A"
                            anchors.horizontalCenter: parent.horizontalCenter
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                    MouseArea {
                        id: navItemMouseArea; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: { if (index !== currentTabIndex && !isTabAnimating) navigationStack.switchTab(index) }
                    }
                }
            }
        }
    }
}
