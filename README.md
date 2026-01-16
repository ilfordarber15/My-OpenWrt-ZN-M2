# OpenWrt 云编译 - 兆能 M2 (ZN-M2)

[![Build OpenWrt](https://github.com/YOUR_USERNAME/My-OpenWrt-ZN-M2/actions/workflows/build-openwrt.yml/badge.svg)](https://github.com/YOUR_USERNAME/My-OpenWrt-ZN-M2/actions/workflows/build-openwrt.yml)

基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 模板，为 **兆能 M2 (ZN-M2)** 路由器定制的 **OpenWrt 24.10** 云编译项目。

## 📌 设备信息

| 项目 | 参数 |
|------|------|
| 芯片 | Qualcomm IPQ6000 |
| Flash | 128MB |
| RAM | 512MB (已升级) |
| 网口 | 1×WAN + 3×LAN (千兆) |
| WiFi | 2.4GHz + 5GHz (AX) |

## ✨ 固件特性

- ✅ **OpenWrt 24.10** 官方稳定版
- ✅ **HomeProxy** (sing-box Web 管理界面)
- ✅ **sing-box TUN** 透明代理支持
- ✅ **PPPoE** 拨号上网
- ✅ **HTTPS** 管理界面 (luci-ssl)
- ✅ **firewall4** (nftables)
- ✅ **简体中文** 界面
- ✅ **WPA2/WPA3 Mixed** WiFi 加密

---

## 🚀 编译教程

### 第一步：创建 GitHub 仓库

1. 登录 [GitHub](https://github.com)
2. 点击右上角 **"+"** → **"New repository"**
3. 填写信息：
   - **Repository name**: `My-OpenWrt-ZN-M2`
   - **Visibility**: Public 或 Private
4. 点击 **"Create repository"**

### 第二步：上传项目文件

```bash
# 进入项目目录
cd E:\5.Github\My-OpenWrt-ZN-M2

# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: OpenWrt 24.10 for ZN-M2"

# 关联远程仓库 (替换 YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/My-OpenWrt-ZN-M2.git

# 推送
git branch -M main
git push -u origin main
```

### 第三步：触发编译

1. 打开您的 GitHub 仓库页面
2. 点击顶部的 **"Actions"** 标签
3. 左侧选择 **"Build OpenWrt for ZN-M2"**
4. 点击右侧 **"Run workflow"** → **"Run workflow"**

### 第四步：等待编译

- ⏱️ 编译时间约 **2-4 小时**
- 🟡 黄色 = 运行中
- 🟢 绿色 = 成功
- 🔴 红色 = 失败 (查看日志排查)

### 第五步：下载固件

**方式一：Artifacts**
1. 点击已完成的 workflow run
2. 页面底部 **"Artifacts"** 区域下载

**方式二：Releases (推荐)**
1. 仓库主页 → **"Releases"**
2. 下载最新版本固件

### 固件文件说明

| 文件名 | 用途 |
|--------|------|
| `*-factory.ubi` | 首次从原厂固件刷入 |
| `*-sysupgrade.bin` | OpenWrt 系统升级 |

---

## 📦 默认配置

| 设置项 | 默认值 |
|--------|--------|
| 管理地址 | `https://192.168.10.1` |
| 默认密码 | `password` |
| 语言 | 简体中文 |
| 时区 | Asia/Shanghai |

---

## ⚙️ 刷机后配置

### HomeProxy (sing-box GUI)

固件已集成 **HomeProxy** 图形界面，无需手动编辑配置文件。

1. 登录 `https://192.168.10.1`
2. 菜单：**服务** → **HomeProxy**
3. **添加节点**：粘贴订阅链接或手动添加
4. **启用代理**：勾选 "启用"，选择 TUN 模式
5. 点击 **保存并应用** (自动重启服务)

> 💡 详细教程请参考 [SING-BOX-CONFIG.md](SING-BOX-CONFIG.md)

### firewall4 验证

```bash
ssh root@192.168.10.1
fw4 -V
nft list ruleset | head
```

---

## 🔧 自定义编译

### 修改默认设置

编辑 `diy-part2.sh`：
- 默认 IP 地址
- 主机名
- 时区

### 添加/删除软件包

编辑 `.config`：
```makefile
# 启用包
CONFIG_PACKAGE_xxx=y

# 禁用包
# CONFIG_PACKAGE_xxx is not set
```

### SSH 调试模式

触发编译时将 `ssh` 设为 `true`，可进入交互式终端手动配置。

---

## 📁 项目结构

```
My-OpenWrt-ZN-M2/
├── .github/workflows/
│   └── build-openwrt.yml    # GitHub Actions 工作流
├── .config                   # OpenWrt 编译配置
├── diy-part1.sh              # Feeds 更新前脚本
├── diy-part2.sh              # Feeds 安装后脚本
├── SING-BOX-CONFIG.md        # sing-box 配置指南
├── LICENSE
└── README.md
```

---

## 📄 许可证

[MIT License](LICENSE) © 2024

## 🙏 致谢

- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [OpenWrt Official](https://openwrt.org/)
- [sing-box](https://sing-box.sagernet.org/)
- [ImmortalWrt/HomeProxy](https://github.com/immortalwrt/homeproxy)
