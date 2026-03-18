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
        width: root.width * root.value
        height: parent.height
        radius: parent.radius
        color: root.progressColor
        
        Behavior on width {
            NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic }
        }
    }
}