#!/bin/bash
# OP编译
# Copyright (c) 2019-2024 smallprogram
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File: wsl2op.sh
# Description: WSL automatically compiles Openwrt script code

# ------------------------------------------------------⬇⬇⬇⬇Code⬇⬇⬇⬇------------------------------------------------------
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make -j$(nproc)
# ----------------------------------------------------------------------------------------------------------------
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make tools/compile -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make toolchain/compile -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make package/cleanup -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make target/compile -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make buildinfo -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make package/compile -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make diffconfig buildversion feedsversion
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make package/install -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make target/install -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make package/index -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make json_overview_image_info -j$(nproc)
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make checksum -j$(nproc)
# ================================================================================================================
# make -j$(nproc)
# ----------------------------------------------------------------------------------------------------------------
# make tools/compile -j$(nproc)
# make toolchain/compile -j$(nproc)
# make package/cleanup -j$(nproc)
# make target/compile -j$(nproc)
# make buildinfo -j$(nproc)
# make package/compile -j$(nproc)
# make diffconfig buildversion feedsversion
# make package/install -j$(nproc)
# make target/install -j$(nproc)
# make package/index -j$(nproc)
# make json_overview_image_info -j$(nproc)
# make checksum -j$(nproc)

#--------------------⬇⬇⬇⬇环境变量⬇⬇⬇⬇--------------------

source ./platform_function.sh

# 编译环境中当前账户名字
user_name=$USER
# 默认OpenWrtAction的Config文件夹中的config文件名
config_name=$1
# wsl PATH路径
wsl_path=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# 默认输入超时时间，单位为秒
timer=15
# 编译环境默认值，1为WSL2，2为非WSL2的Linux环境。不要修改这里
sysenv=2
# OpenWrtAction Git URL
owaUrl=https://github.com/doorxp/OpenWrtAction.git
owa_branch=main
# 是否首次编译 0否，1是
is_first_compile=0
# 是否Make Clean & Make DirClean
is_clean_compile=$2
# 是否单线程编译
is_single_compile=$3
#清理超过多少天的日志文件
clean_day=3
# 编译结果变量
is_complie_error=0
# 编译是否展示详细信息
is_VS='V=s'
#Git参数
git_email=doorxp@msn.com
git_user=doorxp


# 拉取最新代码
Func_LogMessage "正在从远程获取最新代码..." "Fetching the latest code from remote..."
git fetch origin

Func_LogMessage "正在重置到最新的远程分支 ${owa_branch}..." "Resetting to the latest remote branch ${owa_branch}..."
# git reset --hard origin/${owa_branch}
git pull origin/${owa_branch}
# 检查当前脚本是否被更新
# CURRENT_SCRIPT="$(basename "$0")"
# if [[ $(git diff origin/${owa_branch} -- "$CURRENT_SCRIPT") ]]; then
#     Func_LogMessage "脚本已更新，重新启动..." "Script has been updated, restarting..."
#     exec "$0" "$@"
# fi


Func_LogMessage "请选择要编译的平台：" "Please choose the configuration file to import:"
Func_LogMessage "1) immortalwrt" "1) platform_immortalwrt.sh"
Func_LogMessage "2) lean" "2) platform_lean.sh"
Func_LogMessage "3) openwrt" "3) platform_openwrt.sh"
Func_LogMessage "将在15秒后默认选择 platform_immortalwrt.sh..." "The default choice will be platform_immortalwrt.sh in 15 seconds..."

# 使用read命令等待用户输入，超时15秒后自动选择1
read -t ${timer} -p "$(Func_LogMessage '输入对应的数字选择（默认1）: ' 'Enter the corresponding number to select (default 1): ')" choice
echo
# 根据用户输入选择对应的配置文件
case $choice in
    1)
        Func_LogMessage "选择 platform_immortalwrt.sh" "Selected platform_immortalwrt.sh"
        source ./platform_immortalwrt.sh
        ;;
    2)
        Func_LogMessage "选择 platform_lean.sh" "Selected platform_lean.sh"
        source ./platform_lean.sh
        ;;
    3)
        Func_LogMessage "选择 platform_openwrt.sh" "Selected platform_openwrt.sh"
        source ./platform_openwrt.sh
        ;;
    *)
        Func_LogMessage "超时或无效输入，默认选择 platform_immortalwrt.sh" "Timeout or invalid input, defaulting to platform_immortalwrt.sh"
        source ./platform_immortalwrt.sh
        ;;
esac
echo
# 后续脚本执行
Func_LogMessage "配置文件已加载，继续执行脚本..." "Configuration file loaded, continuing script execution..."
echo
Func_LogMessage "输入任意值取消显示详细编译信息" "Enter any value to cancel the display of detailed compilation information"
Func_LogMessage "将会在${timer}秒后自动选择默认值" "The default value will be automatically selected after ${timer} seconds"
read -t ${timer} isVS
if [ -n "$isVS" ]; then
    Func_LogMessage "显示详细编译信息 " "Display detailed compilation information"
    is_VS='V=s'
    sleep 1s
else
    Func_LogMessage "默认不显示详细编译信息" "Do not display detailed compilation information by default"
    is_VS=''
    sleep 1s
fi
echo
Func_Main
Func_LogMessage "编译状态:${is_complie_error}" "Compile Status Code:${is_complie_error}"
exit $is_complie_error
