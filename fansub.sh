#!/bin/sh
export LANG=en_US.UTF-8
AGSBX_TMPFILE=$(mktemp /tmp/fsub.XXXXXX 2>/dev/null || echo "/tmp/fsub.$$")
trap 'rm -f "$AGSBX_TMPFILE"' EXIT INT TERM
case "$1" in list|del|res|rep|upx|ups|"") ;; *) echo "未知命令：$1"; exit 1 ;; esac
if [ "$1" != "list" ] && [ "$1" != "del" ] && [ "$1" != "res" ] && [ "$1" != "rep" ] && [ "$1" != "upx" ] && [ "$1" != "ups" ]; then
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "       fansub 交互安装"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "请选择要启用的协议（输入序号，多个用空格分隔）："
echo "  1) Vless-tcp-reality-vision    [Xray/TCP]"
echo "  2) Vless-xhttp-reality-enc     [Xray/TCP]"
echo "  3) Vless-xhttp-enc             [Xray/TCP]"
echo "  4) Vmess-ws                    [Xray|Sing-box/TCP]"
echo "  5) Socks5                      [Xray|Sing-box/TCP]"
echo "  6) Shadowsocks-2022            [Sing-box/TCP]"
echo "  7) AnyTLS                      [Sing-box/TCP]"
echo "  8) Any-Reality                 [Sing-box/TCP]"
echo "  9) Hysteria2                   [Sing-box/UDP]"
echo "  10) Tuic                       [Sing-box/UDP]"
echo ""
read -p "请输入序号: " proto_choices
[ -z "$proto_choices" ] && { echo "未选择任何协议，退出"; exit 0; }
for c in $proto_choices; do
case "$c" in
1) vlpt="" ;;
2) xhpt="" ;;
3) vxpt="" ;;
4) vmpt="" ;;
5) sopt="" ;;
6) sspt="" ;;
7) anpt="" ;;
8) arpt="" ;;
9) hypt="" ;;
10) tupt="" ;;
*) echo "忽略无效序号：$c" ;;
esac
done
selected=""
[ -n "${vlpt+x}" ] && selected="$selected Vless-tcp-reality-vision"
[ -n "${xhpt+x}" ] && selected="$selected Vless-xhttp-reality-enc"
[ -n "${vxpt+x}" ] && selected="$selected Vless-xhttp-enc"
[ -n "${vmpt+x}" ] && selected="$selected Vmess-ws"
[ -n "${sopt+x}" ] && selected="$selected Socks5"
[ -n "${sspt+x}" ] && selected="$selected Shadowsocks-2022"
[ -n "${anpt+x}" ] && selected="$selected AnyTLS"
[ -n "${arpt+x}" ] && selected="$selected Any-Reality"
[ -n "${hypt+x}" ] && selected="$selected Hysteria2"
[ -n "${tupt+x}" ] && selected="$selected Tuic"
echo ""
echo "--- 已选择：$selected ---"
echo ""
echo "=== 可选设置（直接回车跳过） ==="
echo ""
if [ -n "${vlpt+x}" ] || [ -n "${xhpt+x}" ]; then
read -p "Reality域名（留空默认apple.com）: " input_reym
[ -n "$input_reym" ] && reym="$input_reym"
fi
if [ -n "${hypt+x}" ]; then
read -p "Hysteria2端口跳跃（例：123:456 789，留空关闭）: " input_hyjpt
[ -n "$input_hyjpt" ] && hyjpt="$input_hyjpt"
fi
read -p "UUID密码（留空随机生成）: " input_uuid
[ -n "$input_uuid" ] && uuid="$input_uuid"
read -p "节点名称前缀: " input_name
[ -n "$input_name" ] && name="$input_name"
read -p "绑定域名（留空使用IP地址）: " input_dom
[ -n "$input_dom" ] && dom="$input_dom"
read -p "开放脚本所需端口（y开启，留空关闭）: " input_oap
[ -n "$input_oap" ] && oap="$input_oap"
read -p "启用订阅链接（y开启，留空关闭）: " input_sub
[ -n "$input_sub" ] && sub="$input_sub"
if [ "$sub" = "y" ]; then
read -p "订阅链接密码（留空默认uuid路径）: " input_subid
[ -n "$input_subid" ] && subid="$input_subid"
read -p "订阅链接端口（留空随机）: " input_subpt
[ -n "$input_subpt" ] && subpt="$input_subpt"
fi
echo ""
echo "=== 开始安装 ==="
echo ""
[ -z "${vlpt+x}" ] || vlp=yes
[ -z "${vmpt+x}" ] || { vmp=yes; vmag=yes; }
[ -z "${hypt+x}" ] || hyp=yes
[ -z "${tupt+x}" ] || tup=yes
[ -z "${xhpt+x}" ] || xhp=yes
[ -z "${vxpt+x}" ] || vxp=yes
[ -z "${anpt+x}" ] || anp=yes
[ -z "${sspt+x}" ] || ssp=yes
[ -z "${arpt+x}" ] || arp=yes
[ -z "${sopt+x}" ] || sop=yes
fi
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'fsub/(s|x)' || pgrep -f 'fsub/(s|x)' >/dev/null 2>&1; then
:
else
[ "$1" = "del" ] || [ "$sop" = yes ] || [ "$vxp" = yes ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：未安装fansub脚本，请先选择协议进行安装，再见！💣"; exit; }
fi
export uuid=${uuid:-''}
export port_vl_re=${vlpt:-''}
export port_vm_ws=${vmpt:-''}
export port_hy2=${hypt:-''}
export port_tu=${tupt:-''}
export port_xh=${xhpt:-''}
export port_vx=${vxpt:-''}
export port_an=${anpt:-''}
export port_ar=${arpt:-''}
export port_ss=${sspt:-''}
export port_so=${sopt:-''}
export ym_vl_re=${reym:-''}
export dom=${dom:-''}
export name=${name:-''}
export oap=${oap:-''}
v46url="https://icanhazip.com"
showmode(){
echo "fansub脚本一键命令生器在线网址：https://YOUR_GITHUB_USER.github.io/fansub/"
echo "主脚本：bash <(curl -Ls https://raw.githubusercontent.com/YOUR_GITHUB_USER/fansub/main/fansub.sh) 或 bash <(wget -qO- https://raw.githubusercontent.com/YOUR_GITHUB_USER/fansub/main/fansub.sh)"
echo "显示节点信息命令：fsub list 【或者】 主脚本 list"
echo "重置协议命令：fsub rep 【或者】 主脚本 rep"
echo "更新脚本命令：主脚本 rep"
echo "更新Xray或Singbox内核命令：fsub upx或ups 【或者】 主脚本 upx或ups"
echo "重启脚本命令：fsub res 【或者】 主脚本 res"
echo "卸载脚本命令：fsub del 【或者】 主脚本 del"
echo "---------------------------------------------------------"
echo
}
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Github项目 ：github.com/YOUR_GITHUB_USER"
echo "fansub一键小钢炮脚本💣"
echo "当前版本：V26.5.10"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[ -z "$(systemd-detect-virt 2>/dev/null)" ] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
arm64|aarch64) cpu=arm64;;
amd64|x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
if [ "$1" != "del" ]; then
mkdir -p "$HOME/fsub"
if [ ! -f sbx_update ]; then
echo "执行必要的脚本依赖中，请稍等10秒……"
if command -v apk >/dev/null 2>&1; then
apk update >/dev/null 2>&1 && apk add --no-cache bash busybox-extras gcompat libc6-compat iptables openssl unzip ca-certificates >/dev/null 2>&1
elif command -v apt >/dev/null 2>&1; then
export DEBIAN_FRONTEND=noninteractive
printf 'iptables-persistent iptables-persistent/autosave_v4 boolean true\niptables-persistent iptables-persistent/autosave_v6 boolean true\n' | debconf-set-selections
apt update >/dev/null 2>&1 && apt install -y busybox coreutils util-linux iptables iptables-persistent openssl unzip ca-certificates >/dev/null 2>&1
fi
touch sbx_update
fi
fi
v4v6(){
v4=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- "$v46url" 2>/dev/null) )
v6=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- "$v46url" 2>/dev/null) )
v4dq=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 https://myip.ipip.net/ | awk -F'来自于：' '{print $2}' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- https://myip.ipip.net/ | awk -F'来自于：' '{print $2}' 2>/dev/null) )
v6dq=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 https://ip.fm | sed -n 's/.*Location: //p' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- https://ip.fm | grep '<span class="has-text-grey-light">Location:' | tail -n1 | sed -E 's/.*>Location: <\/span>([^<]+)<.*/\1/' 2>/dev/null) )
}
initcfg(){
if [ -n "$name" ]; then
sxname=$name-
echo "$sxname" > "$HOME/fsub/name"
echo
echo "所有节点名称前缀：$name"
fi
v4v6
}
upxray(){
xver=$( (command -v curl >/dev/null 2>&1 && curl -sL https://api.github.com/repos/XTLS/Xray-core/releases/latest | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p') || (command -v wget >/dev/null 2>&1 && wget -qO- https://api.github.com/repos/XTLS/Xray-core/releases/latest | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p') )
[ -z "$xver" ] && { echo "错误：无法获取 Xray 最新版本号"; exit 1; }
url="https://github.com/XTLS/Xray-core/releases/download/${xver}/Xray-linux-${cpu}.zip"
out="/tmp/xray-linux-${cpu}.zip"
(command -v curl >/dev/null 2>&1 && curl -Lo "$out" -# --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -O "$out" --tries=2 "$url")
[ -f "$out" ] || { echo "错误：Xray 下载失败"; exit 1; }
echo "Xray 下载完成，SHA256："
sha256sum "$out" 2>/dev/null || shasum -a 256 "$out" 2>/dev/null || echo "（无法计算哈希，请手动校验）"
unzip -o "$out" -d "$HOME/fsub/" 2>&1
[ -f "$HOME/fsub/xray" ] || { echo "错误：Xray 解压失败，请检查 unzip 是否已安装"; rm -f "$out"; exit 1; }
chmod +x "$HOME/fsub/xray"
rm -f "$out"
sbcore=$("$HOME/fsub/xray" version 2>/dev/null | awk '/^Xray/{print $2}')
echo "已安装Xray官方版内核：$sbcore"
}
upsingbox(){
sver=$( (command -v curl >/dev/null 2>&1 && curl -sL https://api.github.com/repos/SagerNet/sing-box/releases/latest | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p') || (command -v wget >/dev/null 2>&1 && wget -qO- https://api.github.com/repos/SagerNet/sing-box/releases/latest | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p') )
[ -z "$sver" ] && { echo "错误：无法获取 Sing-box 最新版本号"; exit 1; }
url="https://github.com/SagerNet/sing-box/releases/download/${sver}/sing-box-${sver#v}-linux-${cpu}.tar.gz"
out="/tmp/sing-box-linux-${cpu}.tar.gz"
(command -v curl>/dev/null 2>&1 && curl -Lo "$out" -# --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && timeout 3 wget -O "$out" --tries=2 "$url")
[ -f "$out" ] || { echo "错误：Sing-box 下载失败"; exit 1; }
echo "Sing-box 下载完成，SHA256："
sha256sum "$out" 2>/dev/null || shasum -a 256 "$out" 2>/dev/null || echo "（无法计算哈希，请手动校验）"
tar -xzf "$out" -C /tmp/ 2>&1
cp -f /tmp/sing-box-${sver#v}-linux-${cpu}/sing-box "$HOME/fsub/sing-box" 2>&1
[ -f "$HOME/fsub/sing-box" ] || { echo "错误：Sing-box 解压失败，请检查 tar 是否已安装"; rm -f "$out"; rm -rf "/tmp/sing-box-${sver#v}-linux-${cpu}"; exit 1; }
chmod +x "$HOME/fsub/sing-box"
rm -f "$out"
rm -rf "/tmp/sing-box-${sver#v}-linux-${cpu}"
sbcore=$("$HOME/fsub/sing-box" version 2>/dev/null | awk '/version/{print $NF}')
echo "已安装Sing-box正式版内核：$sbcore"
}
insuuid(){
if [ -z "$uuid" ] && [ ! -e "$HOME/fsub/uuid" ]; then
if [ -e "$HOME/fsub/sing-box" ]; then
uuid=$("$HOME/fsub/sing-box" generate uuid)
else
uuid=$("$HOME/fsub/xray" uuid)
fi
echo "$uuid" > "$HOME/fsub/uuid"
elif [ -n "$uuid" ]; then
echo "$uuid" > "$HOME/fsub/uuid"
fi
uuid=$(cat "$HOME/fsub/uuid")
echo "UUID已设置"
}
installxray(){
echo
echo "=========启用xray内核========="
mkdir -p "$HOME/fsub/xrk"
if [ ! -e "$HOME/fsub/xray" ]; then
upxray
fi
cat > "$HOME/fsub/xr.json" <<EOF
{
  "log": {
  "loglevel": "none"
  },
  "inbounds": [
EOF
insuuid
if [ -n "$xhp" ] || [ -n "$vlp" ]; then
if [ -z "$ym_vl_re" ]; then
ym_vl_re=apple.com
fi
echo "$ym_vl_re" > "$HOME/fsub/ym_vl_re"
echo "Reality域名：$ym_vl_re"
if [ ! -e "$HOME/fsub/xrk/private_key" ]; then
key_pair=$("$HOME/fsub/xray" x25519)
private_key=$(echo "$key_pair" | awk -F':' '/PrivateKey/ {print $2}' | xargs)
public_key=$(echo "$key_pair" | awk -F':' '/Password/ {print $2}' | xargs)
short_id=$(date +%s%N | sha256sum | cut -c 1-8)
echo "$private_key" > "$HOME/fsub/xrk/private_key"
echo "$public_key" > "$HOME/fsub/xrk/public_key"
echo "$short_id" > "$HOME/fsub/xrk/short_id"
fi
private_key_x=$(cat "$HOME/fsub/xrk/private_key")
public_key_x=$(cat "$HOME/fsub/xrk/public_key")
short_id_x=$(cat "$HOME/fsub/xrk/short_id")
fi
if [ -n "$xhp" ] || [ -n "$vxp" ]; then
if [ ! -e "$HOME/fsub/xrk/dekey" ]; then
dekey=$(openssl rand -base64 32)
enkey=$(openssl rand -base64 32)
echo "$dekey" > "$HOME/fsub/xrk/dekey"
echo "$enkey" > "$HOME/fsub/xrk/enkey"
fi
dekey=$(cat "$HOME/fsub/xrk/dekey")
enkey=$(cat "$HOME/fsub/xrk/enkey")
fi

if [ -n "$xhp" ]; then
xhp=xhpt
if [ -z "$port_xh" ] && [ ! -e "$HOME/fsub/port_xh" ]; then
port_xh=$(shuf -i 10000-65535 -n 1)
echo "$port_xh" > "$HOME/fsub/port_xh"
elif [ -n "$port_xh" ]; then
echo "$port_xh" > "$HOME/fsub/port_xh"
fi
port_xh=$(cat "$HOME/fsub/port_xh")
echo "Vless-xhttp-reality-enc端口：$port_xh"
cat >> "$HOME/fsub/xr.json" <<EOF
    {
      "tag":"xhttp-reality",
      "listen": "::",
      "port": ${port_xh},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "reality",
        "realitySettings": {
          "fingerprint": "chrome",
          "target": "${ym_vl_re}:443",
          "serverNames": [
            "${ym_vl_re}"
          ],
          "privateKey": "$private_key_x",
          "shortIds": ["$short_id_x"]
        },
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-xh",
          "mode": "auto"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
xhp=xhptpt
fi
if [ -n "$vxp" ]; then
vxp=vxpt
if [ -z "$port_vx" ] && [ ! -e "$HOME/fsub/port_vx" ]; then
port_vx=$(shuf -i 10000-65535 -n 1)
echo "$port_vx" > "$HOME/fsub/port_vx"
elif [ -n "$port_vx" ]; then
echo "$port_vx" > "$HOME/fsub/port_vx"
fi
port_vx=$(cat "$HOME/fsub/port_vx")
echo "Vless-xhttp-enc端口：$port_vx"
cat >> "$HOME/fsub/xr.json" <<EOF
    {
      "tag":"vless-xhttp",
      "listen": "::",
      "port": ${port_vx},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-vx",
          "mode": "auto"
        }
      },
        "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
vxp=vxptpt
fi
if [ -n "$vlp" ]; then
vlp=vlpt
if [ -z "$port_vl_re" ] && [ ! -e "$HOME/fsub/port_vl_re" ]; then
port_vl_re=$(shuf -i 10000-65535 -n 1)
echo "$port_vl_re" > "$HOME/fsub/port_vl_re"
elif [ -n "$port_vl_re" ]; then
echo "$port_vl_re" > "$HOME/fsub/port_vl_re"
fi
port_vl_re=$(cat "$HOME/fsub/port_vl_re")
echo "Vless-tcp-reality-v端口：$port_vl_re"
cat >> "$HOME/fsub/xr.json" <<EOF
        {
            "tag":"reality-vision",
            "listen": "::",
            "port": $port_vl_re,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "flow": "xtls-rprx-vision"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "fingerprint": "chrome",
                    "dest": "${ym_vl_re}:443",
                    "serverNames": [
                      "${ym_vl_re}"
                    ],
                    "privateKey": "$private_key_x",
                    "shortIds": ["$short_id_x"]
                }
            },
          "sniffing": {
          "enabled": true,
          "destOverride": ["http", "tls", "quic"],
          "metadataOnly": false
      }
    },  
EOF
else
vlp=vlptpt
fi
}

installsb(){
echo
echo "=========启用Sing-box内核========="
if [ ! -e "$HOME/fsub/sing-box" ]; then
upsingbox
fi
cat > "$HOME/fsub/sb.json" <<EOF
{
"log": {
    "disabled": false,
    "level": "warn",
    "timestamp": true
  },
  "inbounds": [
EOF
insuuid
if ! command -v openssl >/dev/null 2>&1; then
echo "openssl 未安装，尝试自动安装..."
if command -v apk >/dev/null 2>&1; then
apk add --no-cache openssl >/dev/null 2>&1
elif command -v apt >/dev/null 2>&1; then
apt-get update >/dev/null 2>&1 && apt-get install -y openssl >/dev/null 2>&1
fi
command -v openssl >/dev/null 2>&1 || { echo "错误：openssl 安装失败，请手动安装"; exit 1; }
fi
openssl ecparam -genkey -name prime256v1 -out "$HOME/fsub/private.key" 2>/dev/null || { echo "错误：TLS 私钥生成失败"; exit 1; }
openssl req -new -x509 -days 36500 -key "$HOME/fsub/private.key" -out "$HOME/fsub/cert.pem" -subj "/CN=www.bing.com" 2>/dev/null || { echo "错误：TLS 证书生成失败"; exit 1; }
if [ -n "$hyp" ]; then
hyp=hypt
if [ -z "$port_hy2" ] && [ ! -e "$HOME/fsub/port_hy2" ]; then
port_hy2=$(shuf -i 10000-65535 -n 1)
echo "$port_hy2" > "$HOME/fsub/port_hy2"
elif [ -n "$port_hy2" ]; then
echo "$port_hy2" > "$HOME/fsub/port_hy2"
fi
port_hy2=$(cat "$HOME/fsub/port_hy2")
echo "Hysteria2端口：$port_hy2"
cat >> "$HOME/fsub/sb.json" <<EOF
    {
        "type": "hysteria2",
        "tag": "hy2-sb",
        "listen": "::",
        "listen_port": ${port_hy2},
        "users": [
            {
                "password": "${uuid}"
            }
        ],
        "ignore_client_bandwidth":false,
        "tls": {
            "enabled": true,
            "alpn": [
                "h3"
            ],
            "certificate_path": "$HOME/fsub/cert.pem",
            "key_path": "$HOME/fsub/private.key"
        }
    },
EOF
else
hyp=hyptpt
fi
if [ -n "$tup" ]; then
tup=tupt
if [ -z "$port_tu" ] && [ ! -e "$HOME/fsub/port_tu" ]; then
port_tu=$(shuf -i 10000-65535 -n 1)
echo "$port_tu" > "$HOME/fsub/port_tu"
elif [ -n "$port_tu" ]; then
echo "$port_tu" > "$HOME/fsub/port_tu"
fi
port_tu=$(cat "$HOME/fsub/port_tu")
echo "Tuic端口：$port_tu"
cat >> "$HOME/fsub/sb.json" <<EOF
        {
            "type":"tuic",
            "tag": "tuic5-sb",
            "listen": "::",
            "listen_port": ${port_tu},
            "users": [
                {
                    "uuid": "${uuid}",
                    "password": "${uuid}"
                }
            ],
            "congestion_control": "bbr",
            "tls":{
                "enabled": true,
                "alpn": [
                    "h3"
                ],
                "certificate_path": "$HOME/fsub/cert.pem",
                "key_path": "$HOME/fsub/private.key"
            }
        },
EOF
else
tup=tuptpt
fi
if [ -n "$anp" ]; then
anp=anpt
if [ -z "$port_an" ] && [ ! -e "$HOME/fsub/port_an" ]; then
port_an=$(shuf -i 10000-65535 -n 1)
echo "$port_an" > "$HOME/fsub/port_an"
elif [ -n "$port_an" ]; then
echo "$port_an" > "$HOME/fsub/port_an"
fi
port_an=$(cat "$HOME/fsub/port_an")
echo "Anytls端口：$port_an"
cat >> "$HOME/fsub/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anytls-sb",
            "listen":"::",
            "listen_port":${port_an},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls":{
                "enabled": true,
                "certificate_path": "$HOME/fsub/cert.pem",
                "key_path": "$HOME/fsub/private.key"
            }
        },
EOF
else
anp=anptpt
fi
if [ -n "$arp" ]; then
arp=arpt
if [ -z "$ym_vl_re" ]; then
ym_vl_re=apple.com
fi
echo "$ym_vl_re" > "$HOME/fsub/ym_vl_re"
echo "Reality域名：$ym_vl_re"
mkdir -p "$HOME/fsub/sbk"
if [ ! -e "$HOME/fsub/sbk/private_key" ]; then
key_pair=$("$HOME/fsub/sing-box" generate reality-keypair)
private_key=$(echo "$key_pair" | awk '/PrivateKey/ {print $2}' | tr -d '"')
public_key=$(echo "$key_pair" | awk '/PublicKey/ {print $2}' | tr -d '"')
short_id=$("$HOME/fsub/sing-box" generate rand --hex 4)
echo "$private_key" > "$HOME/fsub/sbk/private_key"
echo "$public_key" > "$HOME/fsub/sbk/public_key"
echo "$short_id" > "$HOME/fsub/sbk/short_id"
fi
private_key_s=$(cat "$HOME/fsub/sbk/private_key")
public_key_s=$(cat "$HOME/fsub/sbk/public_key")
short_id_s=$(cat "$HOME/fsub/sbk/short_id")
if [ -z "$port_ar" ] && [ ! -e "$HOME/fsub/port_ar" ]; then
port_ar=$(shuf -i 10000-65535 -n 1)
echo "$port_ar" > "$HOME/fsub/port_ar"
elif [ -n "$port_ar" ]; then
echo "$port_ar" > "$HOME/fsub/port_ar"
fi
port_ar=$(cat "$HOME/fsub/port_ar")
echo "Any-Reality端口：$port_ar"
cat >> "$HOME/fsub/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anyreality-sb",
            "listen":"::",
            "listen_port":${port_ar},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls": {
            "enabled": true,
            "server_name": "${ym_vl_re}",
             "reality": {
              "enabled": true,
              "handshake": {
              "server": "${ym_vl_re}",
              "server_port": 443
             },
             "private_key": "$private_key_s",
             "short_id": ["$short_id_s"]
            }
          }
        },
EOF
else
arp=arptpt
fi
if [ -n "$ssp" ]; then
ssp=sspt
if [ ! -e "$HOME/fsub/sskey" ]; then
sskey=$("$HOME/fsub/sing-box" generate rand 16 --base64)
echo "$sskey" > "$HOME/fsub/sskey"
fi
if [ -z "$port_ss" ] && [ ! -e "$HOME/fsub/port_ss" ]; then
port_ss=$(shuf -i 10000-65535 -n 1)
echo "$port_ss" > "$HOME/fsub/port_ss"
elif [ -n "$port_ss" ]; then
echo "$port_ss" > "$HOME/fsub/port_ss"
fi
sskey=$(cat "$HOME/fsub/sskey")
port_ss=$(cat "$HOME/fsub/port_ss")
echo "Shadowsocks-2022端口：$port_ss"
cat >> "$HOME/fsub/sb.json" <<EOF
        {
            "type": "shadowsocks",
            "tag":"ss-2022",
            "listen": "::",
            "listen_port": $port_ss,
            "method": "2022-blake3-aes-128-gcm",
            "password": "$sskey"
    },  
EOF
else
ssp=ssptpt
fi
}

xrsbvm(){
if [ -n "$vmp" ]; then
vmp=vmpt
if [ -z "$port_vm_ws" ] && [ ! -e "$HOME/fsub/port_vm_ws" ]; then
port_vm_ws=$(shuf -i 10000-65535 -n 1)
echo "$port_vm_ws" > "$HOME/fsub/port_vm_ws"
elif [ -n "$port_vm_ws" ]; then
echo "$port_vm_ws" > "$HOME/fsub/port_vm_ws"
fi
port_vm_ws=$(cat "$HOME/fsub/port_vm_ws")
echo "Vmess-ws端口：$port_vm_ws"
if [ -e "$HOME/fsub/xr.json" ]; then
cat >> "$HOME/fsub/xr.json" <<EOF
        {
            "tag": "vmess-xr",
            "listen": "::",
            "port": ${port_vm_ws},
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                  "path": "${uuid}-vm"
            }
        },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/fsub/sb.json" <<EOF
{
        "type": "vmess",
        "tag": "vmess-sb",
        "listen": "::",
        "listen_port": ${port_vm_ws},
        "users": [
            {
                "uuid": "${uuid}",
                "alterId": 0
            }
        ],
        "transport": {
            "type": "ws",
            "path": "${uuid}-vm",
            "max_early_data":2048,
            "early_data_header_name": "Sec-WebSocket-Protocol"
        }
    },
EOF
fi
else
vmp=vmptpt
fi
}

xrsbso(){
if [ -n "$sop" ]; then
sop=sopt
if [ -z "$port_so" ] && [ ! -e "$HOME/fsub/port_so" ]; then
port_so=$(shuf -i 10000-65535 -n 1)
echo "$port_so" > "$HOME/fsub/port_so"
elif [ -n "$port_so" ]; then
echo "$port_so" > "$HOME/fsub/port_so"
fi
port_so=$(cat "$HOME/fsub/port_so")
echo "Socks5端口：$port_so"
if [ -e "$HOME/fsub/xr.json" ]; then
cat >> "$HOME/fsub/xr.json" <<EOF
        {
         "tag": "socks5-xr",
         "port": ${port_so},
         "listen": "::",
         "protocol": "socks",
         "settings": {
            "auth": "password",
             "accounts": [
               {
               "user": "${uuid}",
               "pass": "${uuid}"
               }
            ],
            "udp": true
          },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/fsub/sb.json" <<EOF
    {
      "tag": "socks5-sb",
      "type": "socks",
      "listen": "::",
      "listen_port": ${port_so},
      "users": [
      {
      "username": "${uuid}",
      "password": "${uuid}"
      }
     ]
    },
EOF
fi
else
sop=soptpt
fi
}

xrsbout(){
if [ -e "$HOME/fsub/xr.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/fsub/xr.json"
cat >> "$HOME/fsub/xr.json" <<EOF
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    }
  ]
}
EOF
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/xr.service <<EOF
[Unit]
Description=xr service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=$HOME/fsub/xray run -c $HOME/fsub/xr.json
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable xr >/dev/null 2>&1
systemctl start xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/xray <<EOF
#!/sbin/openrc-run
description="xr service"
command="$HOME/fsub/xray"
command_args="run -c $HOME/fsub/xr.json"
command_background=yes
pidfile="/run/xray.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/xray >/dev/null 2>&1
rc-update add xray default >/dev/null 2>&1
rc-service xray start >/dev/null 2>&1
else
nohup "$HOME/fsub/xray" run -c "$HOME/fsub/xr.json" >/dev/null 2>&1 &
fi
fi
if [ -e "$HOME/fsub/sb.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/fsub/sb.json"
cat >> "$HOME/fsub/sb.json" <<EOF
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "route": {
    "final": "direct"
  }
}
EOF
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/sb.service <<EOF
[Unit]
Description=sb service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=$HOME/fsub/sing-box run -c $HOME/fsub/sb.json
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable sb >/dev/null 2>&1
systemctl start sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/sing-box <<EOF
#!/sbin/openrc-run
description="sb service"
command="$HOME/fsub/sing-box"
command_args="run -c $HOME/fsub/sb.json"
command_background=yes
pidfile="/run/sing-box.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/sing-box >/dev/null 2>&1
rc-update add sing-box default >/dev/null 2>&1
rc-service sing-box start >/dev/null 2>&1
else
nohup "$HOME/fsub/sing-box" run -c "$HOME/fsub/sb.json" >/dev/null 2>&1 &
fi
fi
}
ins(){
if [ "$hyp" != yes ] && [ "$tup" != yes ] && [ "$anp" != yes ] && [ "$arp" != yes ] && [ "$ssp" != yes ]; then
installxray
xrsbvm
xrsbso
initcfg
xrsbout
hyp="hyptpt"; tup="tuptpt"; anp="anptpt"; arp="arptpt"; ssp="ssptpt"
elif [ "$xhp" != yes ] && [ "$vlp" != yes ] && [ "$vxp" != yes ]; then
installsb
xrsbvm
xrsbso
initcfg
xrsbout
xhp="xhptpt"; vlp="vlptpt"; vxp="vxptpt"
else
installsb
installxray
xrsbvm
xrsbso
initcfg
xrsbout
fi
sleep 5
echo
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'fsub/(s|x)' || pgrep -f 'fsub/(s|x)' >/dev/null 2>&1 ; then
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/fsub/d' ~/.bashrc
SCRIPT_PATH="$HOME/bin/fsub"
mkdir -p "$HOME/bin"
cp "$0" "$SCRIPT_PATH" 2>/dev/null || cp "$HOME/fsub/fansub.sh" "$SCRIPT_PATH" 2>/dev/null
chmod +x "$SCRIPT_PATH"
if ! grep -q '$HOME/bin' ~/.bashrc 2>/dev/null; then
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi
echo "提示：fsub 快捷命令已创建，首次安装后需重连SSH生效"
crontab -l > $AGSBX_TMPFILE 2>/dev/null
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
sed -i '/fsub\/sing-box/d' $AGSBX_TMPFILE
sed -i '/fsub\/xray/d' $AGSBX_TMPFILE
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'fsub/s' || pgrep -f 'fsub/s' >/dev/null 2>&1 ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/fsub/sing-box run -c $HOME/fsub/sb.json >/dev/null 2>&1 &"' >> $AGSBX_TMPFILE
fi
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'fsub/x' || pgrep -f 'fsub/x' >/dev/null 2>&1 ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/fsub/xray run -c $HOME/fsub/xr.json >/dev/null 2>&1 &"' >> $AGSBX_TMPFILE
fi
fi
crontab $AGSBX_TMPFILE >/dev/null 2>&1
rm $AGSBX_TMPFILE
echo "fansub脚本进程启动成功，安装完毕" && sleep 2
else
echo "fansub脚本进程未启动，安装失败" && exit
fi
}
fansubstatus(){
echo "=========当前内核运行状态========="
procs=$(find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null)
if echo "$procs" | grep -Eq 'fsub/s' || pgrep -f 'fsub/s' >/dev/null 2>&1; then
echo "Sing-box (版本V$("$HOME/fsub/sing-box" version 2>/dev/null | awk '/version/{print $NF}'))：运行中"
else
echo "Sing-box：未启用"
fi
if echo "$procs" | grep -Eq 'fsub/x' || pgrep -f 'fsub/x' >/dev/null 2>&1; then
echo "Xray (版本V$("$HOME/fsub/xray" version 2>/dev/null | awk '/^Xray/{print $2}'))：运行中"
else
echo "Xray：未启用"
fi
}
cip(){
ipbest(){
serip=$( (command -v curl >/dev/null 2>&1 && (curl -s4m5 "$v46url" 2>/dev/null || curl -s6m5 "$v46url" 2>/dev/null) ) || (command -v wget >/dev/null 2>&1 && (timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null || timeout 3 wget -6 -qO- --tries=2 "$v46url" 2>/dev/null) ) )
if echo "$serip" | grep -q ':'; then
server_ip="[$serip]"
echo "$server_ip" > "$HOME/fsub/server_ip.log"
else
server_ip="$serip"
echo "$server_ip" > "$HOME/fsub/server_ip.log"
fi
}
ipchange(){
v4v6
if [ -z "$v4" ]; then
vps_ipv4='无IPV4'
vps_ipv6="$v6"
location="$v6dq"
elif [ -n "$v4" ] && [ -n "$v6" ]; then
vps_ipv4="$v4"
vps_ipv6="$v6"
location="$v4dq"
else
vps_ipv4="$v4"
vps_ipv6='无IPV6'
location="$v4dq"
fi
echo
fansubstatus
echo
echo "=========当前服务器本地IP情况========="
echo "本地IPV4地址：$vps_ipv4"
echo "本地IPV6地址：$vps_ipv6"
echo "服务器地区：$location"
echo
sleep 2
ipbest
if [ -n "$dom" ]; then
server_ip="$dom"
echo "$server_ip" > "$HOME/fsub/server_ip.log"
fi
}
ipchange
rm -rf "$HOME/fsub/jhsub.txt"
uuid=$(cat "$HOME/fsub/uuid")
server_ip=$(cat "$HOME/fsub/server_ip.log")
sxname=$(cat "$HOME/fsub/name" 2>/dev/null)
chmod 600 "$HOME/fsub/uuid" "$HOME/fsub/private.key" "$HOME/fsub/cert.pem" "$HOME/fsub/sskey" "$HOME/fsub/jhsub.txt" 2>/dev/null
chmod 600 "$HOME/fsub/xrk/"* "$HOME/fsub/sbk/"* 2>/dev/null
chmod 600 "$HOME/fsub/"*.log 2>/dev/null
echo "*********************************************************"
echo "*********************************************************"
echo "fansub脚本输出节点配置如下："
echo
ym_vl_re=$(cat "$HOME/fsub/ym_vl_re" 2>/dev/null)
if [ -e "$HOME/fsub/xray" ]; then
private_key_x=$(cat "$HOME/fsub/xrk/private_key" 2>/dev/null)
public_key_x=$(cat "$HOME/fsub/xrk/public_key" 2>/dev/null)
short_id_x=$(cat "$HOME/fsub/xrk/short_id" 2>/dev/null)
enkey=$(cat "$HOME/fsub/xrk/enkey" 2>/dev/null)
fi
if [ -e "$HOME/fsub/sing-box" ]; then
private_key_s=$(cat "$HOME/fsub/sbk/private_key" 2>/dev/null)
public_key_s=$(cat "$HOME/fsub/sbk/public_key" 2>/dev/null)
short_id_s=$(cat "$HOME/fsub/sbk/short_id" 2>/dev/null)
sskey=$(cat "$HOME/fsub/sskey" 2>/dev/null)
fi
if grep xhttp-reality "$HOME/fsub/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-reality-enc 】支持ENC加密，节点信息如下："
port_xh=$(cat "$HOME/fsub/port_xh")
vl_xh_link="vless://$uuid@$server_ip:$port_xh?encryption=$enkey&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=xhttp&path=$uuid-xh&mode=auto#${sxname}vl-xhttp-reality-enc-$hostname"
echo "$vl_xh_link" >> "$HOME/fsub/jhsub.txt"
echo "$vl_xh_link"
echo
fi
if grep vless-xhttp "$HOME/fsub/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-xhttp-enc 】支持ENC加密，节点信息如下："
port_vx=$(cat "$HOME/fsub/port_vx")
vl_vx_link="vless://$uuid@$server_ip:$port_vx?encryption=$enkey&flow=xtls-rprx-vision&type=xhttp&path=$uuid-vx&mode=auto#${sxname}vl-xhttp-enc-$hostname"
echo "$vl_vx_link" >> "$HOME/fsub/jhsub.txt"
echo "$vl_vx_link"
echo
fi
if grep reality-vision "$HOME/fsub/xr.json" >/dev/null 2>&1; then
echo "💣【 Vless-tcp-reality-vision 】节点信息如下："
port_vl_re=$(cat "$HOME/fsub/port_vl_re")
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=tcp&headerType=none#${sxname}vl-reality-vision-$hostname"
echo "$vl_link" >> "$HOME/fsub/jhsub.txt"
echo "$vl_link"
echo
sbvlpt(){
cat <<EOF
    {
      "type": "vless",
      "tag": "${sxname}vless-$hostname",
      "server": "$server_ip",
      "server_port": $port_vl_re,
      "uuid": "$uuid",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$public_key_x",
          "short_id": "$short_id_x"
        }
      }
    },
EOF
}
sbvlpt1(){
echo "\"${sxname}vless-$hostname\","
}
clvlpt(){
cat <<EOF
- name: ${sxname}vless-reality-vision-$hostname               
  type: vless
  server: $server_ip                          
  port: $port_vl_re                                
  uuid: $uuid   
  network: tcp
  udp: true
  tls: true
  flow: xtls-rprx-vision
  servername: $ym_vl_re                 
  reality-opts: 
    public-key: $public_key_x    
    short-id: $short_id_x                      
  client-fingerprint: chrome
EOF
}
clvlpt1(){
echo "- ${sxname}vless-reality-vision-$hostname"
}
fi
if grep ss-2022 "$HOME/fsub/sb.json" >/dev/null 2>&1; then
echo "💣【 Shadowsocks-2022 】节点信息如下："
port_ss=$(cat "$HOME/fsub/port_ss")
ss_link="ss://$(echo -n "2022-blake3-aes-128-gcm:$sskey@$server_ip:$port_ss" | base64 -w0)#${sxname}Shadowsocks-2022-$hostname"
echo "$ss_link" >> "$HOME/fsub/jhsub.txt"
echo "$ss_link"
echo
sbsspt(){
cat <<EOF
{
       "type": "shadowsocks",
       "tag": "${sxname}Shadowsocks-2022-$hostname",
       "server": "$server_ip",
       "server_port": $port_ss,
       "method": "2022-blake3-aes-128-gcm",
       "password": "$sskey",
       "udp_over_tcp": {
        "enabled": true,
        "version": 2
      }
     },
EOF
}
sbsspt1(){
echo "\"${sxname}Shadowsocks-2022-$hostname\","
}
clsspt(){
cat <<EOF
- name: "${sxname}Shadowsocks-2022-$hostname"
  type: ss
  server: $server_ip
  port: $port_ss
  cipher: 2022-blake3-aes-128-gcm
  password: "$sskey"
  udp: true
  udp-over-tcp: true
  udp-over-tcp-version: 2
EOF
}
clsspt1(){
echo "- ${sxname}Shadowsocks-2022-$hostname"
}
fi
if grep vmess-xr "$HOME/fsub/xr.json" >/dev/null 2>&1 || grep vmess-sb "$HOME/fsub/sb.json" >/dev/null 2>&1; then
echo "💣【 Vmess-ws 】节点信息如下："
port_vm_ws=$(cat "$HOME/fsub/port_vm_ws")
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"/$uuid-vm\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> "$HOME/fsub/jhsub.txt"
echo "$vm_link"
echo
sbvmpt(){
cat <<EOF
{
            "server": "$server_ip",
            "server_port": $port_vm_ws,
            "tag": "${sxname}vmess-$hostname",
            "tls": {
                "enabled": false,
                "server_name": "www.bing.com",
                "insecure": false,
                "utls": {
                    "enabled": true,
                    "fingerprint": "chrome"
                }
            },
            "packet_encoding": "packetaddr",
            "transport": {
                "headers": {
                    "Host": [
                        "www.bing.com"
                    ]
                },
                "path": "$uuid-vm",
                "type": "ws"
            },
            "type": "vmess",
            "security": "auto",
            "uuid": "$uuid"
        },
EOF
}
sbvmpt1(){
echo "\"${sxname}vmess-$hostname\","
}
clvmpt(){
cat <<EOF
- name: ${sxname}vmess-ws-$hostname                         
  type: vmess
  server: $server_ip                        
  port: $port_vm_ws                                     
  uuid: $uuid       
  alterId: 0
  cipher: auto
  udp: true
  tls: false
  network: ws
  servername: www.bing.com                    
  ws-opts:
    path: "$uuid-vm"                             
    headers:
      Host: www.bing.com
EOF
}
clvmpt1(){
echo "- ${sxname}vmess-ws-$hostname"
}
fi
if grep anytls-sb "$HOME/fsub/sb.json" >/dev/null 2>&1; then
echo "💣【 AnyTLS 】节点信息如下："
port_an=$(cat "$HOME/fsub/port_an")
an_link="anytls://$uuid@$server_ip:$port_an?insecure=1&allowInsecure=1#${sxname}anytls-$hostname"
echo "$an_link" >> "$HOME/fsub/jhsub.txt"
echo "$an_link"
echo
sbanpt(){
cat <<EOF
         {
            "type": "anytls",
            "tag": "${sxname}anytls-$hostname",
            "server": "$server_ip",
            "server_port": $port_an,
            "password": "$uuid",
            "idle_session_check_interval": "30s",
            "idle_session_timeout": "30s",
            "min_idle_session": 5,
            "tls": {
                "enabled": true,
                "insecure": true,
                "server_name": "www.bing.com"
            }
         },
EOF
}
sbanpt1(){
echo "\"${sxname}anytls-$hostname\","
}
clanpt(){
cat <<EOF
- name: ${sxname}anytls-$hostname
  type: anytls
  server: $server_ip
  port: $port_an
  password: $uuid
  client-fingerprint: chrome
  udp: true
  idle-session-check-interval: 30
  idle-session-timeout: 30
  sni: www.bing.com
  skip-cert-verify: true
EOF
}
clanpt1(){
echo "- ${sxname}anytls-$hostname"
}
fi
if grep anyreality-sb "$HOME/fsub/sb.json" >/dev/null 2>&1; then
echo "💣【 Any-Reality 】节点信息如下："
port_ar=$(cat "$HOME/fsub/port_ar")
ar_link="anytls://$uuid@$server_ip:$port_ar?security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_s&sid=$short_id_s&type=tcp&headerType=none#${sxname}any-reality-$hostname"
echo "$ar_link" >> "$HOME/fsub/jhsub.txt"
echo "$ar_link"
echo
sbarpt(){
cat <<EOF
    {
        "type": "anytls",
        "tag": "${sxname}any-reality-$hostname",
        "server": "$server_ip",
        "server_port": $port_ar,
        "password": "$uuid",
        "idle_session_check_interval": "30s",
        "idle_session_timeout": "30s",
        "min_idle_session": 5,
        "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$public_key_s",
          "short_id": "$short_id_s"
        }
      }
         },
EOF
}
sbarpt1(){
echo "\"${sxname}any-reality-$hostname\","
}
fi
if grep hy2-sb "$HOME/fsub/sb.json" >/dev/null 2>&1; then
echo "💣【 Hysteria2 】节点信息如下："
port_hy2=$(cat "$HOME/fsub/port_hy2")
hy2_ports=$(iptables -t nat -nL --line 2>/dev/null | grep -w "$port_hy2" | awk '{print $8}' | sed 's/dpts://; s/dpt://' | tr '\n' ',' | sed 's/,$//')
if [ -n "$hy2_ports" ]; then
echo "Hysteria2跳跃端口已开启：$hy2_ports"
cmhy2pt=$(echo $hy2_ports | tr ':' '-')
hyps="&mport=$cmhy2pt"
sbhy2pt=$(echo "$hy2_ports" | grep -o '[0-9]\+:[0-9]\+' | sed 's/.*/"&"/' | paste -sd,)
sbhy2ports(){
    cat <<EOF
  "server_ports": [ $sbhy2pt ],
EOF
}
else
hyps=
fi
hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&allowInsecure=1$hyps&sni=www.bing.com#${sxname}hy2-$hostname"
echo "$hy2_link" >> "$HOME/fsub/jhsub.txt"
echo "$hy2_link"
echo
sbhypt(){
cat <<EOF
    {
        "type": "hysteria2",
        "tag": "${sxname}hy2-$hostname",
        "server": "$server_ip",
        "server_port": $port_hy2,
$(sbhy2ports 2>/dev/null)
        "password": "$uuid",
        "tls": {
            "enabled": true,
            "server_name": "www.bing.com",
            "insecure": true,
            "alpn": [
                "h3"
            ]
        }
    },
EOF
}
sbhypt1(){
echo "\"${sxname}hy2-$hostname\","
}
clhypt(){
cat <<EOF
- name: ${sxname}hysteria2-$hostname                            
  type: hysteria2                                      
  server: $server_ip                              
  port: $port_hy2
  ports: $cmhy2pt
  password: $uuid                          
  alpn:
    - h3
  sni: www.bing.com                               
  skip-cert-verify: true
  fast-open: true
EOF
}
clhypt1(){
echo "- ${sxname}hysteria2-$hostname"
}
fi
if grep tuic5-sb "$HOME/fsub/sb.json" >/dev/null 2>&1; then
echo "💣【 Tuic 】节点信息如下："
port_tu=$(cat "$HOME/fsub/port_tu")
tuic5_link="tuic://$uuid:$uuid@$server_ip:$port_tu?congestion_control=bbr&udp_relay_mode=native&alpn=h3&sni=www.bing.com&insecure=1&allowInsecure=1&allow_insecure=1#${sxname}tuic-$hostname"
echo "$tuic5_link" >> "$HOME/fsub/jhsub.txt"
echo "$tuic5_link"
echo
sbtupt(){
cat <<EOF
        {
            "type":"tuic",
            "tag": "${sxname}tuic5-$hostname",
            "server": "$server_ip",
            "server_port": $port_tu,
            "uuid": "$uuid",
            "password": "$uuid",
            "congestion_control": "bbr",
            "udp_relay_mode": "native",
            "udp_over_stream": false,
            "zero_rtt_handshake": false,
            "heartbeat": "10s",
            "tls":{
                "enabled": true,
                "server_name": "www.bing.com",
                "insecure": true,
                "alpn": [
                    "h3"
                ]
            }
        },
EOF
}
sbtupt1(){
echo "\"${sxname}tuic5-$hostname\","
}
cltupt(){
cat <<EOF
- name: ${sxname}tuic5-$hostname                            
  server: $server_ip                      
  port: $port_tu                                    
  type: tuic
  uuid: $uuid       
  password: $uuid   
  alpn: [h3]
  disable-sni: true
  reduce-rtt: true
  udp-relay-mode: native
  congestion-controller: bbr
  sni: www.bing.com                                
  skip-cert-verify: true
EOF
}
cltupt1(){
echo "- ${sxname}tuic5-$hostname"
}
fi
if grep socks5-xr "$HOME/fsub/xr.json" >/dev/null 2>&1 || grep socks5-sb "$HOME/fsub/sb.json" >/dev/null 2>&1; then
echo "💣【 Socks5 】客户端信息如下："
port_so=$(cat "$HOME/fsub/port_so")
echo "请配合其他应用内置代理使用，勿做节点直接使用"
echo "客户端地址：$server_ip"
echo "客户端端口：$port_so"
echo "客户端凭据已配置（请查看配置文件）"
echo
fi

get_func() {
local f=$1
if type "$f" >/dev/null 2>&1; then
local out
out=$($f)
[ -n "$out" ] && printf "%s\n" "$out"
fi
}
sbxy="$(get_func sbvlpt; get_func sbsspt; get_func sbanpt; get_func sbarpt; get_func sbvmpt; get_func sbhypt; get_func sbtupt)"
clxy="$(get_func clvlpt; get_func clsspt; get_func clanpt; get_func clvmpt; get_func clhypt; get_func cltupt)"
sbgz="$(get_func sbvlpt1; get_func sbsspt1; get_func sbanpt1; get_func sbarpt1; get_func sbvmpt1; get_func sbhypt1; get_func sbtupt1)"
clgz="$({ get_func clvlpt1; get_func clsspt1; get_func clanpt1; get_func clvmpt1; get_func clhypt1; get_func cltupt1; } | sed '2,$s/^/    /')"
sbgz=$(printf "%s\n" "$sbgz" | sed '$ s/,$//')
cat > $HOME/fsub/sbox.json <<EOF
{
    "log": {
        "disabled": false,
        "level": "warn",
        "timestamp": true
    },
    "experimental": {
        "cache_file": {
            "enabled": true,
            "path": "./cache.db",
            "store_fakeip": true
        },
        "clash_api": {
            "external_controller": "127.0.0.1:9090",
            "external_ui": "ui",
            "default_mode": "Rule"
        }
    },
    "dns": {
        "servers": [
            {
                "tag": "cfDns",
                "type": "https",
                "server": "1.1.1.1",
                "path": "/dns-query",
                "domain_resolver": "local"
            },
            {
                "tag": "local",
                "type": "udp",
                "server": "1.1.1.1"
            },
            {
                "tag": "proxyDns",
                "type": "https",
                "server": "dns.google",
                "path": "/dns-query",
	              "domain_resolver": "cfDns",
                "detour": "proxy"
            },
           {
        "type": "fakeip",
        "tag": "fakeip",
        "inet4_range": "198.18.0.0/15",
        "inet6_range": "fc00::/18"
      }
        ],
        "rules": [
            {
                "rule_set": "geosite-cn",
                "clash_mode": "Rule",
                "server": "cfDns"
            },
            {
                "clash_mode": "Direct",
                "server": "local"
            },
            {
                "clash_mode": "Global",
                "server": "proxyDns"
            },
            {
        "query_type": [
          "A",
          "AAAA"
        ],
        "server": "fakeip"
      }
        ],
        "final": "proxyDns",
        "strategy": "prefer_ipv4"
    },
    "inbounds": [
        {
            "type": "tun",
            "tag": "tun-in",
            "address": [
                "172.19.0.1/30",
                "fd00::1/126"
            ],
            "auto_route": true,
            "strict_route": true
        }
    ],
    "route": {
        "rules": [
            {
	 "inbound": "tun-in",
                "action": "sniff"
            },
            {
                "type": "logical",
                "mode": "or",
                "rules": [
                    {
                        "port": 53
                    },
                    {
                        "protocol": "dns"
                    }
                ],
                "action": "hijack-dns"
            },
         {
          "clash_mode": "Global",
          "outbound": "proxy"
         },
        {
        "rule_set": "geosite-cn",
        "clash_mode": "Rule",
        "outbound": "direct"
       },
     {
    "rule_set": "geoip-cn",
    "clash_mode": "Rule",
    "outbound": "direct"
      },
     {
    "ip_is_private": true,
    "clash_mode": "Rule",
    "outbound": "direct"
    },
     {
      "clash_mode": "Direct",
      "outbound": "direct"
     }		
        ],
        "rule_set": [
            {
                "tag": "geosite-cn",
                "type": "remote",
                "format": "binary",
                "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/geolocation-cn.srs",
                "download_detour": "direct"
            },
            {
                "tag": "geoip-cn",
                "type": "remote",
                "format": "binary",
                "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.srs",
                "download_detour": "direct"
            }
        ],
        "final": "proxy",
        "auto_detect_interface": true,
        "default_domain_resolver": {
        "server": "cfDns"
        }
    },
  "outbounds": [
   $sbxy
        {
            "tag": "proxy",
            "type": "selector",
            "default": "auto",
            "outbounds": [
        "auto",
        $sbgz
            ]
        },
        {
            "tag": "auto",
            "type": "urltest",
            "outbounds": [
            $sbgz
            ],
            "url": "http://www.gstatic.com/generate_204",
            "interval": "10m",
            "tolerance": 50
        },
        {
            "type": "direct",
            "tag": "direct"
        }
    ]
}
EOF

cat > $HOME/fsub/clmi.yaml <<EOF
port: 7890
allow-lan: true
mode: rule
log-level: info
unified-delay: true
dns:
  enable: true 
  listen: "0.0.0.0:1053"
  ipv6: true
  prefer-h3: false
  respect-rules: true
  use-system-hosts: false
  cache-algorithm: "arc"
  enhanced-mode: "fake-ip"
  fake-ip-range: "198.18.0.1/16"
  fake-ip-filter:
    - "+.lan"
    - "+.local"
    - "+.msftconnecttest.com"
    - "+.msftncsi.com"
    - "localhost.ptlogin2.qq.com"
    - "localhost.sec.qq.com"
    - "+.in-addr.arpa"
    - "+.ip6.arpa"
    - "time.*.com"
    - "time.*.gov"
    - "pool.ntp.org"
    - "localhost.work.weixin.qq.com"
  default-nameserver: ["1.1.1.1", "8.8.8.8"]
  nameserver:
    - "https://1.1.1.1/dns-query"
    - "https://8.8.8.8/dns-query"
  proxy-server-nameserver:
    - "https://1.1.1.1/dns-query"
    - "https://8.8.8.8/dns-query"
nameserver-policy:
  "geosite:cn":
     - "https://1.1.1.1/dns-query"
     - "https://8.8.8.8/dns-query"
proxies:
$clxy

proxy-groups:
- name: 负载均衡
  type: load-balance
  url: https://www.gstatic.com/generate_204
  interval: 300
  strategy: round-robin
  proxies:
    $clgz
- name: 自动选择
  type: url-test
  url: https://www.gstatic.com/generate_204
  interval: 300
  tolerance: 50
  proxies:
    $clgz 
- name: 🌍选择代理节点
  type: select
  proxies:
    - 负载均衡                                         
    - 自动选择
    - DIRECT
    $clgz
rules:
  - GEOIP,LAN,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,🌍选择代理节点
EOF
echo "---------------------------------------------------------"
echo
if [ -s $HOME/fsub/subport.log ]; then
showsubport=$(cat $HOME/fsub/subport.log)
if ps -ef 2>/dev/null | grep "$showsubport" | grep -v grep >/dev/null; then
showsubtoken=$(cat $HOME/fsub/subtoken.log 2>/dev/null)
subip=$(cat $HOME/fsub/server_ip.log 2>/dev/null)
suburl="$subip:$showsubport/$showsubtoken"
echo "**********************************************************"
echo "Clash/Mihomo本地IP订阅地址：http://$suburl/clmi.yaml"
echo "Sing-box本地IP订阅地址：http://$suburl/sbox.json"
echo "聚合协议本地IP订阅地址：http://$suburl/jhsub.txt"
echo "**********************************************************"
fi
fi
echo
echo "---------------------------------------------------------"
echo "聚合节点信息，请进入 $HOME/fsub/jhsub.txt 文件目录查看或者运行 cat $HOME/fsub/jhsub.txt 查看"
echo "========================================================="
echo "相关快捷方式如下：(首次安装成功后需重连SSH，fsub快捷方式才可生效；如未生效，请使用主脚本)"
showmode
}
cleandel(){
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/fsub/s|/fsub/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null; fi; fi; done
kill -15 $(pgrep -f 'fsub/s' 2>/dev/null) $(pgrep -f 'fsub/x' 2>/dev/null) $(pgrep -f 'websbx' 2>/dev/null) >/dev/null 2>&1
sed -i '/fsub/d' ~/.bashrc
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
. ~/.bashrc 2>/dev/null
crontab -l > $AGSBX_TMPFILE 2>/dev/null
sed -i '/fsub\/sing-box/d' $AGSBX_TMPFILE
sed -i '/fsub\/xray/d' $AGSBX_TMPFILE
sed -i '/websbx/d' $AGSBX_TMPFILE
crontab $AGSBX_TMPFILE >/dev/null 2>&1
rm $AGSBX_TMPFILE
rm -rf  "$HOME/bin/fsub"
if pidof systemd >/dev/null 2>&1; then
for svc in xr sb; do
systemctl stop "$svc" >/dev/null 2>&1
systemctl disable "$svc" >/dev/null 2>&1
done
rm -rf /etc/systemd/system/{xr.service,sb.service}
elif command -v rc-service >/dev/null 2>&1; then
for svc in sing-box xray; do
rc-service "$svc" stop >/dev/null 2>&1
rc-update del "$svc" default >/dev/null 2>&1
done
rm -rf /etc/init.d/{sing-box,xray} /etc/local.d/alpinesubsbx.start
iptables -t nat -F PREROUTING >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
rc-service iptables save >/dev/null 2>&1
rc-service ip6tables save >/dev/null 2>&1
fi
}
xrestart(){
kill -15 $(pgrep -f 'fsub/x' 2>/dev/null) >/dev/null 2>&1
if pidof systemd >/dev/null 2>&1; then
systemctl restart xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service xray restart >/dev/null 2>&1
else
nohup $HOME/fsub/xray run -c $HOME/fsub/xr.json >/dev/null 2>&1 &
fi
}
sbrestart(){
kill -15 $(pgrep -f 'fsub/s' 2>/dev/null) >/dev/null 2>&1
if pidof systemd >/dev/null 2>&1; then
systemctl restart sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service sing-box restart >/dev/null 2>&1
else
nohup $HOME/fsub/sing-box run -c $HOME/fsub/sb.json >/dev/null 2>&1 &
fi
}
if [ "$1" = "del" ]; then
cleandel
rm -rf sbx_update "$HOME/fsub" "$HOME/websbx"
echo "卸载完成"
echo "欢迎继续使用fansub一键小钢炮脚本💣" && sleep 2
echo
showmode
exit
elif [ "$1" = "rep" ]; then
cleandel
rm -rf "$HOME/fsub"/{sb.json,xr.json,name}
echo "fansub重置协议完成，请重新选择协议……" && sleep 2
echo
elif [ "$1" = "list" ]; then
cip
exit
elif [ "$1" = "upx" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/fsub/x"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'fsub/x' 2>/dev/null) >/dev/null 2>&1
upxray && xrestart && echo "Xray内核更新完成" && sleep 2 && cip
exit
elif [ "$1" = "ups" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/fsub/s"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'fsub/s' 2>/dev/null) >/dev/null 2>&1
upsingbox && sbrestart && echo "Sing-box内核更新完成" && sleep 2 && cip
exit
elif [ "$1" = "res" ]; then
for P in /proc/[0-9]*; do
[ -L "$P/exe" ] || continue
TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue
case "$TARGET" in
*"/fsub/s"*)
kill "$(basename "$P")" 2>/dev/null
sbrestart
;;
*"/fsub/x"*)
kill "$(basename "$P")" 2>/dev/null
xrestart
;;
esac
done
sleep 5 && echo "重启完成" && sleep 3 && cip
exit
fi
if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'fsub/(s|x)' && ! pgrep -f 'fsub/(s|x)' >/dev/null 2>&1; then
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/fsub/s|/fsub/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null && echo "Killed $PID ($TARGET)" || echo "Could not kill $PID ($TARGET)"; fi; fi; done
kill -15 $(pgrep -f 'fsub/s' 2>/dev/null) $(pgrep -f 'fsub/x' 2>/dev/null) >/dev/null 2>&1
if [ -z "$( (command -v curl >/dev/null 2>&1 && curl -s4m5 "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null) )" ]; then
if [ -n "$RESOLV_DNS" ]; then
echo -e "nameserver $RESOLV_DNS" > /etc/resolv.conf
else
echo "提示：无IPv4连接且未设置 RESOLV_DNS 环境变量，跳过修改 /etc/resolv.conf"
fi
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "fansub脚本未安装，开始安装…………" && sleep 1
ins
if [ -n "$sub" ]; then
subtokenipsub(){
if [ -z "$subid" ]; then
subtoken="$(cat "$HOME/fsub/uuid")"
else
subtoken="$subid"
fi
rm -rf $HOME/websbx/"$(cat $HOME/fsub/subtoken.log 2>/dev/null)"
echo $subtoken > $HOME/fsub/subtoken.log
}
subportipsub(){
if [ -z "$subpt" ]; then
if [ -n "$(cat "$HOME/fsub/subport.log" 2>/dev/null)" ]; then
subport=$(cat $HOME/fsub/subport.log)
else
subport=$(shuf -i 10000-65535 -n 1)
fi
else
subport="$subpt"
fi
echo $subport > $HOME/fsub/subport.log
}
subtokenipsub && subportipsub
echo "请稍后…………"
kill -15 $(pgrep -f 'websbx' 2>/dev/null) >/dev/null 2>&1
mkdir -p $HOME/websbx/"$(cat $HOME/fsub/subtoken.log 2>/dev/null)"
ln -sf $HOME/fsub/clmi.yaml $HOME/websbx/"$(cat $HOME/fsub/subtoken.log 2>/dev/null)"/clmi.yaml
ln -sf $HOME/fsub/sbox.json $HOME/websbx/"$(cat $HOME/fsub/subtoken.log 2>/dev/null)"/sbox.json
ln -sf $HOME/fsub/jhsub.txt $HOME/websbx/"$(cat $HOME/fsub/subtoken.log 2>/dev/null)"/jhsub.txt
if command -v apk >/dev/null 2>&1; then
busybox-extras httpd -f -p "$(cat $HOME/fsub/subport.log 2>/dev/null)" -h $HOME/websbx > /dev/null 2>&1 &
else
busybox httpd -f -p "$(cat $HOME/fsub/subport.log 2>/dev/null)" -h $HOME/websbx > /dev/null 2>&1 &
fi
sleep 5
if command -v apk >/dev/null 2>&1; then
cat > /etc/local.d/alpinesubsbx.start <<EOF
#!/bin/bash
sleep 10
busybox-extras httpd -f -p \$(cat $HOME/fsub/subport.log 2>/dev/null) -h $HOME/websbx > /dev/null 2>&1 &
EOF
chmod +x /etc/local.d/alpinesubsbx.start
rc-update add local default >/dev/null 2>&1
else
crontab -l 2>/dev/null > $AGSBX_TMPFILE
sed -i '/websbx/d' $AGSBX_TMPFILE
echo '@reboot sleep 10 && /bin/bash -c "busybox httpd -f -p $(cat $HOME/fsub/subport.log 2>/dev/null) -h $HOME/websbx > /dev/null 2>&1 &"' >> $AGSBX_TMPFILE
crontab $AGSBX_TMPFILE >/dev/null 2>&1
rm $AGSBX_TMPFILE
fi
echo "本地IP订阅链接已更新完成"
fi
if [ -n "$oap" ]; then
setenforce 0 >/dev/null 2>&1
openport(){
local pt=$1 proto=$2
[ -n "$pt" ] && iptables -I INPUT -p "$proto" --dport "$pt" -j ACCEPT 2>/dev/null && ip6tables -I INPUT -p "$proto" --dport "$pt" -j ACCEPT 2>/dev/null
}
openport 22 tcp
[ -f "$HOME/fsub/port_vl_re" ] && openport "$(cat "$HOME/fsub/port_vl_re")" tcp
[ -f "$HOME/fsub/port_xh" ] && openport "$(cat "$HOME/fsub/port_xh")" tcp
[ -f "$HOME/fsub/port_vx" ] && openport "$(cat "$HOME/fsub/port_vx")" tcp
[ -f "$HOME/fsub/port_vm_ws" ] && openport "$(cat "$HOME/fsub/port_vm_ws")" tcp
[ -f "$HOME/fsub/port_so" ] && openport "$(cat "$HOME/fsub/port_so")" tcp
[ -f "$HOME/fsub/port_ss" ] && openport "$(cat "$HOME/fsub/port_ss")" tcp
[ -f "$HOME/fsub/port_an" ] && openport "$(cat "$HOME/fsub/port_an")" tcp
[ -f "$HOME/fsub/port_ar" ] && openport "$(cat "$HOME/fsub/port_ar")" tcp
[ -f "$HOME/fsub/port_hy2" ] && openport "$(cat "$HOME/fsub/port_hy2")" udp
[ -f "$HOME/fsub/port_tu" ] && openport "$(cat "$HOME/fsub/port_tu")" udp
[ -n "$subport" ] && openport "$subport" tcp
netfilter-persistent save >/dev/null 2>&1
echo
echo "iptables已开放脚本所需端口"
fi
if [ -n "$hyjpt" ] && [ -n "$hyp" ]; then
echo
echo "设置Hysteria2协议的跳跃端口：$hyjpt"
iptables -t nat -F PREROUTING >/dev/null 2>&1
ip6tables -t nat -F PREROUTING >/dev/null 2>&1
hyport=$(cat "$HOME/fsub/port_hy2")
hyjppt=($hyjpt)
for port in "${hyjppt[@]}"; do
iptables -t nat -A PREROUTING -p udp --dport "$port" -j DNAT --to-destination :$hyport
ip6tables -t nat -A PREROUTING -p udp --dport "$port" -j DNAT --to-destination :$hyport
done
netfilter-persistent save >/dev/null 2>&1
rc-update show default | grep -q 'iptables'  || rc-update add iptables  >/dev/null 2>&1
rc-update show default | grep -q 'ip6tables' || rc-update add ip6tables >/dev/null 2>&1
rc-service iptables save >/dev/null 2>&1
rc-service ip6tables save >/dev/null 2>&1
fi
cip
echo
else
echo "fansub脚本已安装"
echo
fansubstatus
echo
echo "相关快捷方式如下："
showmode
exit
fi
