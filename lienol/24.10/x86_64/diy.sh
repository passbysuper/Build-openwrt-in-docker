
#git clone https://github.com/zxl78585/luci-app-autoreboot.git package/luci-app-autoreboot
#git clone https://github.com/rufengsuixing/luci-app-zerotier package/luci-app-zerotier

small_package_repo_url="https://github.com/kenzok8/small-package"
small_package_branch="main"
small_package_dirs=(
    "luci-theme-argon=package/luci-theme-argon"
    "luci-app-argon-config=package/luci-app-argon-config"
    "luci-app-lucky=package/luci-app-lucky"
    "lucky=package/lucky"
    "luci-app-homeproxy=package/luci-app-homeproxy"
    "luci-app-openclash=package/luci-app-openclash" 
)

# 克隆并复制文件的函数
clone_and_copy() {
    # 参数1: 仓库地址, 参数2: 分支, 参数3: 子目录到目标目录的映射数组
    repo_url=$1
    branch=$2
    dirs_map=("${@:3}")  # 从参数3开始取所有的映射关系
    
    # 创建临时目录
    TMP_DIR=$(mktemp -d) || exit 1
    echo "临时目录: $TMP_DIR"
    
    # 克隆仓库到临时目录（depth=1）
    git clone --depth=1 -b "$branch" "$repo_url" "$TMP_DIR" || exit 1
    echo "仓库克隆到临时目录: $TMP_DIR"
    
    # 遍历映射，复制指定子目录到目标目录
    for pair in "${dirs_map[@]}"; do
        # 分离源目录和目标目录
        IFS='=' read -r src dest <<< "$pair"
        
        # 输出目标目录的绝对路径
        abs_dest=$(realpath "$dest")
        echo "目标目录 $dest 的绝对路径是: $abs_dest"
        
        # 如果目标目录已存在，先删除目标目录
        if [ -d "$abs_dest" ]; then
            echo "目标目录 $abs_dest 已存在，删除该目录"
            rm -rf "$abs_dest"
        fi
        
        # 如果源目录存在，就复制
        if [ -d "$TMP_DIR/$src" ]; then
            echo "复制目录 $TMP_DIR/$src 到 $abs_dest"
            mkdir -p "$dest"
            cp -a "$TMP_DIR/$src"/* "$dest/"
        else
            echo "警告: $TMP_DIR/$src 不存在"
        fi
    done
    
    # 删除临时目录
    rm -rf "$TMP_DIR"
    echo "已删除临时目录: $TMP_DIR"
}


# 调用函数处理第仓库
clone_and_copy "$small_package_repo_url" "$small_package_branch" "${small_package_dirs[@]}"
