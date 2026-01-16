#!/bin/bash
#
# diy-part1.sh - Feeds 更新前执行
# 用于添加第三方软件源
#

# 添加 sing-box 官方源 (OpenWrt 24.10 可能已包含，此处备用)
# echo 'src-git sing_box https://github.com/muink/openwrt-sing-box' >> feeds.conf.default

# 添加 sing-box GUI (HomeProxy)
# 使用 immortalwrt 的 homeproxy，专为 sing-box 设计的现代化 GUI
git clone https://github.com/immortalwrt/homeproxy.git package/homeproxy

# 添加 Argon 主题源 (可选)
# echo 'src-git argon https://github.com/jerrykuku/luci-theme-argon' >> feeds.conf.default

# 注意: OpenWrt 24.10 官方源已包含大部分常用包，无需额外添加 helloworld 等第三方源
