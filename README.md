# IHA - 智能健康助理

一款基于 Qt 6 开发的智能健康管理应用，集成 AI 对话功能，为用户提供个性化的健康数据分析和建议。

## 功能特性

### 健康数据管理
- 步数、卡路里、活动次数追踪
- 睡眠时长和质量监测
- 心率数据记录
- 中高强度活动时间统计
- 周数据趋势分析

### AI 健康助理
- 智能对话，自然交流
- 基于健康数据的个性化分析
- 运动、睡眠、饮食建议
- 对话记录持久化保存

### 用户界面
- 现代化深色/浅色主题切换
- 流畅的卡片展开动画
- 直观的数据可视化
- 响应式布局设计

## 技术栈

- **框架**: Qt 6.9.2 + QML
- **构建系统**: CMake
- **编译器**: MSVC 2022
- **AI 服务**: DeepSeek API

## 项目结构

```
IHA/
├── main.cpp              # 应用入口
├── Main.qml              # 主界面
├── AIService.cpp/h       # AI 服务封装
├── HealthDataManager.cpp/h # 健康数据管理
├── config.h.example      # 配置文件模板
├── qml/
│   ├── Theme.qml         # 主题定义
│   ├── components/       # 可复用组件
│   └── pages/            # 页面文件
│       ├── details/      # 详情页
│       └── settings/     # 设置页
└── assets/               # 资源文件
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

2. 编辑 `config.h`，填入你的 API 密钥：
   ```cpp
   #define AI_API_KEY "your-api-key-here"
   ```

### 编译

#### 使用 Qt Creator
1. 打开 `CMakeLists.txt`
2. 配置构建套件
3. 点击构建

#### 使用命令行
```bash
mkdir build && cd build
cmake ..
cmake --build .
```

## 数据存储

应用数据存储在以下位置：

- **Windows**: `%LOCALAPPDATA%/IHA/`
  - `health_data.json` - 健康数据
  - `conversation.json` - AI 对话记录

## 版本历史

### v0.2.0
- 新增 AI 健康助理功能
- 添加健康数据持久化
- 对话记录保存与恢复
- 优化页面动画效果
- 改进主题切换功能

### v0.1.19
- 初始版本
- 基础健康数据展示
- 页面导航框架

## 许可证

[MIT License](LICENSE)

## 贡献

欢迎提交 Issue 和 Pull Request。