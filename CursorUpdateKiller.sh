#!/bin/bash

# 检查是否为Windows系统
if [[ ! "$OSTYPE" == "msys"* ]] && [[ ! "$OSTYPE" == "cygwin"* ]]; then
    echo "警告：此脚本目前只支持Windows系统"
    read -p "按回车键退出..."
    exit 1
fi

# 检查管理员权限
if ! net session &>/dev/null; then
    echo "错误：需要管理员权限才能运行此脚本！"
    echo "请右键点击此脚本，选择'以管理员身份运行'后重试。"
    read -p $'\n按回车键退出...'
    exit 1
fi

echo "Cursor更新禁用工具"
echo "Powered by W1ndys"
echo "https://github.com/W1ndys"
echo "相关链接: https://linux.do/t/topic/297886/75"
echo "=================="

kill_cursor_update() {
    # 获取用户目录
    USER_HOME="$USERPROFILE"

    # 1. 删除更新缓存
    UPDATER_PATH="$USER_HOME/AppData/Local/cursor-updater/pending"
    if [ -d "$UPDATER_PATH" ]; then
        echo "正在删除更新缓存..."
        rm -rf "$UPDATER_PATH"
        echo "✓ 更新缓存已删除"
    fi

    # 2. 处理app-update.yml
    CURSOR_RESOURCES="$USER_HOME/AppData/Local/Programs/cursor/resources"
    UPDATE_YML="$CURSOR_RESOURCES/app-update.yml"

    if [ -f "$UPDATE_YML" ]; then
        echo "正在处理更新配置文件..."

        # 移除只读属性
        attrib -R "$UPDATE_YML" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "✓ 已移除只读属性"
        else
            echo "移除只读属性时出错"
            return 1
        fi

        # 备份原文件
        BACKUP_FILE="${UPDATE_YML}.bak"
        if [ ! -f "$BACKUP_FILE" ]; then
            mv "$UPDATE_YML" "$BACKUP_FILE"
            echo "✓ 已创建备份文件"
        fi

        # 创建空的配置文件
        echo -n > "$UPDATE_YML"

        # 设置只读属性
        attrib +R "$UPDATE_YML"
        echo "✓ 更新配置已禁用"
    fi

    echo -e "\n完成！Cursor的自动更新已被禁用。"
    echo "提示：如果要恢复更新功能，只需删除新的app-update.yml并将.bak文件改回原名即可。"
    echo "路径：$UPDATE_YML"
    return 0
}

read -p "按回车键开始禁用Cursor更新..."
if kill_cursor_update; then
    read -p $'\n按回车键退出...'
fi 