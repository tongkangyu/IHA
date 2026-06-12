# IHA - 智能健康助理

<p align="center">
  <strong>一款基于 Qt 6 开发的现代化智能健康管理应用</strong>
</p>
<p align="center">
  集成 AI 对话功能，为用户提供个性化的健康数据分析和建议
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-0.3.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/Qt-6.11.0-green.svg" alt="Qt">
  <img src="https://img.shields.io/badge/CMake-3.16+-orange.svg" alt="CMake">
  <img src="https://img.shields.io/badge/license-MIT-yellow.svg" alt="License">
</p>

## 📋 目录

- [功能特性](#-功能特性)
- [技术架构](#-技术架构)
- [项目结构](#-项目结构)
- [快速开始](#-快速开始)
- [配置说明](#-配置说明)
- [数据存储](#-数据存储)
- [核心模块](#-核心模块)
- [设备接入](#-设备接入)
- [版本历史](#-版本历史)
- [开发计划](#-开发计划)
- [贡献指南](#-贡献指南)
- [许可证](#-许可证)

---

## ✨ 功能特性

### 📊 健康数据管理

全方位的健康指标追踪与可视化：

- **步数追踪** - 每日步数统计与目标达成进度，支持周趋势分析
- **卡路里消耗** - 自动计算每日热量消耗，智能目标管理
- **活动记录** - 中高强度活动时间统计，运动数据可视化
- **睡眠监测** - 睡眠时长和质量数据展示，周平均分析
- **心率监测** - 实时心率数据追踪，最大心率计算
- **周趋势分析** - 7天数据对比与趋势图表，健康变化一目了然

### 🤖 AI 健康助理

基于大语言模型的智能对话系统：

- **自然语言交互** - 像朋友一样聊天，沟通更自然流畅
- **健康数据分析** - 基于真实健康数据的个性化分析
- **专业建议** - 运动、睡眠、饮食的科学建议
- **对话持久化** - 自动保存对话历史，随时回顾
- **快捷问题** - 预设常用问题入口（今日报告/运动建议/睡眠分析）
- **上下文感知** - 智能识别健康相关话题，提供深度分析

### 🏠 设备与环境管理

全场景智能设备管理：

- **设备连接** - 支持6种设备同时连接（手表/体脂秤/血压计/净化器/新风/车载）
- **室内环境** - 温度/湿度/PM2.5/CO2/甲醛/光照实时监测
- **智能场景** - CO2升高自动开新风、睡眠模式联动
- **设备详情** - 固件版本/蓝牙地址/序列号等信息查看
- **数据授权** - 精细控制8类健康数据的共享权限

### 🎨 用户体验

精心设计的界面与交互：

- **深色/浅色主题** - 无缝切换，设置持久化保存
- **卡片动画** - 点击卡片展开为详情页，关闭时匹配还原动画
- **页面导航** - 多层级页面管理，支持前进/后退动画匹配
- **数据可视化** - 直观的数据图表和进度展示
- **响应式布局** - RowLayout 对齐系统，确保界面元素整齐排列
- **组件化设计** - 可复用的 UI 组件库

---

## 🏗️ 技术架构

### 核心技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| **Qt** | 6.11.0 | UI 框架与 QML 引擎 |
| **QML** | Qt Quick | 声明式 UI 与动画 |
| **CMake** | 3.16+ | 构建系统 |
| **C++** | C++17 | 业务逻辑层 |
| **MinGW** | 13.1.0 | Windows 编译器 |

### 架构设计

```
┌─────────────────────────────────────────────┐
│              表现层 (QML)                    │
│  ┌───────────┬───────────┬──────────────┐   │
│  │  HealthPage│Assistant  │  DevicePage  │   │
│  │  健康主页  │  AI助理   │  设备管理    │   │
│  ├───────────┼───────────┼──────────────┤   │
│  │ ProfilePage│Environment│  Settings    │   │
│  │  个人中心  │  室内环境  │  设置中心    │   │
│  └───────────┴───────────┴──────────────┘   │
└─────────────────────┬───────────────────────┘
                      │ Context Properties
┌─────────────────────▼───────────────────────┐
│            业务逻辑层 (C++)                  │
│  ┌──────────────┬──────────┬───────────┐    │
│  │HealthDataMgr │AIService │DeviceMgr  │    │
│  │ 健康数据管理  │ AI服务   │ 设备管理   │    │
│  ├──────────────┼──────────┼───────────┤    │
│  │ UserService  │HealthCir │MedicalSvc │    │
│  │ 用户服务     │ 健康圈    │ 在线问诊   │    │
│  └──────────────┴──────────┴───────────┘    │
└──────────┬──────────────────┬───────────────┘
           │                  │
┌──────────▼────────┐  ┌─────▼───────────────┐
│   数据持久化       │  │   网络层            │
│  JSON 文件存储     │  │   Qt Network        │
│  QSettings 配置    │  │   HTTP REST API     │
└───────────────────┘  └─────────────────────┘
```

### 设计模式

- **MVC 架构** - QML (View) 与 C++ (Model/Controller) 分离
- **信号槽机制** - 松耦合的模块间通信
- **属性绑定** - QML 与 C++ 的双向数据绑定
- **单例模式** - 全局服务实例管理
- **导航栈** - `pageStack` + `pageStackTypes` 实现动画匹配的页面导航

### 动画系统

| 动画类型 | 触发方式 | 打开动画 | 关闭动画 |
|----------|----------|----------|----------|
| 卡片展开 | `pushFromCard()` | 从卡片位置缩放展开 | `goBack()` → 缩放收回 |
| 页面滑入 | `pushFromRight()` | 从右侧滑入 | `goBack()` → 向右滑出 |

`goBack()` 自动根据 `pageStackTypes` 记录的打开方式匹配对应的关闭动画。

---

## 📁 项目结构

```
IHA/
├── main.cpp                      # 应用入口，初始化服务
├── Main.qml                      # 主窗口，页面导航框架
├── CMakeLists.txt                # CMake 构建配置
├── CMakePresets.json             # CMake 预设配置
├── CMakeUserPresets.json         # 用户自定义预设（MinGW）
├── config.h.example              # API 配置模板
│
├── AIService.h/cpp               # AI 服务层
│   ├── HTTP 请求管理             # 调用 AI API（非流式）
│   ├── 对话历史管理              # JSON 格式存储
│   ├── 健康上下文构建            # 数据格式化
│   └── 错误处理                  # 网络异常处理
│
├── HealthDataManager.h/cpp       # 健康数据管理层
│   ├── 今日数据追踪              # 步数/卡路里/睡眠/心率
│   ├── 周统计分析                # 平均值计算
│   ├── 数据持久化                # 自动保存/加载
│   └── 跨日重置                  # 新的一天自动清零
│
├── DeviceManager.h/cpp           # 设备管理层
├── UserService.h/cpp             # 用户服务层
├── HealthCircleManager.h/cpp     # 健康圈管理层
├── MedicalService.h/cpp          # 在线问诊服务层
│
├── qml/
│   ├── Theme.qml                 # 全局主题定义
│   │
│   ├── components/               # 可复用组件
│   │   ├── Card.qml              # 卡片容器
│   │   ├── AnimatedListItem.qml  # 动画列表项
│   │   └── AnimatedProgressBar.qml # 动画进度条
│   │
│   └── pages/                    # 页面文件
│       ├── HealthPage.qml        # 健康数据主页
│       ├── AssistantPage.qml     # AI 助理对话页
│       ├── DevicePage.qml        # 设备管理页
│       ├── ProfilePage.qml       # 个人中心
│       ├── EnvironmentPage.qml   # 室内环境监测页
│       ├── LoginPage.qml         # 账户与登录页
│       ├── AddDevicePage.qml     # 添加设备页
│       ├── DataAuthorizationPage.qml # 数据授权管理页
│       ├── DeviceDetailPage.qml  # 设备详情页
│       ├── HealthCirclePage.qml  # 健康圈页
│       ├── OnlineConsultationPage.qml # 在线问诊页
│       ├── HabitsPage.qml        # 习惯追踪页
│       ├── HealthReportPage.qml  # 健康报告页
│       ├── MyActivitiesPage.qml  # 我的活动
│       ├── MyBadgesPage.qml      # 我的徽章
│       ├── MyCoursesPage.qml     # 我的课程
│       ├── MyOrdersPage.qml      # 我的订单
│       ├── MyFamilyFriendsPage.qml # 家人朋友
│       │
│       ├── details/              # 详情页
│       │   ├── StepsDetailPage.qml      # 步数详情
│       │   ├── CaloriesDetailPage.qml   # 卡路里详情
│       │   ├── SleepDetailPage.qml      # 睡眠详情
│       │   ├── HeartRateDetailPage.qml  # 心率详情
│       │   ├── ActivityDetailPage.qml   # 活动详情
│       │   └── ActivityCountDetailPage.qml # 活动次数详情
│       │
│       └── settings/             # 设置页
│           ├── AppSettingsPage.qml      # 应用设置
│           ├── AboutPage.qml            # 关于页面
│           ├── ProfileInfoPage.qml      # 个人信息
│           ├── SystemPermissionsPage.qml # 系统权限
│           └── HelpFeedbackPage.qml     # 帮助反馈
│
└── LICENSE                       # MIT 许可证
```

---

## 🚀 快速开始

### 环境要求

| 软件 | 最低版本 | 推荐版本 |
|------|----------|----------|
| Qt | 6.11.0 | 6.11.0+ |
| CMake | 3.16 | 3.28+ |
| MinGW | 13.1.0 | 13.1.0+ |

### 安装依赖

1. **安装 Qt 6.11.0**
   - 下载 [Qt Online Installer](https://www.qt.io/download)
   - 选择组件：`Qt 6.11.0` → `MinGW 13.1.0 64bit`
   - 勾选 `Qt Quick`、`Qt Quick Controls 2`、`Qt Network`
   - 在 Qt Creator 中安装 `MinGW 13.1.0` 工具链

2. **安装 CMake**
   Qt 安装器已自带 CMake，位于 `C:\Qt\Tools\CMake_64\bin\cmake.exe`

### 克隆与构建

```bash
# 克隆项目
git clone https://github.com/your-username/IHA.git
cd IHA

# 创建构建目录
mkdir build && cd build

# 配置项目（MinGW）
cmake .. -G "MinGW Makefiles" -DCMAKE_PREFIX_PATH=C:/Qt/6.11.0/mingw_64 -DCMAKE_BUILD_TYPE=Debug

# 编译
cmake --build .
```

### 使用 Qt Creator

1. 打开 Qt Creator
2. 文件 → 打开文件或项目 → 选择 `CMakeLists.txt`
3. 配置项目：
   - 构建套件：`Desktop Qt 6.11.0 MinGW 64bit`
   - 构建类型：`Release` 或 `Debug`
4. 点击底部绿色 ▶ 按钮运行

> ⚠️ **注意**：请使用 MinGW 构建套件。Ninja + MSVC 在 Windows 上存在已知的管道 I/O 问题（`GetOverlappedResult` 错误），可能导致间歇性构建失败。

### 运行应用

```bash
# Windows
cd build
appIHA.exe
```

---

## ⚙️ 配置说明

### AI 服务配置

1. 复制配置文件模板：
   ```bash
   copy config.h.example config.h
   ```

2. 编辑 `config.h`，填入你的配置：
   ```cpp
   #ifndef CONFIG_H
   #define CONFIG_H

   // AI 服务配置
   #define AI_API_URL "https://your-api-endpoint.com/v1/chat/completions"
   #define AI_API_KEY "sk-your-api-key-here"
   #define AI_MODEL "gpt-3.5-turbo"  // 或其他兼容模型

   // 应用版本
   #define APP_VERSION "0.3.0"

   #endif // CONFIG_H
   ```

### 配置参数说明

| 参数 | 说明 | 示例 |
|------|------|------|
| `AI_API_URL` | AI API 端点 URL | `https://api.openai.com/v1/chat/completions` |
| `AI_API_KEY` | API 认证密钥 | `sk-xxxxxxxxxxxxxxx` |
| `AI_MODEL` | 使用的模型名称 | `gpt-3.5-turbo`, `claude-3`, 等 |

### 支持的 AI 服务

本应用兼容任何支持 OpenAI Chat Completions API 格式的服务：

- **OpenAI** - GPT-3.5/4 系列
- **Claude** - Anthropic Claude 系列
- **国内服务** - 通义千问、文心一言等（需兼容 API 格式）
- **本地部署** - Ollama、LocalAI 等

---

## 💾 数据存储

### 存储位置

| 系统 | 路径 |
|------|------|
| Windows | `%LOCALAPPDATA%/IHA/SmartHealth/` |
| macOS | `~/Library/Application Support/IHA/SmartHealth/` |
| Linux | `~/.local/share/IHA/SmartHealth/` |

### 数据文件

| 文件名 | 内容 | 格式 |
|--------|------|------|
| `health_data.json` | 健康数据记录 | JSON |
| `conversation.json` | AI 对话历史 | JSON |
| QSettings | 应用设置（深色模式等） | 系统原生 |

### 数据管理特性

- ✅ **自动保存** - 每次数据变更自动持久化
- ✅ **跨日重置** - 检测到新日期自动重置当日数据
- ✅ **周统计** - 自动计算 7 天平均值
- ✅ **对话恢复** - 应用重启后自动加载历史对话
- ✅ **设置持久化** - 深色/浅色模式等设置跨重启保留
- ✅ **数据完整性** - JSON 格式确保数据可读可编辑

---

## 🔧 核心模块

### AIService - AI 服务层

负责与 AI API 通信，管理对话历史。使用非流式请求（`stream: false`），通过 `responseReceived` 信号返回完整回复。

**QML 接口：**
```qml
// 发送消息（含健康上下文）
aiService.sendMessage(userMessage, healthContext)

// 清空对话
aiService.clearConversation()

// 保存对话
aiService.saveConversation()

// 加载对话
aiService.loadConversation()

// 获取对话列表
var messages = aiService.getConversationForQML()
```

**信号：**
- `responseReceived(response)` - 收到 AI 回复
- `errorOccurred(error)` - 发生错误
- `isLoadingChanged()` - 加载状态变更
- `conversationLoaded()` - 对话加载完成

### HealthDataManager - 健康数据管理层

负责健康数据的采集、存储和分析。

**QML 接口：**
```qml
// 添加步数
healthDataManager.addSteps(1000)

// 更新睡眠
healthDataManager.updateSleep(7, 30)  // 7小时30分钟

// 更新心率
healthDataManager.updateHeartRate(75)

// 生成示例数据
healthDataManager.generateSampleData()
```

### 导航系统

Main.qml 实现了完整的页面导航栈：

```qml
// 卡片展开动画打开
navigationStack.pushFromCard(pageUrl, cardX, cardY, cardW, cardH)

// 右侧滑入动画打开
navigationStack.pushFromRight(pageUrl)

// 智能返回（自动匹配关闭动画）
navigationStack.goBack()
```

`goBack()` 根据 `pageStackTypes` 数组记录的打开方式，自动选择对应的关闭动画：
- 卡片打开的页面 → 缩放收回动画
- 滑入打开的页面 → 向右滑出动画

---

## 🔌 设备接入

目前本应用的健康数据为**模拟数据**。若需要接入真实的智能穿戴设备数据，需要以下条件：

| 方案 | 说明 | 难度 |
|------|------|------|
| **小米运动健康 API** | 需在小米开发者平台注册应用 | ⚠️ 高 |
| **Google Fit** | Google 健康数据平台 | 🟡 中 |
| **华为 Health Kit** | 华为健康数据接口 | 🟡 中 |
| **Apple HealthKit** | 苹果原生健康数据框架 | 🟢 低 |
| **蓝牙设备 SDK** | 联系厂商获取开发支持 | 🟡 中 |

> 💡 **提示：** 如果您有相关资源或解决方案，欢迎提交 Issue 或 Pull Request！

---

## 📜 版本历史

### v0.3.0 (2026-04-19)

**🎉 新功能**
- ✨ 新增室内环境监测页（温度/湿度/PM2.5/CO2/甲醛/光照）
- ✨ 新增账户与登录页（手机号登录/注册/第三方登录）
- ✨ 新增数据授权管理页（8类健康数据精细权限控制）
- ✨ 新增设备详情页（设备信息/同步/断开/移除）
- ✨ 新增在线问诊页（科室选择/推荐医生/问诊记录）
- ✨ 新增健康圈页（成员管理/邀请/数据共享）

**🛠️ 改进**
- 🎨 动画匹配系统：卡片打开的页面关闭时使用缩放收回，滑入页面关闭时使用滑出
- 🎨 深色/浅色主题全页面适配（设备页/环境页/登录页/数据授权页等）
- 🎨 RowLayout 对齐系统：开关/箭头/按钮右对齐统一
- 🎨 字母图标替代 emoji（解决 Windows 上 emoji 渲染性能问题）
- 💾 设置持久化：深色模式等设置通过 QSettings 跨重启保留
- 🏗️ 构建系统从 MSVC+Ninja 迁移到 MinGW Makefiles
- 🏗️ AI 助理重构：页面自管理 ListModel，不再依赖外部传入

**🐛 修复**
- 修复设备页严重卡顿（移除 emoji、使用 Flickable 替代 ScrollView）
- 修复 AI 助理发送消息无响应（messageModel 为 null 导致 sendMessage 直接返回）
- 修复页面切换后加载指示器永久显示
- 修复 Profile 页点击 IoT/登录/数据授权后黑屏
- 修复 PowerShell 批量替换导致的 UTF-8 编码损坏（29 个文件）
- 修复 DeviceManager 传感器更新定时器导致的性能问题

### v0.2.0 (2026-04-12)

**🎉 新功能**
- ✨ 新增 AI 健康助理功能
- 💬 智能对话，自然语言交流
- 📊 基于健康数据的个性化分析
- 🔄 对话记录保存与恢复

**🛠️ 改进**
- 📦 添加健康数据持久化存储
- 🎨 优化页面切换动画效果
- 🌓 改进深色/浅色主题切换
- 📝 添加版本号显示
- 🎯 优化目标设置管理

**🐛 修复**
- 修复数据加载时序问题
- 修复跨日数据重置逻辑

### v0.1.19 (2026-04-11)

**🎉 初始版本**
- 📱 基础健康数据展示界面
- 🧭 页面导航框架搭建
- 🎨 深色主题设计
- 📊 步数/卡路里/睡眠/心率数据展示
- 📈 周趋势图表

---

## 🎯 开发计划

### 近期计划

- [ ] 真实设备数据接入（HealthKit / Google Fit）
- [ ] 手动数据录入界面
- [ ] 健康报告生成与导出
- [ ] 运动记录功能
- [ ] 数据导出（CSV / PDF）

### 中期计划

- [ ] 多语言支持（中/英/日）
- [ ] 习惯养成追踪器
- [ ] 家人朋友健康分享
- [ ] 健康徽章系统
- [ ] 在线课程集成

### 长期愿景

- [ ] AI 个性化健康计划
- [ ] 智能提醒与预警
- [ ] 社区排行榜
- [ ] 与医疗机构数据对接
- [ ] 跨平台支持（macOS / Linux / Android / iOS）

---

## 🤝 贡献指南

我们欢迎所有形式的贡献！

### 如何贡献

1. **Fork 本仓库**
2. **创建特性分支** (`git checkout -b feature/AmazingFeature`)
3. **提交更改** (`git commit -m 'Add some AmazingFeature'`)
4. **推送到分支** (`git push origin feature/AmazingFeature`)
5. **开启 Pull Request**

### 开发规范

- 遵循 Qt/C++ 编码规范
- QML 组件遵循模块化设计
- 提交信息使用祈使句（`Add feature` 而非 `Added feature`）
- **QML 文件必须使用 UTF-8 编码**（不要用 PowerShell `Set-Content`，它会用 GBK 编码损坏中文）
- 使用 RowLayout + Layout.fillWidth 实现右对齐（不要用 Row + Item{width:1}）
- 使用字母图标替代 emoji（Windows 上 emoji 渲染性能极差）

---

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源。

---

<p align="center">
  <sub>用 ❤️ 打造 | 如果觉得不错，请给个 ⭐️ Star</sub>
</p>
