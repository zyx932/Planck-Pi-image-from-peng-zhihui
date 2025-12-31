#!/bin/bash
# /usr/local/bin/usb-mode-switch

case "$1" in
    host)
        echo "切换到USB主机模式（可接U盘）"
        rm -rf /sys/kernel/config/usb_gadget/gg 2>/dev/null
        echo host > /sys/devices/platform/soc/1c13000.usb/musb-hdrc.1.auto/mode
        systemctl stop ifup@usb0 2>/dev/null
        ip link set usb0 down 2>/dev/null
        echo "USB主机模式已激活"
        ;;
    gadget)
        echo "切换到USB设备模式（RNDIS网卡）"
        echo peripheral > /sys/devices/platform/soc/1c13000.usb/musb-hdrc.1.auto/mode
        # 这里可以添加RNDIS配置脚本
        /etc/init.d/runOnBoot
        echo "USB设备模式已激活"
        ;;
    status)
        echo "当前USB模式:"
        cat /sys/devices/platform/soc/1c13000.usb/musb-hdrc.1.auto/mode
        echo ""
        echo "USB设备列表:"
        lsusb
        ;;
    *)
        echo "用法: $0 {host|gadget|status}"
        echo "  host     - 切换到主机模式（接U盘）"
        echo "  gadget   - 切换到设备模式（RNDIS网卡）"
        echo "  status   - 查看当前状态"
        exit 1
        ;;
esac
