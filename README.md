# IHA 智能健康助理

IHA 是一个基于 Qt 6 + C++17 的智能健康管理课程项目，包含 Windows 桌面客户端和独立 C++ 后端服务。客户端负责健康数据展示、AI 健康助理、个人中心和设备/健康圈等页面；后端负责账号登录、用户信息、健康数据、习惯追踪、徽章、课程、订单和周报等 REST API。

## 功能概览

- 健康仪表盘：步数、睡眠、心率、卡路里、活动等指标展示和详情页。
- AI 健康助理：基于 OpenAI Chat Completions 兼容接口生成健康建议。
- 账号系统：手机号注册、登录、JWT 会话、个人资料同步。
- 健康扩展：习惯追踪、徽章、活动挑战、课程、订单、周报。
- 桌面体验：Qt Quick/QML 界面、页面导航动画、主题设置、本地数据缓存。
- 后端部署：Crow + MySQL + Docker Compose，支持快速启动 MySQL 和 C++ 服务。

## 技术栈

| 部分 | 技术 |
|------|------|
| 客户端 | Qt 6.11, QML, C++17, Qt Network |
| 构建 | CMake, MinGW Makefiles |
| 后端 | C++17, Crow, MySQL Connector/C++, JWT, spdlog |
| 数据库 | MySQL 8.0 |
| 部署 | Docker, Docker Compose |

## 项目结构

```text
IHA/
├── CMakeLists.txt              # Qt 客户端构建配置
├── CMakePresets.json           # CMake 预设，使用 QTDIR 环境变量
├── config.h.example            # 客户端配置模板，复制为 config.h 使用
├── main.cpp                    # 客户端入口，注册 QML 服务
├── *Service.* / *Manager.*     # 客户端 C++ 服务类
├── Main.qml                    # 客户端主窗口和导航栈
├── qml/                        # QML 页面和组件
├── backend/                    # C++ 后端服务
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── .env.example            # Docker 数据库密码模板
│   ├── config.example.json     # 手动部署配置模板
│   ├── config.docker.json      # Docker 部署配置模板
│   ├── sql/init.sql            # MySQL 建表脚本
│   └── src/                    # 后端源码
└── LICENSE
```

## 配置文件和隐私

仓库只提交模板文件，不提交真实密钥或本机配置。

| 文件 | 是否提交 | 说明 |
|------|----------|------|
| `config.h.example` | 是 | 客户端配置模板 |
| `config.h` | 否 | 客户端本地配置，包含后端地址 |
| `ai_config.json` | 否 | 客户端运行时 AI 配置，包含 AI Key |
| `backend/config.example.json` | 是 | 后端手动部署模板 |
| `backend/config.docker.json` | 是 | 后端 Docker 部署模板，含占位值 |
| `backend/config.json` | 否 | 后端真实配置，包含数据库密码、JWT secret、AI Key |
| `backend/.env.example` | 是 | Docker 环境变量模板 |
| `backend/.env` | 否 | Docker 真实数据库密码 |

提交前建议检查：

```bash
git status --short --ignored
git check-ignore -v config.h backend/config.json backend/.env
```

## 客户端开发运行

### 环境要求

- Windows 10/11
- Qt 6.11.0，组件选择 `MinGW 13.1.0 64bit`
- CMake 3.16+
- MinGW Makefiles，推荐使用 Qt 自带 MinGW

不要使用 MSVC + Ninja。本项目在 Windows 上要求 `MinGW Makefiles`，否则 Qt Creator 可能找不到 MinGW 版 Qt 或出现构建问题。

### 准备客户端配置

复制模板：

```bat
copy config.h.example config.h
```

编辑 `config.h`：

```cpp
#ifndef CONFIG_H
#define CONFIG_H

#define USER_API_URL "http://localhost:8080/api"
#define MEDICAL_API_URL "http://localhost:8080/api"

#endif // CONFIG_H
```

如果后端部署在服务器，把 `USER_API_URL` 和 `MEDICAL_API_URL` 改成服务器地址，例如 `http://服务器IP:8080/api`。

AI 对话模型不再从 `config.h` 编译进客户端。需要启用 AI 对话时，在 `appIHA.exe` 同目录创建 `ai_config.json`：

```json
{
  "api_url": "https://api.deepseek.com/v1/chat/completions",
  "api_key": "你的 AI API Key",
  "model": "deepseek-v4-flash"
}
```

也可以用环境变量配置：

```bat
set IHA_AI_API_URL=https://api.deepseek.com/v1/chat/completions
set IHA_AI_API_KEY=你的 AI API Key
set IHA_AI_MODEL=deepseek-v4-flash
```

### 命令行构建

```bat
set QTDIR=C:\Qt\6.11.0\mingw_64
cmake -B out/build/debug -G "MinGW Makefiles" -DCMAKE_PREFIX_PATH=%QTDIR% -DCMAKE_BUILD_TYPE=Debug
cmake --build out/build/debug -j8
```

运行：

```bat
out\build\debug\appIHA.exe
```

### Qt Creator 构建

1. 打开 Qt Creator。
2. 打开 `CMakeLists.txt`。
3. Kit 选择 `Desktop Qt 6.11.0 MinGW 64-bit`。
4. CMake generator 使用 `MinGW Makefiles`。
5. 配置并运行项目。

如果 Qt Creator 报 `Could not find Qt6Config.cmake`，通常是选成了 MSVC kit 或 `CMAKE_PREFIX_PATH` 为空。切回 MinGW kit，或设置 `QTDIR=C:\Qt\6.11.0\mingw_64` 后重新配置。

## 客户端打包

建议使用 Release 构建发布：

```bat
set QTDIR=C:\Qt\6.11.0\mingw_64
cmake -B out/build/release -G "MinGW Makefiles" -DCMAKE_PREFIX_PATH=%QTDIR% -DCMAKE_BUILD_TYPE=Release
cmake --build out/build/release -j8
```

复制 Qt 运行依赖：

```bat
cd out\build\release
C:\Qt\6.11.0\mingw_64\bin\windeployqt.exe appIHA.exe --qmldir ..\..\..
```

在发布目录创建 `qt.conf`，固定 Qt 插件和 QML 查找路径，避免运行时报 `Could not find the Qt platform plugin "windows"`：

```ini
[Paths]
Prefix=.
Plugins=.
Qml2Imports=qml
Translations=translations
```

把 `out/build/release` 目录压缩为客户端发布包即可。用户解压后运行 `appIHA.exe`。

客户端可以独立启动，但登录、健康数据同步、习惯、徽章、课程、订单和周报等功能需要后端服务在线。

## 服务端 Docker 部署

进入后端目录：

```bash
cd backend
```

准备配置：

```bash
cp .env.example .env
cp config.docker.json config.json
```

编辑 `.env`：

```env
DB_PASSWORD=换成你的数据库密码
```

编辑 `config.json`，至少修改：

```json
{
  "database": {
    "host": "db",
    "port": 3306,
    "user": "root",
    "password": "必须和 .env 里的 DB_PASSWORD 一致",
    "schema": "health_db"
  },
  "jwt": {
    "secret": "换成随机长字符串"
  },
  "ai": {
    "api_key": "你的 AI API Key"
  }
}
```

启动：

```bash
docker compose up -d
```

验证：

```bash
curl http://localhost:8080/api/ping
```

正常返回：

```json
{"code":200,"message":"pong"}
```

停止服务：

```bash
docker compose down
```

清空数据库并重建：

```bash
docker compose down -v
docker compose up -d
```

## 服务端手动部署

适用于 Linux/WSL 环境。

安装依赖：

```bash
sudo apt update
sudo apt install -y cmake g++ libmysqlcppconn-dev libssl-dev libboost-all-dev mysql-server
```

初始化数据库：

```bash
mysql -u root -p < backend/sql/init.sql
```

准备配置：

```bash
cd backend
cp config.example.json config.json
```

编辑 `config.json`，填写 MySQL 密码、JWT secret 和 AI API Key。

编译运行：

```bash
mkdir -p build
cd build
cmake ..
make -j$(nproc)
cp ../config.json .
./iha_server
```

默认监听 `0.0.0.0:8080`。

## API 概览

| 端点 | 方法 | 说明 |
|------|------|------|
| `/api/ping` | GET | 健康检查 |
| `/api/auth/register` | POST | 注册 |
| `/api/auth/login` | POST | 登录，返回 JWT |
| `/api/user/info` | GET/PUT | 用户信息读取/更新 |
| `/api/health/data` | POST | 上报健康数据 |
| `/api/health/dashboard` | GET | 健康仪表盘数据 |
| `/api/health/recent` | GET | 最近健康记录 |
| `/api/report/weekly` | GET | AI 生成周报 |
| `/api/habits` | GET/POST | 习惯列表、打卡、创建 |
| `/api/badges` | GET | 徽章列表 |
| `/api/challenges` | GET | 活动挑战列表 |
| `/api/courses` | GET | 课程列表 |
| `/api/orders` | GET | 订单列表 |
| `/api/init-sample-data` | POST | 初始化演示数据 |

设备、授权、在线问诊相关接口当前为预留 stub，返回 501。

## Release 建议

建议前后端分开发布：

- `IHA-Windows-x64-v0.3.1.zip`：客户端 Release 构建目录，已执行 `windeployqt` 并包含 `qt.conf`。
- `IHA-backend-docker-v0.3.0.zip`：`backend/` 目录，包含 Dockerfile、Compose、SQL、源码、依赖压缩包和模板配置。

发布包不要包含：

- `config.h`
- `ai_config.json`
- `backend/config.json`
- `backend/.env`
- `out/`
- `build/`
- `.qtcreator/`

## 注意事项

- 首次运行完整功能前，先启动后端，再打开客户端。
- 客户端的后端地址是编译期配置，改服务器地址后需要重新构建客户端。
- Docker 部署时 `.env` 的 `DB_PASSWORD` 必须和 `config.json` 的 `database.password` 一致。
- `jwt.secret` 必须换成随机长字符串，不能使用模板占位值。
- `ai.api_key`、`ai_config.json`、`IHA_AI_API_KEY` 都属于私密信息，不要提交到 git，不要放进公开 release 包。
- MySQL 数据保存在 Docker volume `backend_db_data` 中，执行 `docker compose down -v` 会删除数据。
- QML 文件保持 UTF-8 编码，避免用 PowerShell `Set-Content` 重写 QML 文件。

## License

本项目基于 [MIT License](LICENSE) 开源。
