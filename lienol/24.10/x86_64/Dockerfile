FROM debian:11

# 设置工作目录
WORKDIR /root
USER root

# 安装所需的工具和依赖
RUN apt-get update -qq && apt-get install -qqy --no-install-recommends ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
    bzip2 ccache clang cmake cpio curl device-tree-compiler ecj fastjar flex gawk gettext gcc-multilib \
    g++-multilib git gnutls-dev gperf haveged help2man intltool lib32gcc-s1 libc6-dev-i386 libelf-dev \
    libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses-dev libpython3-dev \
    libreadline-dev libssl-dev libtool libyaml-dev libz-dev lld llvm lrzsz mkisofs msmtp nano \
    ninja-build p7zip p7zip-full patch pkgconf python3 python3-pip python3-ply python3-docutils \
    python3-pyelftools qemu-utils re2c rsync scons squashfs-tools subversion swig texinfo uglifyjs \
    upx-ucl unzip vim wget xmlto xxd zlib1g-dev zstd sudo \
    flex gawk  grep  libc-dev  perl rsync subversion unzip screen

    #无法安装的包：
    #diff find getopt install make4.1+ which

# 创建一个用户来执行编译（避免使用 root 权限）
RUN useradd -m user

# 设置 /home/user 目录的权限为 755，确保 user 用户有权限访问
RUN chown -R user:user /home/user/

# 为 user 用户设置免密码 sudo 权限
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# 设置容器启动命令（如果需要）
CMD ["bash"]
