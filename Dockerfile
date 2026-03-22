FROM ubuntu:22.04

# 対話モードでの入力を防ぐ設定
ENV DEBIAN_FRONTEND=noninteractive

# 1. 必要なパッケージのインストール
# Postgresのビルド依存 + 開発ツール(neovim, git, tmux, gdb, ripgrep等)
RUN apt-get update && apt-get install -y \
    build-essential \
    libreadline-dev \
    zlib1g-dev \
    flex \
    bison \
    libxml2-dev \
    libxslt-dev \
    libssl-dev \
    libipc-run-perl \
    git \
    curl \
    wget \
    gdb \
    vim \
    neovim \
    tmux \
    ripgrep \
    sudo \
    tzdata \
    clangd \
    pkg-config \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. 作業用ユーザーの作成 (Postgresはrootで起動できないため必須)
# ここでは 'dev' というユーザーを作成し、パスワードなしsudoを許可します
RUN useradd -m -s /bin/bash dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 3. ユーザー切り替え
USER dev
WORKDIR /home/dev

# 4. chezmoi のインストール (バイナリをユーザーのローカルbinに配置)
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Yutosaki

# PATHを通しておく
ENV PATH="/home/dev/bin:$PATH"

# コンテナ起動時のデフォルトコマンド
CMD ["bash"]
