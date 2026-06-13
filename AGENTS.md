# AGENTS.md

## 项目概述

IHA（智能健康助理）— 华南农业大学软件工程课程项目，基于 Qt 6 + C++17。
课程文档和参考实现不随仓库提交，仅用于需求和数据库结构参考。

## 构建

**必须用 MinGW Makefiles**，Ninja + MSVC 有管道 I/O 问题会间歇性失败。

```bash
set QTDIR=C:\Qt\6.11.0\mingw_64
cmake -B build -G "MinGW Makefiles" -DCMAKE_PREFIX_PATH=%QTDIR% -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

或用 Qt Creator 选 `Desktop Qt 6.11.0 MinGW 64bit` 套件。预设见 `CMakePresets.json`。

## 安全

- `config.h` 含真实 API 密钥，已在 `.gitignore` 中，**绝不提交**
- 首次使用：`copy config.h.example config.h` 后填入实际值
- 宏：`AI_API_URL`、`AI_API_KEY`、`AI_MODEL`、`USER_API_URL`、`MEDICAL_API_URL`

## 架构

```
C++ 服务单例 ──(setContextProperty)──> QML 前端
```

- **main.cpp** 注册 6 个上下文属性：`aiService`、`healthDataManager`、`userService`、`deviceManager`、`healthCircleManager`、`medicalService`
- **Main.qml** 通过 `pageStack` + `pageStackTypes` 数组实现导航动画匹配
- **Theme.qml** 定义设计令牌（颜色/字体/间距/圆角/动画时长）
- 数据存储：JSON → `%LOCALAPPDATA%/IHA/SmartHealth/`；设置 → `QSettings`（org=IHA, app=SmartHealth）

## 导航

- `navigationStack.pushFromCard(url, x, y, w, h)` — 卡片缩放展开
- `navigationStack.pushFromRight(url)` — 右侧滑入
- `navigationStack.goBack()` — 自动匹配关闭动画

## QML 规范（必须遵守）

- **禁止** PowerShell `Set-Content` 写 QML 文件 — 会以 GBK 编码损坏中文
- **禁止** QML 中使用 emoji — Windows 渲染性能极差，用单字母文本图标替代
- 右对齐用 `RowLayout` + `Layout.fillWidth`，不用 `Row` + `Item{width:1}`
- 列表用 `Flickable`，不用 `ScrollView`（后者会严重卡顿）
- 新增 QML 页面必须同时加入 `CMakeLists.txt` 的 `QML_FILES`，路径格式 `qrc:/qt/qml/IHA/...`

## 文件组织

- `*.h/*.cpp` — C++ 服务类（根目录平铺）
- `qml/components/` — 可复用组件（Card、Button、AnimatedProgressBar、AnimatedListItem）
- `qml/pages/` — 顶层页面；`details/` — 健康指标详情；`settings/` — 设置子页
- `backend/` — C++ 后端服务（Crow + MySQL，独立 CMake 项目，在 Linux/WSL 编译运行）

## 后端服务（backend/）

独立 C++ 项目，Crow HTTP 框架 + MySQL Connector/C++ + JWT。前后端通过 REST API 通信。

### 编译（在 WSL 中）

```bash
sudo apt install cmake g++ libmysqlcppconn-dev libssl-dev libboost-all-dev
cd /mnt/c/personal/code/cpp/project/IHA/backend
mkdir build && cd build
cmake ..
make -j$(nproc)
```

### 运行

```bash
cp config.example.json config.json  # 编辑填入 MySQL 密码和 AI API Key
mysql -u root -p < sql/init.sql     # 首次初始化数据库
./iha_server                        # 默认 :8080
```

### 后端 API 概览

| 端点 | 方法 | 状态 | 说明 |
|------|------|------|------|
| `/api/auth/register` | POST | 已实现 | 注册（mobile + password） |
| `/api/auth/login` | POST | 已实现 | 登录，返回 JWT |
| `/api/health/data` | POST | 已实现 | 上报健康数据 |
| `/api/health/dashboard` | GET | 已实现 | 融合仪表盘 |
| `/api/health/recent` | GET | 已实现 | 最近健康记录 |
| `/api/user/info` | GET/PUT | 已实现 | 个人信息读写 |
| `/api/report/weekly` | GET | 已实现 | AI 生成周报 |
| `/api/habits` | GET/POST | 已实现 | 习惯追踪（列表/打卡/创建） |
| `/api/badges` | GET | 已实现 | 勋章列表 |
| `/api/challenges` | GET | 已实现 | 活动挑战列表 |
| `/api/courses` | GET | 已实现 | 课程列表 |
| `/api/orders` | GET | 已实现 | 订单列表 |
| `/api/init-sample-data` | POST | 已实现 | 一键生成演示数据 |
| `/api/device/*` | * | 501 stub | 预留 |
| `/api/authorization/*` | * | 501 stub | 预留 |
| `/api/consultation/*` | * | 501 stub | 预留 |

### 后端配置

`backend/config.json`（已 gitignore），模板见 `config.example.json`。含数据库连接、JWT 密钥、AI API 配置。

## 课程要求差距

设计文档要求但尚未实现：IoT 真实设备数据上报、医生工作台（Web）、数据授权流程、在线问诊流程、自动化规则引擎。当前设备/授权/问诊 API 为 501 stub。
