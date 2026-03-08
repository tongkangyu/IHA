import QtQuick

// 动画进度条
Rectangle {
    id: root
    
    property real value: 0.0      // 0.0 - 1.0
    property color progressColor: "#FF6B35"
    property color backgroundColor: "#27272A"
    property int animationDuration: 800
    
    implicitHeight: 8
    implicitWidth: 200
    radius: height / 2
    color: backgroundColor
    clip: true
    
    Rectangle {
        id: progressFill
        width: 0
        height: parent.height
        radius: parent.radius
        color: root.progressColor
        
        // 进入动画
        NumberAnimation {
            id: fillAnimation
            target: progressFill
            property: "width"
            from: 0
            to: root.width * root.value
            duration: root.animationDuration
            easing.type: Easing.OutCubic
            running: root.visible
        }
        
        // 闪光效果
        Rectangle {
            width: parent.width * 0.3
            height: parent.height
            radius: parent.radius
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: "#40FFFFFF" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            
            // 从左到右移动的动画
            NumberAnimation on x {
                from: -parent.width * 0.3
                to: parent.width
                duration: 1500
                running: root.visible
                loops: Animation.Infinite
                easing.type: Easing.Linear
            }
        }
    }
    
    // 数值变化时重新动画
    onValueChanged: {
        progressFill.width = root.width * root.value
    }
    
    Component.onCompleted: {
        fillAnimation.start()
    }
}
