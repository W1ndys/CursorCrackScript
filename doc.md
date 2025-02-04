# 🚀 Cursor 免费试用重置工具

> ⚠️ **重要提示**
>
> 本工具当前支持版本：
>
> - ✅ Cursor v0.44.11 及以下版本
> - ❌ 最新的 0.45.x 版本（暂不支持）
>
> 使用前请确认您的 Cursor 版本。

> 💾 **下载 Cursor v0.44.11**
>
> - [从 Cursor 官方下载](https://downloader.cursor.sh/builds/250103fqxdt5u9z/windows/nsis/x64)
> - [从 ToDesktop 下载](https://download.todesktop.com/230313mzl4w4u92/Cursor%20Setup%200.44.11%20-%20Build%20250103fqxdt5u9z-x64.exe)

<details>
<summary> <b> 🔒 禁用自动更新功能 </b> </summary>

> 为防止 Cursor 自动更新到不支持的新版本，您可以选择禁用自动更新功能。

#### 方法一：使用内置脚本（推荐）

在运行重置工具时，脚本会询问是否要禁用自动更新：

```text
[询问] 是否要禁用 Cursor 自动更新功能？
0) 否 - 保持默认设置 (按回车键)
1) 是 - 禁用自动更新
```

选择 `1` 即可自动完成禁用操作。

#### 方法二：手动禁用

**Windows:**

1. 关闭所有 Cursor 进程
2. 删除目录：`%LOCALAPPDATA%\cursor-updater`
3. 在相同位置创建同名文件（不带扩展名）

**macOS:**

```bash
关闭 Cursor
pkill -f "Cursor"
# 删除更新目录并创建阻止文件
rm -rf ~/Library/Application\ Support/cursor-updater
touch ~/Library/Application\ Support/cursor-updater
```

**Linux:**

```bash
关闭 Cursor
pkill -f "Cursor"
# 删除更新目录并创建阻止文件
rm -rf ~/.config/cursor-updater
touch ~/.config/cursor-updater
```

> ⚠️ **注意：** 禁用自动更新后，需要手动下载并安装新版本。建议在确认新版本可用后再更新。

</details>

---

### 📝 问题描述

> 遇到以下任一提示时，请参考对应解决方案:

#### 问题一：试用账号限制 <p align="right"><a href="#solution1"><img src="https://img.shields.io/badge/查看解决方案-blue?style=flat-square" alt="查看解决方案"></a></p>

```text
Too many free trial accounts used on this machine.
Please upgrade to pro. We have this limit in place
to prevent abuse. Please let us know if you believe
this is a mistake.
```

#### 问题二：API 密钥限制 <p align="right"><a href="#solution2"><img src="https://img.shields.io/badge/查看解决方案-green?style=flat-square" alt="查看解决方案"></a></p>

```text
❗[New Issue]

Composer relies on custom models that cannot be billed to an API key.
Please disable API keys and use a Pro or Business subscription.
Request ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

#### 问题三：试用请求次数限制 <p align="right"><a href="#solution3"><img src="https://img.shields.io/badge/查看解决方案-orange?style=flat-square" alt="查看解决方案"></a></p>

> VIP 免费试用期间达到使用次数限制时会显示:

```text
You've reached your trial request limit.
```

<br>

<h3 id="solution2">🔧 解决方案二：完全卸载重装（API 密钥问题）</h3>

1. 下载 [Geek 卸载工具](https://geekuninstaller.com/download) <img src="https://img.shields.io/badge/免费-brightgreen?style=flat-square">
2. 使用 Geek 完全卸载 Cursor
3. 重新安装 Cursor
4. 参考解决方案一进行重置

<br>

<h3 id="solution1">🔄 解决方案一：快速重置（推荐）</h3>

#### 方案 A：一键重置

1. 关闭 Cursor
2. 运行重置脚本（见下方）
3. 重启 Cursor 即可

#### 方案 B：账号切换

1. 文件 → Cursor Settings → 注销账号
2. 关闭 Cursor
3. 运行重置脚本
4. 使用新账号登录

<h3 id="solution3">🌐 解决方案三：网络优化</h3>

如果上述方案无效，可以尝试:

- 切换低延迟节点（推荐: 🇯🇵 日本、🇸🇬 新加坡、🇺🇸 美国、🇭🇰 香港）
- 检查网络稳定性
- 清理浏览器缓存

### 🚀 系统支持

<table>
<tr>
<td>

**Windows** ✅

- x64 & x86

</td>
<td>

**macOS** ✅

- Intel & M-series

</td>
<td>

**Linux** ✅

- x64 & ARM64

</td>
</tr>
</table>

### 🚀 一键解决方案

<details open>
<summary> <b> 国内用户（推荐）</b> </summary>

**macOS**

```bash
curl -fsSL https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_mac_id_modifier.sh | sudo bash
```

**Linux**

```bash
curl -fsSL https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_linux_id_modifier.sh | sudo bash
```

**Windows**

```powershell
irm https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_win_id_modifier.ps1 | iex
```

<div align="center">
<img src="img/run_success.png" alt="运行成功" width="600"/>
</div>

</details>
<details open>
<summary> <b> Windows 管理员终端运行和手动安装 </b> </summary>

#### Windows 系统打开管理员终端的方法：

##### 方法一：使用 Win + X 快捷键

```md
1. 按下 Win + X 组合键
2. 在弹出的菜单中选择以下任一选项:
   - "Windows PowerShell (管理员)"
   - "Windows Terminal (管理员)"
   - "终端(管理员)"
     (具体选项因 Windows 版本而异)
```

##### 方法二：使用 Win + R 运行命令

```md
1. 按下 Win + R 组合键
2. 在运行框中输入 powershell 或 pwsh
3. 按 Ctrl + Shift + Enter 以管理员身份运行
   或在打开的窗口中输入: Start-Process pwsh -Verb RunAs
4. 在管理员终端中输入以下重置脚本:

irm https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_win_id_modifier.ps1 | iex
```

##### 方法三：通过搜索启动

> ![搜索 PowerShell](img/pwsh_1.png)
>
> 在搜索框中输入 pwsh，右键选择 "以管理员身份运行"
> ![管理员运行](img/pwsh_2.png)

在管理员终端中输入重置脚本:

```powershell
irm https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_win_id_modifier.ps1 | iex
```

### 🔧 PowerShell 安装指南

如果您的系统没有安装 PowerShell, 可以通过以下方法安装:

#### 方法一：使用 Winget 安装（推荐）

1. 打开命令提示符或 PowerShell
2. 运行以下命令:

```powershell
winget install --id Microsoft.PowerShell --source winget
```

#### 方法二：手动下载安装

1. 下载对应系统的安装包:

   - [PowerShell-7.4.6-win-x64.msi](https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/PowerShell-7.4.6-win-x64.msi) (64 位系统)
   - [PowerShell-7.4.6-win-x86.msi](https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/PowerShell-7.4.6-win-x86.msi) (32 位系统)
   - [PowerShell-7.4.6-win-arm64.msi](https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/PowerShell-7.4.6-win-arm64.msi) (ARM64 系统)

2. 双击下载的安装包, 按提示完成安装

> 💡 如果仍然遇到问题, 可以参考 [Microsoft 官方安装指南](https://learn.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-on-windows)

</details>

#### Windows 安装特性:

- 🔍 自动检测并使用 PowerShell 7（如果可用）
- 🛡️ 通过 UAC 提示请求管理员权限
- 📝 如果没有 PS7 则使用 Windows PowerShell
- 💡 如果提权失败会提供手动说明

完成后，脚本将：

1. ✨ 自动安装工具
2. 🔄 立即重置 Cursor 试用期

### 📦 手动安装

> 从 [releases](https://github.com/yuaotian/go-cursor-help/releases/latest) 下载适合您系统的文件

<details>
<summary> Windows 安装包 </summary>

- 64 位: `cursor-id-modifier_windows_x64.exe`
- 32 位: `cursor-id-modifier_windows_x86.exe`
</details>

<details>
<summary> macOS 安装包 </summary>

- Intel: `cursor-id-modifier_darwin_x64_intel`
- M1/M2: `cursor-id-modifier_darwin_arm64_apple_silicon`
</details>

<details>
<summary> Linux 安装包 </summary>

- 64 位: `cursor-id-modifier_linux_x64`
- 32 位: `cursor-id-modifier_linux_x86`
- ARM64: `cursor-id-modifier_linux_arm64`
</details>

### 🔧 技术细节

<details>
<summary> <b> 配置文件 </b> </summary>

程序修改 Cursor 的 `storage.json` 配置文件，位于：

- Windows: `%APPDATA%\Cursor\User\globalStorage\`
- macOS: `~/Library/Application Support/Cursor/User/globalStorage/`
- Linux: `~/.config/Cursor/User/globalStorage/`
</details>

<details>
<summary> <b> 修改字段 </b> </summary>

工具会生成新的唯一标识符：

- `telemetry.machineId`
- `telemetry.macMachineId`
- `telemetry.devDeviceId`
- `telemetry.sqmId`
</details>

<details>
<summary> <b> 手动禁用自动更新 </b> </summary>

Windows 用户可以手动禁用自动更新功能：

1. 关闭所有 Cursor 进程
2. 删除目录：`C:\Users\用户名\AppData\Local\cursor-updater`
3. 创建同名文件：`cursor-updater`（不带扩展名）

macOS/Linux 用户可以尝试在系统中找到类似的 `cursor-updater` 目录进行相同操作。

</details>

<details>
<summary> <b> 安全特性 </b> </summary>

- ✅ 安全的进程终止
- ✅ 原子文件操作
- ✅ 错误处理和恢复
</details>

### 📚 推荐阅读

- [Cursor 异常问题收集和解决方案](https://mp.weixin.qq.com/s/pnJrH7Ifx4WZvseeP1fcEA)
- [AI 通用开发助手提示词指南](https://mp.weixin.qq.com/s/PRPz-qVkFJSgkuEKkTdzwg)
