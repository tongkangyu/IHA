import QtQuick

// 动画列表项 - 带进入动画
Item {
    id: root
    
    property alias contentItem: contentLoader.sourceComponent
    property int animationDelay: index * 50  // 级联动画延迟
    
    implicitHeight: 56
    opacity: 0
    scale: 0.95
    
    // 入场动画
    ParallelAnimation {
        running: true
        
        NumberAnimation {
            target: root
            property: "opacity"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.OutQuad
        }
        
        NumberAnimation {
            target: root
            property: "scale"
            from: 0.95
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
        }
    }
    
    // 内容加载器
    Loader {
        id: contentLoader
        anchors.fill: parent
    }
}
