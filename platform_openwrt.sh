# 默认lean源码文件夹名
openwrt_dir_front=openwrt_
openwrt_dir=${openwrt_dir_front}${config_name}
# 默认的config目录
config_dir=config/openwrt_config
# config列表
config_list=($(ls ${PWD}/../OpenWrtAction/$config_dir))
# feeds目录
feeds_dir=feeds_config/openwrt.feeds.conf.default
# oepnwrt主源码
openwrt_source=https://github.com/openwrt/openwrt.git
openwrt_branch=main
# 编译openwrt的log日志文件夹名称
log_folder_name=openwrt_log
# diy script
diy_script_1=diy_script/openwrt_diy/diy-part1.sh
diy_script_2=diy_script/openwrt_diy/diy-part2.sh
# 依赖列表
my_depends=https://raw.githubusercontent.com/smallprogram/OpenWrtAction/refs/heads/main/diy_script/openwrt_dependence