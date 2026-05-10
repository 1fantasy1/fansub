# fansub 项目结构文档

## 项目概述

fansub 是一个一键无交互的代理节点部署脚本（"小钢炮脚本"），基于 **Sing-box + Xray** 双内核自动分配。支持在 Linux VPS 上部署多种代理协议节点。

当前版本：V26.5.10

---

## 目录结构

```
fansub/
├── fansub.sh              # 主脚本 - VPS 一键部署核心（含交互式安装模式）
├── README.md               # 项目主文档
├── PROJECT.md              # 项目结构文档（本文件）
├── LICENSE                 # MIT 开源许可证
└── .gitignore              # Git 忽略规则
```

---

## 核心组件详解

### 1. 主脚本 `fansub.sh`

VPS 环境的核心部署脚本。功能包括：

- **交互式安装**：直接运行 `bash fansub.sh` 进入终端菜单，选择协议和配置后自动安装
- **变量模式**：通过环境变量（如 `vlpt="" hypt="" bash fansub.sh`）直接指定协议和端口
- **内核下载**：自动从官方仓库下载 Xray 和 Sing-box 二进制文件到 `~/fsub/`
- **配置生成**：动态生成 Xray 的 `xr.json` 和 Sing-box 的 `sb.json` 配置文件
- **TLS 密钥**：本地生成 TLS 证书（要求系统安装 openssl）
- **节点输出**：生成各协议的分享链接，保存到 `~/fsub/jhsub.txt`
- **快捷命令**：安装后注册 `fsub` 快捷方式（list/rep/res/del/upx/ups）

**支持的代理协议（共 11 种）：**

| 协议 | 内核 | 传输 | 变量 |
|------|------|------|------|
| Vless-tcp-reality-vision | Xray | TCP | `vlpt` |
| Vless-xhttp-reality-enc | Xray | TCP | `xhpt` |
| Vless-xhttp-enc | Xray | TCP | `vxpt` |
| Vmess-ws | Xray/Sing-box | TCP | `vmpt` |
| Socks5 | Xray/Sing-box | TCP | `sopt` |
| Shadowsocks-2022 | Sing-box | TCP | `sspt` |
| AnyTLS | Sing-box | TCP | `anpt` |
| Any-Reality | Sing-box | TCP | `arpt` |
| Hysteria2 | Sing-box | UDP | `hypt` |
| Tuic | Sing-box | UDP | `tupt` |

**脚本执行流程：**
1. 解析环境变量，设置协议开关
2. 检测是否已安装（进程检查），决定安装/重置/查看等操作
3. 安装系统依赖（iptables、openssl、ca-certificates 等）
4. 检测 IPv4/IPv6 及虚拟化类型
5. 根据协议变量选择性安装 Xray 和/或 Sing-box 内核
6. 本地生成 TLS 密钥对
7. 生成对应 JSON 配置文件（出站均为 direct 直连）
8. 输出所有节点分享链接

---

## 运行时文件结构

脚本安装后在 `~/fsub/` 目录下生成以下运行时文件：

```
~/fsub/
├── sing-box          # Sing-box 二进制
├── xray              # Xray 二进制
├── sb.json           # Sing-box 配置
├── xr.json           # Xray 配置
├── uuid              # UUID 存储
├── jhsub.txt         # 聚合节点分享链接
├── server_ip.log     # 服务器 IP
├── private.key       # TLS 私钥（本地生成）
├── cert.pem          # TLS 证书（本地生成）
├── name              # 节点名称前缀
├── reym              # Reality 域名
├── sskey             # Shadowsocks 密钥
├── xrk/              # Xray 密钥目录
│   ├── private_key
│   ├── public_key
│   ├── short_id
│   ├── dekey         # Vless ENC 解密密钥
│   └── enkey         # Vless ENC 加密密钥
├── sbk/              # Sing-box 密钥目录
│   ├── private_key
│   ├── public_key
│   └── short_id
└── [协议端口文件]     # 如 vlpt, vmpt, hypt 等
```

---

## 技术栈

- **Shell 脚本**：POSIX sh / Bash，兼容 Alpine/Debian/Ubuntu
- **Xray**：代理内核，处理 Vless/Vmess/Socks5 等协议
- **Sing-box**：代理内核，处理 Hysteria2/Tuic/AnyTLS/Shadowsocks 等协议
- **HTML/CSS/JS**：命令生成器前端（纯静态，无框架）
