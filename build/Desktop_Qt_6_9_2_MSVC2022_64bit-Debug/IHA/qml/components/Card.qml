import QtQuick
import QtQuick.Controls

// 可点击卡片 - 带动画反馈
Rectangle {
    id: root
    
    // 公开属性
    property alias contentItem: contentLoader.sourceComponent
    property bool clickable: true
    
    // 点击信号
    signal clicked()
    
    implicitHeight: contentLoader.implicitHeight + 32
    radius: 16
    color: mouseArea.pressed ? "#252525" : "#1E1E20"
    
    // 颜色过渡
    Behavior on color {
        ColorAnimation { duration: 100 }
    }
    
    // 缩放效果
    scale: mouseArea.pressed ? 0.98 : 1.0
    transformOrigin: Item.Center
    
    Behavior on scale {
        SpringAnimation {
            spring: 3.0
            damping: 0.5
        }
    }
    
    // 内容加载器
    Loader {
        id: contentLoader
        anchors.fill: parent
        anchors.margins: 16
    }
    
    // 阴影效果（仅当不按下时）
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        visible: !mouseArea.pressed
        
        // 使用边框模拟微妙的阴影
        border.width: 1
        border.color: "#2A2A2C"
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.clickable
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        
        onClicked: root.clicked()
    }
    
    // 波纹效果
    Rectangle {
        id: ripple
        width: 0
        height: width
        radius: width / 2
        color: "#33FFFFFF"
        x: mouseArea.mouseX - width / 2
        y: mouseArea.mouseY - height / 2
        visible: width > 0
        
        SequentialAnimation {
            id: rippleAnimation
            NumberAnimation {
                target: ripple
                property: "width"
                from: 0
                to: Math.max(root.width, root.height) * 1.5
                duration: 300
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: ripple
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
            PropertyAction {
                target: ripple
                property: "width"
                value: 0
            }
        }
        
        Connections {
            target: mouseArea
            function onClicked() {
                ripple.opacity = 1
                rippleAnimation.start()
            }
        }
    }
}
