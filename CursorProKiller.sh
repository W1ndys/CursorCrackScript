#!/bin/bash

# 设置输出编码为 UTF-8
export LANG="en_US.UTF-8"

# 颜色定义
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
NC="\e[0m"

# 配置文件路径
STORAGE_FILE="$APPDATA/Cursor/User/globalStorage/storage.json"
BACKUP_DIR="$APPDATA/Cursor/User/globalStorage/backups"

# 检查管理员权限
function test_administrator {
    if [ "$(id -u)" -ne 0 ]; then
        return 1
    fi
    return 0
}

if ! test_administrator; then
    echo -e "${RED}[错误]${NC} 请以管理员身份运行此脚本"
    echo "请右键点击脚本，选择'以管理员身份运行'"
    read -p "按回车键退出"
    exit 1
fi

# 显示 Logo
clear
echo -e "
    ██████╗██╗   ██╗██████╗ ███████╗ ██████╗ ██████╗ 
   ██╔════╝██║   ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗
   ██║     ██║   ██║██████╔╝███████╗██║   ██║██████╔╝
   ██║     ██║   ██║██╔══██╗╚════██║██║   ██║██╔══██╗
   ╚██████╗╚██████╔╝██║  ██║███████║╚██████╔╝██║  ██║
    ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
"
echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}      Cursor ID 修改工具          ${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
echo -e "${YELLOW}[重要提示]${NC} 本工具仅支持 Cursor v0.44.11 及以下版本"
echo -e "${YELLOW}[重要提示]${NC} 最新的 0.45.x 版本暂不支持"
echo ""

# 检查并关闭 Cursor 进程
echo -e "${GREEN}[信息]${NC} 检查 Cursor 进程..."

function get_process_details {
    local process_name=$1
    echo -e "${BLUE}[调试]${NC} 正在获取 $process_name 进程详细信息："
    ps aux | grep $process_name
}

# 定义最大重试次数和等待时间
MAX_RETRIES=5
WAIT_TIME=1

# 处理进程关闭
function close_cursor_process {
    local process_name=$1
    
    local process=$(pgrep $process_name)
    if [ -n "$process" ]; then
        echo -e "${YELLOW}[警告]${NC} 发现 $process_name 正在运行"
        get_process_details $process_name
        
        echo -e "${YELLOW}[警告]${NC} 尝试关闭 $process_name..."
        kill -9 $process
        
        local retry_count=0
        while [ $retry_count -lt $MAX_RETRIES ]; do
            process=$(pgrep $process_name)
            if [ -z "$process" ]; then break; fi
            
            retry_count=$((retry_count + 1))
            if [ $retry_count -ge $MAX_RETRIES ]; then
                echo -e "${RED}[错误]${NC} 在 $MAX_RETRIES 次尝试后仍无法关闭 $process_name"
                get_process_details $process_name
                echo -e "${RED}[错误]${NC} 请手动关闭进程后重试"
                read -p "按回车键退出"
                exit 1
            fi
            echo -e "${YELLOW}[警告]${NC} 等待进程关闭，尝试 $retry_count/$MAX_RETRIES..."
            sleep $WAIT_TIME
        done
        echo -e "${GREEN}[信息]${NC} $process_name 已成功关闭"
    fi
}

# 关闭所有 Cursor 进程
close_cursor_process "Cursor"
close_cursor_process "cursor"

# 创建备份目录
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# 备份现有配置
if [ -f "$STORAGE_FILE" ]; then
    echo -e "${GREEN}[信息]${NC} 正在备份配置文件..."
    backup_name="storage.json.backup_$(date +'%Y%m%d_%H%M%S')"
    cp "$STORAGE_FILE" "$BACKUP_DIR/$backup_name"
fi

# 生成新的 ID
echo -e "${GREEN}[信息]${NC} 正在生成新的 ID..."

# 生成随机字节数组并转换为十六进制字符串的函数
function get_random_hex {
    local length=$1
    hexdump -n $length -e '4/4 "%08X" 1 "\n"' /dev/urandom
}

UUID=$(uuidgen)
# 将 auth0|user_ 转换为字节数组的十六进制
prefix_bytes=$(echo -n "auth0|user_" | xxd -p)
# 生成32字节(64个十六进制字符)的随机数作为 machineId 的随机部分
random_part=$(get_random_hex 32)
MACHINE_ID="$prefix_bytes$random_part"
MAC_MACHINE_ID=$(get_random_hex 32)
SQM_ID="{$(uuidgen | tr 'a-z' 'A-Z')}"

# 创建或更新配置文件
echo -e "${GREEN}[信息]${NC} 正在更新配置..."

if [ ! -f "$STORAGE_FILE" ]; then
    echo -e "${RED}[错误]${NC} 未找到配置文件: $STORAGE_FILE"
    echo -e "${YELLOW}[提示]${NC} 请先安装并运行一次 Cursor 后再使用此脚本"
    read -p "按回车键退出"
    exit 1
fi

# 读取现有配置文件
original_content=$(cat "$STORAGE_FILE")

# 将 JSON 字符串转换为 jq 对象
config=$(echo "$original_content" | jq '.')

# 备份当前值
old_values=$(echo "$config" | jq '{machineId: .telemetry.machineId, macMachineId: .telemetry.macMachineId, devDeviceId: .telemetry.devDeviceId, sqmId: .telemetry.sqmId}')

# 更新特定的值
config=$(echo "$config" | jq --arg machineId "$MACHINE_ID" --arg macMachineId "$MAC_MACHINE_ID" --arg devDeviceId "$UUID" --arg sqmId "$SQM_ID" '.telemetry.machineId = $machineId | .telemetry.macMachineId = $macMachineId | .telemetry.devDeviceId = $devDeviceId | .telemetry.sqmId = $sqmId')

# 将更新后的对象转换回 JSON 并保存
echo "$config" | jq '.' > "$STORAGE_FILE"
echo -e "${GREEN}[信息]${NC} 成功更新配置文件"

# 显示结果
echo ""
echo -e "${GREEN}[信息]${NC} 已更新配置:"
echo -e "${BLUE}[调试]${NC} machineId: $MACHINE_ID"
echo -e "${BLUE}[调试]${NC} macMachineId: $MAC_MACHINE_ID"
echo -e "${BLUE}[调试]${NC} devDeviceId: $UUID"
echo -e "${BLUE}[调试]${NC} sqmId: $SQM_ID"

# 显示文件树结构
echo ""
echo -e "${GREEN}[信息]${NC} 文件结构:"
echo -e "${BLUE}$APPDATA/Cursor/User${NC}"
echo "├── globalStorage"
echo "│   ├── storage.json (已修改)"
echo "│   └── backups"

# 列出备份文件
backup_files=$(ls "$BACKUP_DIR")
if [ -n "$backup_files" ]; then
    for file in $backup_files; do
        echo "│       └── $file"
    done
else
    echo "│       └── (空)"
fi

# 显示公众号信息
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${YELLOW}  关注公众号【煎饼果子卷AI】一起交流更多Cursor技巧和AI知识  ${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${GREEN}[信息]${NC} 请重启 Cursor 以应用新的配置"
echo ""

# 询问是否要禁用自动更新
echo ""
echo -e "${YELLOW}[询问]${NC} 是否要禁用 Cursor 自动更新功能？"
echo "0) 否 - 保持默认设置 (按回车键)"
echo "1) 是 - 禁用自动更新"
read -p "请输入选项 (0): " choice

if [ "$choice" == "1" ]; then
    echo ""
    echo -e "${GREEN}[信息]${NC} 正在处理自动更新..."
    updater_path="$LOCALAPPDATA/cursor-updater"

    # 定义手动设置教程
    function show_manual_guide {
        echo ""
        echo -e "${YELLOW}[警告]${NC} 自动设置失败,请尝试手动操作："
        echo -e "${YELLOW}手动禁用更新步骤：${NC}"
        echo "1. 以管理员身份打开 Git Bash"
        echo "2. 复制粘贴以下命令："
        echo -e "${BLUE}命令1 - 删除现有目录（如果存在）：${NC}"
        echo "rm -rf \"$updater_path\""
        echo ""
        echo -e "${BLUE}命令2 - 创建阻止文件：${NC}"
        echo "touch \"$updater_path\""
        echo ""
        echo -e "${BLUE}命令3 - 设置只读属性：${NC}"
        echo "chmod 444 \"$updater_path\""
        echo ""
        echo -e "${BLUE}命令4 - 设置权限（可选）：${NC}"
        echo "chattr +i \"$updater_path\""
        echo ""
        echo -e "${YELLOW}验证方法：${NC}"
        echo "1. 运行命令：ls -l \"$updater_path\""
        echo "2. 确认权限为只读"
        echo ""
        echo -e "${YELLOW}[提示]${NC} 完成后请重启 Cursor"
    }

    # 删除现有目录
    if [ -d "$updater_path" ]; then
        rm -rf "$updater_path"
        echo -e "${GREEN}[信息]${NC} 成功删除 cursor-updater 目录"
    fi

    # 创建阻止文件
    touch "$updater_path"
    echo -e "${GREEN}[信息]${NC} 成功创建阻止文件"

    # 设置文件权限
    chmod 444 "$updater_path"
    chattr +i "$updater_path"
    echo -e "${GREEN}[信息]${NC} 成功设置文件权限"

    # 验证设置
    if [ ! -r "$updater_path" ]; then
        echo -e "${RED}[错误]${NC} 验证失败：文件权限设置可能未生效"
        show_manual_guide
    else
        echo -e "${GREEN}[信息]${NC} 成功禁用自动更新"
    fi
else
    echo -e "${GREEN}[信息]${NC} 保持默认设置，不进行更改"
fi

echo ""
read -p "按回车键退出"
exit 0