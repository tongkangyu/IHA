FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    cmake g++ \
    libmysqlcppconn-dev libssl-dev libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY CMakeLists.txt .
COPY src/ src/
COPY deps/ deps/

RUN mkdir -p build && cd build && cmake .. && make -j$(nproc)

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmysqlcppconn7v5 libssl3 libboost-system1.74.0 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /build/build/iha_server .
COPY config.example.json .
COPY sql/ sql/

EXPOSE 8080

CMD ["./iha_server", "config.json"]
