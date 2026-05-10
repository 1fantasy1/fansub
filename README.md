# fansub

极简 + 轻量 + 快速的一键代理节点部署脚本

## 特点

- 基于 **Sing-box + Xray** 双内核自动分配
- 支持 10 种代理协议任意组合
- 交互式终端安装，菜单引导选择协议和配置
- 所有代理协议无需域名，直连部署
- TLS 密钥本地生成，二进制从官方仓库下载

## 支持的协议

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

## 使用方式

```bash
bash <(curl -Ls https://raw.githubusercontent.com/1fantasy1/fansub/refs/heads/master/fansub.sh)
```

终端菜单引导选择协议、输入配置，自动完成安装。

## 可选变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `uuid` | UUID 密码 | 随机生成 |
| `reym` | Reality 域名 | apple.com |
| `hyjpt` | Hysteria2 端口跳跃 | 关闭 |
| `ippz` | IPv4/IPv6 导出（4 或 6） | 自动 |
| `name` | 节点名称前缀 | 默认协议名 |
| `oap` | 开放系统所有端口（y） | 关闭 |

## 快捷命令

首次安装后需重连 SSH 生效。

| 命令 | 功能 |
|------|------|
| `fsub list` | 查看节点信息 |
| `fsub rep` | 重置协议变量 |
| `fsub res` | 重启服务 |
| `fsub del` | 卸载 |
| `fsub upx` | 更新 Xray 内核 |
| `fsub ups` | 更新 Sing-box 内核 |


