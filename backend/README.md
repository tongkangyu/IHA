# IHA Backend

这是 IHA 智能健康助理的 C++ 后端服务，基于 Crow + MySQL + JWT。它为 Qt 桌面客户端提供注册登录、用户信息、健康数据、AI 周报、习惯、徽章、活动、课程和订单等 REST API。

## 配置文件

仓库不提交真实配置，只提交模板。

| 文件 | 是否提交 | 用途 |
|------|----------|------|
| `.env.example` | 是 | Docker Compose 环境变量模板 |
| `.env` | 否 | Docker 数据库密码 |
| `config.example.json` | 是 | 手动部署模板 |
| `config.docker.json` | 是 | Docker 部署模板 |
| `config.json` | 否 | 实际运行配置，包含密码、JWT secret、AI Key |

真实部署前必须修改：

- `.env` 的 `DB_PASSWORD`
- `config.json` 的 `database.password`
- `config.json` 的 `jwt.secret`
- `config.json` 的 `ai.api_key`

Docker 模式下，`.env` 的 `DB_PASSWORD` 必须和 `config.json` 的 `database.password` 一致。

## Docker 部署

Docker Compose 会启动两个服务：

- `db`：MySQL 8.0，容器端口 `3306`，宿主机端口 `3307`
- `server`：IHA C++ 后端，宿主机端口 `8080`

准备配置：

```bash
cp .env.example .env
cp config.docker.json config.json
```

编辑 `.env`：

```env
DB_PASSWORD=换成你的数据库密码
```

编辑 `config.json`：

```json
{
  "database": {
    "host": "db",
    "port": 3306,
    "user": "root",
    "password": "必须和 .env 的 DB_PASSWORD 一致",
    "schema": "health_db"
  },
  "jwt": {
    "secret": "换成随机长字符串"
  },
  "ai": {
    "api_url": "https://api.deepseek.com/v1/chat/completions",
    "api_key": "你的 AI API Key",
    "model": "deepseek-v4-flash"
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

查看日志：

```bash
docker compose logs -f server
```

停止：

```bash
docker compose down
```

清空数据库并重建：

```bash
docker compose down -v
docker compose up -d
```

## 手动部署

适用于 Linux/WSL。

安装依赖：

```bash
sudo apt update
sudo apt install -y cmake g++ libmysqlcppconn-dev libssl-dev libboost-all-dev mysql-server
```

初始化数据库：

```bash
mysql -u root -p < sql/init.sql
```

准备配置：

```bash
cp config.example.json config.json
```

编辑 `config.json`，填写 MySQL 密码、JWT secret 和 AI API Key。

编译：

```bash
mkdir -p build
cd build
cmake ..
make -j$(nproc)
```

运行：

```bash
cp ../config.json .
./iha_server
```

默认监听 `0.0.0.0:8080`。

## API 测试

注册：

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"mobile":"13800138000","password":"123456","nickname":"测试用户"}'
```

登录：

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"mobile":"13800138000","password":"123456"}'
```

带 token 访问：

```bash
TOKEN="登录接口返回的 token"
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/health/dashboard
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/user/info
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/report/weekly
```

初始化演示数据：

```bash
curl -X POST -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/init-sample-data
```

## API 概览

| 端点 | 方法 | 状态 | 说明 |
|------|------|------|------|
| `/api/ping` | GET | 已实现 | 健康检查 |
| `/api/auth/register` | POST | 已实现 | 注册 |
| `/api/auth/login` | POST | 已实现 | 登录，返回 JWT |
| `/api/user/info` | GET/PUT | 已实现 | 用户信息读写 |
| `/api/health/data` | POST | 已实现 | 上报健康数据 |
| `/api/health/dashboard` | GET | 已实现 | 仪表盘数据 |
| `/api/health/recent` | GET | 已实现 | 最近健康记录 |
| `/api/report/weekly` | GET | 已实现 | AI 周报 |
| `/api/habits` | GET/POST | 已实现 | 习惯追踪 |
| `/api/badges` | GET | 已实现 | 徽章列表 |
| `/api/challenges` | GET | 已实现 | 活动挑战 |
| `/api/courses` | GET | 已实现 | 课程列表 |
| `/api/orders` | GET | 已实现 | 订单列表 |
| `/api/init-sample-data` | POST | 已实现 | 演示数据初始化 |
| `/api/device/*` | * | 501 stub | 设备接口预留 |
| `/api/authorization/*` | * | 501 stub | 授权接口预留 |
| `/api/consultation/*` | * | 501 stub | 问诊接口预留 |

## 目录结构

```text
backend/
├── CMakeLists.txt
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── config.example.json
├── config.docker.json
├── config.json              # 本地真实配置，不提交
├── deps/                    # 离线构建依赖压缩包
├── sql/init.sql             # MySQL 建表脚本
└── src/
    ├── main.cpp
    ├── config.h             # 配置结构体和 JSON 加载逻辑
    ├── database.h/cpp
    ├── jwt_util.h/cpp
    ├── password_util.h
    ├── middleware.h
    ├── routes.h
    ├── auth_routes.cpp
    ├── health_routes.cpp
    ├── user_routes.cpp
    ├── report_routes.cpp
    ├── feature_routes.cpp
    └── stub_routes.cpp
```

## 注意事项

- 不要提交 `.env` 和 `config.json`。
- 不要使用模板里的 `CHANGE_ME_*` 占位值直接部署生产环境。
- `jwt.secret` 应使用随机长字符串，泄露后需要重新生成并让用户重新登录。
- Docker 首次启动会根据 `sql/init.sql` 初始化数据库；已有 volume 时不会重复执行建表脚本。
- `docker compose down -v` 会删除 MySQL 数据卷，请谨慎使用。
- 如果 Docker build 无法访问网络，确认 `deps/` 下存在 Crow、jwt-cpp、spdlog、nlohmann/json、cpp-httplib 的 tar.gz 依赖包。

## 常见问题

- `set DB_PASSWORD in backend/.env`：说明没有创建 `.env`，先执行 `cp .env.example .env` 并填写密码。
- 数据库连接失败：检查 `.env` 和 `config.json` 里的密码是否一致。
- `cmake` 找不到 MySQL Connector：安装 `libmysqlcppconn-dev`。
- `curl /api/ping` 无响应：检查 `docker compose ps` 和 `docker compose logs -f server`。
