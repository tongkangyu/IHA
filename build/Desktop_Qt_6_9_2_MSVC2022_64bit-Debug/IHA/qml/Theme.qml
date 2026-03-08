import QtQuick

QtObject {
    id: theme
    
    // ========== 颜色系统 ==========
    readonly property QtObject colors: QtObject {
        // 主色调 - 小米橙
        readonly property color primary: "#FF6B35"
        readonly property color primaryLight: "#FF8F66"
        readonly property color primaryDark: "#E55A2B"
        
        // 背景色 - 深色模式
        readonly property color background: "#0D0D0F"
        readonly property color backgroundSecondary: "#121214"
        readonly property color backgroundTertiary: "#1E1E20"
        readonly property color backgroundCard: "#1E1E20"
        readonly property color backgroundElevated: "#2A2A2C"
        
        // 文字色
        readonly property color textPrimary: "#FFFFFF"
        readonly property color textSecondary: "#A1A1AA"
        readonly property color textTertiary: "#71717A"
        readonly property color textDisabled: "#52525B"
        
        // 语义色
        readonly property color success: "#22C55E"
        readonly property color warning: "#F59E0B"
        readonly property color error: "#EF4444"
        readonly property color info: "#3B82F6"
        
        // 健康模块专用色
        readonly property color healthCalories: "#FF6B35"
        readonly property color healthSteps: "#FBBF24"
        readonly property color healthActivity: "#22C55E"
        readonly property color healthSleep: "#7D5FFF"
        readonly property color healthHeart: "#EF4444"
        readonly property color healthOxygen: "#3B82F6"
        
        // 分隔线
        readonly property color divider: "#27272A"
        readonly property color border: "#3F3F46"
    }
    
    // ========== 字体系统 ==========
    readonly property QtObject fonts: QtObject {
        readonly property string family: "Microsoft YaHei, sans-serif"
        readonly property string familyMono: "Consolas, monospace"
        
        readonly property int sizeCaption: 12
        readonly property int sizeBody: 14
        readonly property int sizeSubhead: 16
        readonly property int sizeTitle: 20
        readonly property int sizeHeadline: 24
        readonly property int sizeDisplay: 32
        readonly property int sizeHero: 48
        
        readonly property int weightLight: Font.Light
        readonly property int weightRegular: Font.Normal
        readonly property int weightMedium: Font.Medium
        readonly property int weightSemibold: Font.DemiBold
        readonly property int weightBold: Font.Bold
    }
    
    // ========== 间距系统 ==========
    readonly property QtObject spacing: QtObject {
        readonly property int none: 0
        readonly property int xxs: 4
        readonly property int xs: 8
        readonly property int sm: 12
        readonly property int md: 16
        readonly property int lg: 24
        readonly property int xl: 32
        readonly property int xxl: 48
    }
    
    // ========== 圆角系统 ==========
    readonly property QtObject radius: QtObject {
        readonly property int none: 0
        readonly property int sm: 4
        readonly property int md: 8
        readonly property int lg: 12
        readonly property int xl: 16
        readonly property int xxl: 24
        readonly property int full: 9999
    }
    
    // ========== 动画系统 ==========
    readonly property QtObject animation: QtObject {
        readonly property int durationFast: 150
        readonly property int durationNormal: 250
        readonly property int durationSlow: 400
        readonly property int durationPage: 350
        
        readonly property int easingOutQuad: Easing.OutQuad
        readonly property int easingOutCubic: Easing.OutCubic
        readonly property int easingInOutQuad: Easing.InOutQuad
    }
    
    // ========== 尺寸系统 ==========
    readonly property QtObject sizes: QtObject {
        readonly property int iconSm: 20
        readonly property int iconMd: 24
        readonly property int iconLg: 32
        
        readonly property int buttonSm: 32
        readonly property int buttonMd: 40
        readonly property int buttonLg: 48
        
        readonly property int navBarHeight: 56
        readonly property int cardMinHeight: 80
        readonly property int cardMetricHeight: 120
        readonly property int listItemHeight: 56
    }
}