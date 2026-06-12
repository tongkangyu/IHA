import QtQuick
import QtQuick.Controls

Rectangle {
    id: profileInfoPage
    
    property var navigationStack: null
    
    readonly property bool isDarkMode: typeof window !== 'undefined' ? window.darkMode : true
    readonly property color bgColor: isDarkMode ? "#0D0D0F" : "#F5F5F7"
    readonly property color cardColor: isDarkMode ? "#1E1E20" : "#FFFFFF"
    readonly property color textPrimary: isDarkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color textSecondary: isDarkMode ? "#A1A1AA" : "#757575"
    readonly property color accentColor: "#007AFF"
    readonly property color accentBgColor: isDarkMode ? "#1A3A5C" : "#E8F4FF"
    
    // 弹窗状态
    property string currentField: ""
    property bool modalVisible: false
    
    // 本地存储值（用于界面显示）
    property string localGender: "男"
    property int localHeight: 175
    property int localHeartRate: 200
    property var localBirthday: null
    
    // 临时值（用于弹窗编辑）
    property string tempGender: "男"
    property int tempHeight: 175
    property int tempHeartRate: 200
    property int tempYear: 2006
    property int tempMonth: 4
    property int tempDay: 11
    
    color: bgColor
    
    Component.onCompleted: {
        // 从 window 读取初始值
        if (typeof window !== 'undefined') {
            localGender = window.userGender || "男"
            localHeight = window.userHeight || 175
            localHeartRate = window.userMaxHeartRate || 200
            localBirthday = window.userBirthday || null
        }
    }
    
    // 格式化生日
    function formatBirthday(date) {
        if (!date) return "2006年4月11日"
        return date.getFullYear() + "年" + (date.getMonth() + 1) + "月" + date.getDate() + "日"
    }
    
    // 获取当前值
    function getCurrentValue(field) {
        if (field === "gender") return localGender
        if (field === "height") return localHeight
        if (field === "heartRate") return localHeartRate
        if (field === "birthday") return formatBirthday(localBirthday)
        return ""
    }
    
    // 遮罩层
    Rectangle {
        anchors.fill: parent
        color: "#4D000000"
        visible: modalVisible
        z: 100
        
        MouseArea {
            anchors.fill: parent
            onClicked: modalVisible = false
        }
    }
    
    // 底部弹窗
    Rectangle {
        id: bottomModal
        width: parent.width - 24
        height: {
            if (currentField === "gender") return 320
            if (currentField === "birthday") return 420
            return 400
        }
        radius: 20
        color: cardColor
        z: 101
        anchors.horizontalCenter: parent.horizontalCenter
        
        y: modalVisible ? parent.height - height - 16 : parent.height
        Behavior on y {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }
        
        visible: y < parent.height
        
        Column {
            anchors.fill: parent
            anchors.topMargin: 24
            anchors.bottomMargin: 24
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 0
            
            // 标题
            Text {
                text: {
                    if (currentField === "gender") return "性别"
                    if (currentField === "height") return "身高"
                    if (currentField === "heartRate") return "最大心率"
                    if (currentField === "birthday") return "生日"
                    return ""
                }
                font.pixelSize: 20
                font.weight: Font.Bold
                color: textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Item { width: 1; height: 24 }
            
            // ===== 性别选择 =====
            Column {
                width: parent.width
                spacing: 8
                visible: currentField === "gender"
                
                Repeater {
                    model: ["男", "女"]
                    
                    Rectangle {
                        width: parent.width
                        height: 52
                        radius: 12
                        color: tempGender === modelData ? accentBgColor : (isDarkMode ? "#2A2A2C" : "#F5F5F5")
                        
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData
                            font.pixelSize: 16
                            color: tempGender === modelData ? accentColor : textPrimary
                        }
                        
                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            text: "✓"
                            font.pixelSize: 18
                            font.weight: Font.Bold
                            color: accentColor
                            visible: tempGender === modelData
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: tempGender = modelData
                        }
                    }
                }
                
                Item { width: 1; height: 20 }
                
                Row {
                    width: parent.width
                    spacing: 12
                    
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 48
                        radius: 24
                        color: isDarkMode ? "#2A2A2C" : "#F5F5F5"
                        
                        Text { anchors.centerIn: parent; text: "取消"; font.pixelSize: 16; color: textPrimary }
                        MouseArea { anchors.fill: parent; onClicked: modalVisible = false }
                    }
                    
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 48
                        radius: 24
                        color: accentColor
                        
                        Text { anchors.centerIn: parent; text: "确定"; font.pixelSize: 16; color: "#FFFFFF" }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                localGender = tempGender
                                if (typeof window !== 'undefined') window.userGender = tempGender
                                modalVisible = false
                            }
                        }
                    }
                }
            }
            
            // ===== 身高选择（滚轮） =====
            Column {
                width: parent.width
                spacing: 16
                visible: currentField === "height"
                
                Item {
                    width: parent.width
                    height: 180
                    
                    Row {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        // 身高滚轮容器
                        Item {
                            width: 100
                            height: 180
                            
                            // 选中行高亮
                            Rectangle {
                                anchors.centerIn: parent
                                width: 100
                                height: 44
                                color: accentBgColor
                                radius: 8
                                z: 0
                            }
                            
                            // 身高滚轮
                            Tumbler {
                                id: heightTumbler
                                anchors.fill: parent
                                model: 151  // 100-250
                                visibleItemCount: 5
                                wrap: false
                                z: 1
                                
                                delegate: Text {
                                    text: (100 + index).toString()
                                    font.pixelSize: heightTumbler.currentIndex === index ? 32 : 20
                                    font.weight: heightTumbler.currentIndex === index ? Font.Bold : Font.Normal
                                    color: heightTumbler.currentIndex === index ? accentColor : (isDarkMode ? "#5A5A5A" : "#C0C0C0")
                                    opacity: 1.0 - Math.abs(heightTumbler.currentIndex - index) * 0.3
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                Component.onCompleted: currentIndex = tempHeight - 100
                                onCurrentIndexChanged: tempHeight = 100 + currentIndex
                            }
                        }
                        
                        // 单位
                        Text {
                            text: "厘米"
                            font.pixelSize: 16
                            color: accentColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                
                Item { width: 1; height: 12 }
                
                Row {
                    width: parent.width
                    spacing: 12
                    
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 48
                        radius: 24
                        color: isDarkMode ? "#2A2A2C" : "#F5F5F5"
                        
                        Text { anchors.centerIn: parent; text: "取消"; font.pixelSize: 16; color: textPrimary }
                        MouseArea { anchors.fill: parent; onClicked: modalVisible = false }
                    }
                    
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 48
                        radius: 24
                        color: accentColor
                        
                        Text { anchors.centerIn: parent; text: "确定"; font.pixelSize: 16; color: "#FFFFFF" }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                localHeight = tempHeight
                                if (typeof window !== 'undefined') window.userHeight = tempHeight
                                modalVisible = false
                            }
                        }
                    }
                }
            }
            
            // ===== 最大心率选择（滚轮） =====
            Column {
                width: parent.width
                spacing: 16
                visible: currentField === "heartRate"
                
                Item {
                    width: parent.width
                    height: 180
                    
                    Row {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        // 心率滚轮容器
                        Item {
                            width: 100
                            height: 180
                            
                            Rectangle {
                                anchors.centerIn: parent
                                width: 100
                                height: 44
                                color: accentBgColor
                                radius: 8
                                z: 0
                            }
                            
                            Tumbler {
                                id: heartRateTumbler
                                anchors.fill: parent
                                model: 101  // 120-220
                                visibleItemCount: 5
                                wrap: false
                                z: 1
                                
                                delegate: Text {
                                    text: (120 + index).toString()
                                    font.pixelSize: heartRateTumbler.currentIndex === index ? 32 : 20
                                    font.weight: heartRateTumbler.currentIndex === index ? Font.Bold : Font.Normal
                                    color: heartRateTumbler.currentIndex === index ? accentColor : (isDarkMode ? "#5A5A5A" : "#C0C0C0")
                                    opacity: 1.0 - Math.abs(heartRateTumbler.currentIndex - index) * 0.3
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                Component.onCompleted: currentIndex = tempHeartRate - 120
                                onCurrentIndexChanged: tempHeartRate = 120 + currentIndex
                            }
                        }
                        
                        Text {
                            text: "次/分"
                            font.pixelSize: 16
                            color: accentColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                
                Item { width: 1; height: 12 }
                
                Row {
                    width: parent.width
                    spacing: 12
                    
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 48
                        radius: 24
                        color: isDarkMode ? "#2A2A2C" : "#F5F5F5"
                        
                        Text { anchors.centerIn: parent; text: "取消"; font.pixelSize: 16; color: textPrimary }
                        MouseArea { anchors.fill: parent; onClicked: modalVisible = false }
                    }
                    
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 48
                        radius: 24
                        color: accentColor
                        
                        Text { anchors.centerIn: parent; text: "确定"; font.pixelSize: 16; color: "#FFFFFF" }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                localHeartRate = tempHeartRate
                                if (typeof window !== 'undefined') window.userMaxHeartRate = tempHeartRate
                                modalVisible = false
                            }
                        }
                    }
                }
            }
            
            // ===== 生日选择（三列滚轮） =====
            Column {
                width: parent.width
                spacing: 16
                visible: currentField === "birthday"
                
                Item {
                    width: parent.width
                    height: 200
                    
                    Row {
                        anchors.centerIn: parent
                        spacing: 12
                        
                        // 年份滚轮
                        Item {
                            width: 80
                            height: 180
                            
                            Rectangle {
                                anchors.centerIn: parent
                                width: 80
                                height: 40
                                color: accentBgColor
                                radius: 8
                                z: 0
                            }
                            
                            Tumbler {
                                id: yearTumbler
                                anchors.fill: parent
                                model: 71  // 1950-2020
                                visibleItemCount: 5
                                wrap: false
                                z: 1
                                
                                delegate: Text {
                                    text: (1950 + index).toString()
                                    font.pixelSize: yearTumbler.currentIndex === index ? 28 : 18
                                    font.weight: yearTumbler.currentIndex === index ? Font.Bold : Font.Normal
                                    color: yearTumbler.currentIndex === index ? accentColor : (isDarkMode ? "#5A5A5A" : "#C0C0C0")
                                    opacity: 1.0 - Math.abs(yearTumbler.currentIndex - index) * 0.3
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                Component.onCompleted: currentIndex = tempYear - 1950
                                onCurrentIndexChanged: tempYear = 1950 + currentIndex
                            }
                        }
                        
                        Text {
                            text: "年"
                            font.pixelSize: 16
                            color: accentColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        // 月份滚轮
                        Item {
                            width: 60
                            height: 180
                            
                            Rectangle {
                                anchors.centerIn: parent
                                width: 60
                                height: 40
                                color: accentBgColor
                                radius: 8
                                z: 0
                            }
                            
                            Tumbler {
                                id: monthTumbler
                                anchors.fill: parent
                                model: 12
                                visibleItemCount: 5
                                wrap: false
                                z: 1
                                
                                delegate: Text {
                                    text: (index + 1).toString().padStart(2, '0')
                                    font.pixelSize: monthTumbler.currentIndex === index ? 28 : 18
                                    font.weight: monthTumbler.currentIndex === index ? Font.Bold : Font.Normal
                                    color: monthTumbler.currentIndex === index ? accentColor : (isDarkMode ? "#5A5A5A" : "#C0C0C0")
                                    opacity: 1.0 - Math.abs(monthTumbler.currentIndex - index) * 0.3
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                Component.onCompleted: currentIndex = tempMonth - 1
                                onCurrentIndexChanged: tempMonth = currentIndex + 1
                            }
                        }
                        
                        Text {
                            text: "月"
                            font.pixelSize: 16
                            color: accentColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        // 日期滚轮
                        Item {
                            width: 60
                            height: 180
                            
                            Rectangle {
                                anchors.centerIn: parent
                                width: 60
                                height: 40
                                color: accentBgColor
                                radius: 8
                                z: 0
                            }
                            
                            Tumbler {
                                id: dayTumbler
                                anchors.fill: parent
                                model: 31
                                visibleItemCount: 5
                                wrap: false
                                z: 1
                                
                                delegate: Text {
                                    text: (index + 1).toString().padStart(2, '0')
                                    font.pixelSize: dayTumbler.currentIndex === index ? 28 : 18
                                    font.weight: dayTumbler.currentIndex === index ? Font.Bold : Font.Normal
                                    color: dayTumbler.currentIndex === index ? accentColor : (isDarkMode ? "#5A5A5A" : "#C0C0C0")
                                    opacity: 1.0 - Math.abs(dayTumbler.currentIndex - index) * 0.3
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                Component.onCompleted: currentIndex = tempDay - 1
                                onCurrentIndexChanged: tempDay = currentIndex + 1
                            }
                        }
                        
                        Text {
                            text: "日"
                            font.pixelSize: 16
                            color: accentColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                
                Item { width: 1; height: 12 }
                
                Row {
                    width: parent.width
                    spacing: 12
                    
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 48
                        radius: 24
                        color: isDarkMode ? "#2A2A2C" : "#F5F5F5"
                        
                        Text { anchors.centerIn: parent; text: "取消"; font.pixelSize: 16; color: textPrimary }
                        MouseArea { anchors.fill: parent; onClicked: modalVisible = false }
                    }
                    
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 48
                        radius: 24
                        color: accentColor
                        
                        Text { anchors.centerIn: parent; text: "确定"; font.pixelSize: 16; color: "#FFFFFF" }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                localBirthday = new Date(tempYear, tempMonth - 1, tempDay)
                                if (typeof window !== 'undefined') window.userBirthday = localBirthday
                                modalVisible = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    function openModal(field) {
        currentField = field
        if (field === "gender") tempGender = localGender
        if (field === "height") tempHeight = localHeight
        if (field === "heartRate") tempHeartRate = localHeartRate
        if (field === "birthday") {
            var bday = localBirthday
            if (bday) {
                tempYear = bday.getFullYear()
                tempMonth = bday.getMonth() + 1
                tempDay = bday.getDate()
            }
        }
        modalVisible = true
    }
    
    // 标题栏
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 56
        color: isDarkMode ? "#121214" : "#FFFFFF"
        z: 10
        
        Rectangle {
            x: 8
            y: 10
            width: 36
            height: 36
            radius: 18
            color: backArea.pressed ? (isDarkMode ? "#2A2A2C" : "#E5E5EA") : "transparent"
            
            Text { anchors.centerIn: parent; text: "‹"; font.pixelSize: 28; color: textPrimary }
            
            MouseArea {
                id: backArea
                anchors.fill: parent
                onClicked: { if (navigationStack) navigationStack.goBack() }
            }
        }
        
        Text { anchors.centerIn: parent; text: "个人信息"; font.pixelSize: 20; font.weight: Font.Bold; color: textPrimary }
    }
    
    // 用户卡片
    Rectangle {
        id: userCard
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        height: 80
        radius: 16
        color: cardColor
        
        Row {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14
            
            Rectangle {
                width: 50; height: 50; radius: 25; color: "#7D5FFF"
                anchors.verticalCenter: parent.verticalCenter
                Text { anchors.centerIn: parent; text: "👤"; font.pixelSize: 24 }
            }
            
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4
                
                Text { text: typeof window !== 'undefined' ? (window.userName || "超懒哥") : "超懒哥"; font.pixelSize: 17; font.weight: Font.Bold; color: textPrimary }
                Text { text: (typeof window !== 'undefined' ? (window.userAge || 19) : 19) + "岁"; font.pixelSize: 14; color: textSecondary }
            }
        }
    }
    
    // 属性列表
    Rectangle {
        id: attrList
        anchors.top: userCard.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        height: col.height
        radius: 16
        color: cardColor
        
        Column {
            id: col
            width: parent.width
            
            // 性别
            Rectangle {
                width: parent.width; height: 52
                color: genderArea.pressed ? (isDarkMode ? "#2A2A2C" : "#F0F0F0") : "transparent"
                
                Text { anchors.left: parent.left; anchors.leftMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "性别"; font.pixelSize: 16; color: textPrimary }
                
                Row {
                    anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; spacing: 4
                    Text { text: getCurrentValue("gender"); font.pixelSize: 15; color: textSecondary }
                    Text { text: "›"; font.pixelSize: 18; color: textSecondary }
                }
                
                MouseArea { id: genderArea; anchors.fill: parent; onClicked: openModal("gender") }
            }
            
            Rectangle { width: parent.width - 32; height: 1; color: isDarkMode ? "#27272A" : "#E5E5EA"; anchors.horizontalCenter: parent.horizontalCenter }
            
            // 生日
            Rectangle {
                width: parent.width; height: 52
                color: birthdayArea.pressed ? (isDarkMode ? "#2A2A2C" : "#F0F0F0") : "transparent"
                
                Text { anchors.left: parent.left; anchors.leftMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "生日"; font.pixelSize: 16; color: textPrimary }
                
                Row {
                    anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; spacing: 4
                    Text { text: getCurrentValue("birthday"); font.pixelSize: 15; color: textSecondary }
                    Text { text: "›"; font.pixelSize: 18; color: textSecondary }
                }
                
                MouseArea { id: birthdayArea; anchors.fill: parent; onClicked: openModal("birthday") }
            }
            
            Rectangle { width: parent.width - 32; height: 1; color: isDarkMode ? "#27272A" : "#E5E5EA"; anchors.horizontalCenter: parent.horizontalCenter }
            
            // 身高
            Rectangle {
                width: parent.width; height: 52
                color: heightArea.pressed ? (isDarkMode ? "#2A2A2C" : "#F0F0F0") : "transparent"
                
                Text { anchors.left: parent.left; anchors.leftMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "身高"; font.pixelSize: 16; color: textPrimary }
                
                Row {
                    anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; spacing: 4
                    Text { text: getCurrentValue("height") + "厘米"; font.pixelSize: 15; color: textSecondary }
                    Text { text: "›"; font.pixelSize: 18; color: textSecondary }
                }
                
                MouseArea { id: heightArea; anchors.fill: parent; onClicked: openModal("height") }
            }
            
            Rectangle { width: parent.width - 32; height: 1; color: isDarkMode ? "#27272A" : "#E5E5EA"; anchors.horizontalCenter: parent.horizontalCenter }
            
            // 最大心率
            Rectangle {
                width: parent.width; height: 52
                color: heartRateArea.pressed ? (isDarkMode ? "#2A2A2C" : "#F0F0F0") : "transparent"
                
                Text { anchors.left: parent.left; anchors.leftMargin: 16; anchors.verticalCenter: parent.verticalCenter; text: "最大心率"; font.pixelSize: 16; color: textPrimary }
                
                Row {
                    anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter; spacing: 4
                    Text { text: getCurrentValue("heartRate") + "次/分"; font.pixelSize: 15; color: textSecondary }
                    Text { text: "›"; font.pixelSize: 18; color: textSecondary }
                }
                
                MouseArea { id: heartRateArea; anchors.fill: parent; onClicked: openModal("heartRate") }
            }
        }
    }
}