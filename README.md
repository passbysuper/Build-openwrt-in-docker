# immortalwrt-build-docker

#解压镜像
7z x pre-immortalwrt-build-docker.tar.gz.7z.001 -o./
rm pre-immortalwrt-build-docker.tar.gz.7z.*
sudo docker load < pre-immortalwrt-build-docker.tar.gz && \
rm pre-immortalwrt-build-docker.tar.gz


#启动容器
sudo docker run -d --name pre-immortalwrt-build-docker pre-immortalwrt-build-docker tail -f /dev/null
   
复制并替换 .config 文件
cp /home/user/target/.config /home/user/openwrt/.config

#在容器中执行命令
sudo docker exec -u user -w /home/user/openwrt pre-immortalwrt-build-docker bash -c "
    # 拉取最新的代码
    
    echo "+++++++++++++++++++++++++++"
    echo "当前目录为："
    pwd
    echo "目录下文件："
    ls
    echo "+++++++++++++++++++++++++++"
    
    git pull

    # 复制自定义源并更新
    git clone --depth=1 https://github.com/sirpdboy/luci-app-lucky.git package/lucky

    # 更新并安装 feeds
    ./scripts/feeds update -a && ./scripts/feeds install -a

    # 进行编译
    make defconfig
    make download -j8
    make -j$(nproc) || make -j1 V=s
"

# 将编译后的文件从容器中移动到宿主机
docker cp immortalwrt-build-container:/home/user/openwrt/bin/targets /openwrt

sudo docker exec pre-immortalwrt-build-docker bash -c "
  find /home/user/openwrt/bin/targets -type f \
  \( -name '*immortalwrt*' -o \
#     -name '*version*' -o \
#     -name '*feeds*' -o \
     -name '*config*' \)" \
| while read file; do \
  sudo docker cp pre-immortalwrt-build-docker:$file /home/super/Downloads/$(basename $file); \
done


sudo docker exec pre-immortalwrt-build-docker bash -c "
  find /home/user/openwrt/bin/targets -type f \
  \( -name '*immortalwrt*' -o \
     -name '*config*' \)" \
| while read file; do \
  sudo docker cp pre-immortalwrt-build-docker:$file /home/super/Downloads/$(basename $file); \
done


