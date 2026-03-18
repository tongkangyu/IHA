# IHA - 智能健康助理

一款基于 Qt 6 开发的智能健康管理应用，集成 AI 对话功能，为用户提供个性化的健康数据分析和建议。

## 功能特性

### 健康数据管理
- **步数追踪** - 每日步数统计与目标达成进度
- **卡路里消耗** - 自动计算每日热量消耗
- **活动记录** - 中高强度活动时间统计
- **睡眠监测** - 睡眠时长和质量数据展示
- **心率记录** - 实时心率数据追踪
- **周趋势分析** - 7天数据对比与趋势图表

### AI 健康助理
- 智能对话，自然语言交流
- 基于健康数据的个性化分析
- 运动、睡眠、饮食建议
- 对话历史持久化保存
- 快捷问题入口

### 用户界面
- 现代化深色/浅色主题切换
- 流畅的卡片展开动画效果
- 直观的数据可视化展示
- 响应式布局设计
- 适配多分辨率屏幕

## 技术栈

- **框架**: Qt 6.9.2 + QML
- **构建系统**: CMake
- **编译器**: MSVC 2022
- **网络**: Qt Network (HTTP 请求)

## 项目结构

```
IHA/
├── main.cpp                 # 应用入口
├── Main.qml                 # 主界面
├── AIService.cpp/h          # AI 服务封装
├── HealthDataManager.cpp/h  # 健康数据管理
├── config.h.example         # 配置文件模板
├── CMakeLists.txt           # 构建配置
├── qml/
│   ├── Theme.qml            # 主题定义
│   ├── components/          # 可复用组件
│   │   ├── Card.qml         # 卡片组件
│   │   ├── Button.qml       # 按钮组件
│   │   ├── AnimatedListItem.qml    # 动画列表项
│   │   └── AnimatedProgressBar.qml # 动画进度条
│   └── pages/               # 页面文件
│       ├── HealthPage.qml   # 健康主页
│       ├── AssistantPage.qml # AI助理页
│       ├── ProfilePage.qml  # 个人中心
│       ├── details/         # 详情页
│       │   ├── StepsDetailPage.qml
│       │   ├── CaloriesDetailPage.qml
│       │   ├── SleepDetailPage.qml
│       │   └── ...
│       └── settings/        # 设置页
│           ├── AboutPage.qml
│           ├── AppSettingsPage.qml
│           └── ...
└── assets/                  # 资源文件
```

## 构建说明

### 环境要求

- Qt 6.9.2 或更高版本
- CMake 3.16+
- MSVC 2022 (Windows) 或其他兼容编译器

### 配置

1. 复制配置文件模板：
   ```bash
   cp config.h.example config.h
   ```

2. 编辑 `config.h`，填入你的配置：
   ```cpp
   #define AI_API_URL "你的API地址"
   #define AI_API_KEY "你的API密钥"
   #define AI_MODEL "模型名称"
   ```

### 编译

#### 使用 Qt Creator
1. 打开 `CMakeLists.txt`
2. 选择构建套件 (Desktop Qt 6.9.2 MSVC2022 64bit)
3. 点击构建

#### 使用命令行
```bash
mkdir build && cd build
cmake ..
cmake --build .
```

## 数据存储

应用数据存储在系统应用数据目录：

- **Windows**: `%LOCALAPPDATA%/IHA/`
  - `health_data.json` - 健康数据记录
  - `conversation.json` - AI 对话历史

数据会自动保存，并在新的一天自动重置当日数据。

## 关于设备数据接入

目前本应用的健康数据为模拟数据。若需要接入真实的智能穿戴设备数据，需要以下条件：

### Android 平台
- 使用小米运动健康 API 需要在小米开发者平台注册应用
- 需要与小米方面签署合作协议
- API 目前不对个人开发者开放

### iOS 平台
- Apple HealthKit 可获取健康数据
- 需要申请 HealthKit 权限
- 需要苹果开发者账号

### 蓝牙设备
- 需要设备厂商提供 SDK 或开放蓝牙协议
- 大多数消费级穿戴设备协议不公开
- 建议联系设备厂商获取开发支持

如果您有相关资源或解决方案，欢迎提交 Issue 或 Pull Request。

## 版本历史

### v0.2.0
- 新增 AI 健康助理功能
- 添加健康数据持久化存储
- 对话记录保存与恢复
- 优化页面切换动画效果
- 改进深色/浅色主题切换
- 添加版本号显示

### v0.1.19
- 初始版本发布
- 基础健康数据展示界面
- 页面导航框架搭建

## 许可证

[MIT License](LICENSE)

## 贡献

欢迎提交 Issue 和 Pull Request！

### 开发计划
- [ ] 真实设备数据接入
- [ ] 健康报告生成
- [ ] 运动记录功能
- [ ] 数据导出功能
- [ ] 多语言支持
