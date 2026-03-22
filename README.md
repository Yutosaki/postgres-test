# PostgreSQL 内部構造 勉強会：デバッグ体験ハンズオン

PostgreSQL のソースコードをビルドし、意図的にバグを仕込んで `gdb` で解析するまでの手順書です。

## 1. 公式ドキュメント
インストールの詳細な流れについては、以下の公式ドキュメントを参照してください。
- [PostgreSQL 16 ドキュメント: インストール手順](https://www.postgresql.jp/document/16/html/install-make.html)

---

## 2. ビルド・インストール手順

### ソースの構成（Configure）
デバッグシンボルを有効にし、最適化を無効化した状態で `Makefile` を作成します。
```bash
'./configure --prefix=$HOME/pgsql-debug --enable-debug --enable-cassert CFLAGS="-O0 -g"'

# ビルド（並列実行で高速化）
'make -j$(nproc)'

# インストール
'make install'

## 3. 環境変数設定

# 実行パスの追加
'export PATH="$HOME/pgsql-debug/bin:$PATH"'

# データディレクトリの場所指定
'export PGDATA="$HOME/pgdata"'

# 反映確認
'which postgres'

## 4. DBの初期化と起動

# 1. データベースの初期化
'initdb -p $PGDATA'

# 2. サーバの起動
'pg_ctl start -l logfile'

# 3. 動作確認用のDB作成と接続
'''
createdb testdb
psql testdb
'''

## 5. GDBの使用方法
'SELECT pg_backend_pid();'

`# プロセスにアタッチ
'gdb -p [確認したPID]'
