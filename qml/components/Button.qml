import QtQuick

// 动画按钮
Rectangle {
    id: root
    
    property alias text: buttonText.text
    property color buttonColor: "#FF6B35"
    property color pressedColor: "#E55A2B"
    property color textColor: "#FFFFFF"
    property int textSize: 14
    
    signal clicked()
    
    implicitWidth: buttonText.implicitWidth + 32
    implicitHeight: 40
    radius: height / 2
    
    color: mouseArea.pressed ? pressedColor : buttonColor
    
    Behavior on color {
        ColorAnimation { duration: 100 }
    }
    
    scale: mouseArea.pressed ? 0.95 : 1.0
    
    Behavior on scale {
        SpringAnimation {
            spring: 3.5
            damping: 0.4
        }
    }
    
    Text {
        id: buttonText
        anchors.centerIn: parent
        font.pixelSize: root.textSize
        font.weight: Font.DemiBold
        color: root.textColor
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
    
    // 点击波纹效果
    Rectangle {
        id: ripple
        width: 0
        height: width
        radius: width / 2
        color: "#40FFFFFF"
        x: mouseArea.mouseX - width / 2
        y: mouseArea.mouseY - height / 2
        visible: width > 0
        
        SequentialAnimation {
            id: rippleAnimation
            NumberAnimation {
                target: ripple
                property: "width"
                from: 0
                to: Math.max(root.width, root.height) * 2
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
