# sing-box 配置指南 (GUI 模式)

> 您的固件已集成 **HomeProxy** (sing-box GUI)，无需编写复杂的配置文件。

## 1. 访问配置页面

1. 登录路由器后台 `https://192.168.10.1`
2. 导航至 **服务 (Services)** -> **HomeProxy**

## 2. 快速配置步骤

### 第一步：添加节点
1. 点击 **节点管理 (Nodes)** 标签
2. 支持多种方式添加：
   - **订阅链接**: 粘贴机场提供的订阅链接，点击更新
   - **手动添加**: 支持 VLESS / VMess / Trojan / Hysteria2 等协议
   - **导入**: 支持从剪贴板导入分享链接

### 第二步：开启代理
1. 回到 **常规设置 (General)** 标签
2. **主开关**: 勾选 "启用 (Enable)"
3. **运行模式**: 建议选择 "以 TUN 模式运行 (TUN Mode)"
4. **出站模式**: 建议 "规则模式 (Rule Mode)"
5. 点击 **保存并应用 (Save & Apply)**

> [!TIP]
> **关于生效机制**
> 在 HomeProxy 界面修改任何配置后，只需点击底部的 **"保存并应用"** 按钮，系统会自动重新生成配置文件并重启 sing-box 服务，**无需**手动重启。

## 3. 常见功能

- **分流规则**: 在 "路由设置" 中可自定义国内直连、广告拦截等规则
- **DNS 设置**: 插件会自动接管 DNS (dnsmasq)，防污染，通常无需手动修改
- **仪表盘**: 首页可查看 sing-box 运行状态、版本和流量信息

---

# 高级：手动配置文件 (如有特殊需求)

如果不习惯使用 GUI，也可以通过 SSH 手动修改配置（不推荐，可能会与 GUI 冲突）。

配置文件路径：
- GUI 生成的配置：`/etc/homeproxy/config.json` (自动生成，请勿手改)
- 手动模式配置文件：`/etc/sing-box/config.json`

如需完全手动控制，请先在 GUI 中禁用 HomeProxy，然后参考下文。

## 1. 创建配置文件
... (保留原有手动配置内容作为参考)

# 创建配置目录
mkdir -p /etc/sing-box

# 创建配置文件
nano /etc/sing-box/config.json
```

## 2. 基础配置模板

```json
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "dns": {
    "servers": [
      {
        "tag": "remote",
        "address": "tls://8.8.8.8",
        "detour": "proxy"
      },
      {
        "tag": "local",
        "address": "223.5.5.5",
        "detour": "direct"
      }
    ],
    "rules": [
      {
        "geosite": "cn",
        "server": "local"
      }
    ]
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "interface_name": "tun0",
      "inet4_address": "172.18.0.1/30",
      "auto_route": true,
      "strict_route": true,
      "sniff": true,
      "sniff_override_destination": false
    }
  ],
  "outbounds": [
    {
      "type": "vless",
      "tag": "proxy",
      "server": "YOUR_SERVER",
      "server_port": 443,
      "uuid": "YOUR_UUID",
      "flow": "",
      "tls": {
        "enabled": true,
        "server_name": "YOUR_DOMAIN"
      }
    },
    {
      "type": "direct",
      "tag": "direct"
    },
    {
      "type": "block",
      "tag": "block"
    },
    {
      "type": "dns",
      "tag": "dns-out"
    }
  ],
  "route": {
    "rules": [
      {
        "protocol": "dns",
        "outbound": "dns-out"
      },
      {
        "geosite": "cn",
        "geoip": ["private", "cn"],
        "outbound": "direct"
      }
    ],
    "final": "proxy",
    "auto_detect_interface": true
  }
}
```

## 3. 启动服务

```bash
# 启动 sing-box
/etc/init.d/sing-box start

# 查看状态
/etc/init.d/sing-box status

# 设置开机自启
/etc/init.d/sing-box enable

# 查看日志
logread | grep sing-box
```

## 4. DNS 劫持配置

```bash
# 方法一：修改 dnsmasq 配置
uci set dhcp.@dnsmasq[0].noresolv=1
uci add_list dhcp.@dnsmasq[0].server='127.0.0.1#1053'
uci commit dhcp
/etc/init.d/dnsmasq restart

# 方法二：防火墙规则强制劫持
nft add rule inet fw4 dstnat ip daddr != 192.168.10.0/24 udp dport 53 redirect to :53
```

## 5. 验证配置

```bash
# 检查 TUN 接口
ip addr show tun0

# 检查路由表
ip route show table all | grep tun0

# 测试连接
curl -I https://www.google.com
```

## 6. 故障排查

```bash
# 查看完整日志
logread -f

# 检查防火墙规则
nft list ruleset

# 重启服务
/etc/init.d/sing-box restart
```

## 节点配置说明

根据你的代理协议，替换 `outbounds` 中的 `proxy` 配置：

- **VLESS/VMess**: 如上示例
- **Trojan**: 将 `type` 改为 `trojan`，添加 `password` 字段
- **Hysteria2**: 将 `type` 改为 `hysteria2`，配置相应参数

详细配置请参考：https://sing-box.sagernet.org/configuration/
