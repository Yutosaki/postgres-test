# PostgreSQL 内部構造 勉強会：デバッグ体験ハンズオン

PostgreSQL のソースコードをビルドし、意図的にバグを仕込んで `gdb` で解析するまでの手順書です。

---

## 1. 公式ドキュメント

インストールの詳細な流れについては、以下の公式ドキュメントを参照してください。

* [https://www.postgresql.jp/document/16/html/install-make.html](https://www.postgresql.jp/document/16/html/installation.html)

---

## 2. ビルド・インストール手順

### ソースの構成（configure）

デバッグシンボルを有効にし、最適化を無効化した状態で `Makefile` を作成します。

```bash
./configure --prefix=$HOME/pgsql-debug --enable-debug --enable-cassert CFLAGS="-O0 -g"
```

### ビルド（並列実行）

```bash
make -j$(nproc)
```

### インストール

```bash
make install
```

---

## 3. 環境変数設定

### 実行パスの追加

```bash
export PATH="$HOME/pgsql-debug/bin:$PATH"
```

### データディレクトリの指定

```bash
export PGDATA="$HOME/pgdata"
```

### 反映確認

```bash
which postgres
```

---

## 4. DB の初期化と起動

### データベースの初期化

```bash
initdb -D $PGDATA
```

### サーバの起動

```bash
pg_ctl start -l logfile
```

### 動作確認（DB 作成と接続）

```bash
createdb testdb
psql testdb
```

---

## 5. GDB の使用方法

### バックエンドプロセスの PID を取得

```sql
SELECT pg_backend_pid();
```

### プロセスにアタッチ

```bash
gdb -p <PID>
```

---

## 補足

* `--enable-debug` と `-O0 -g` により、最適化を無効化しつつ詳細なデバッグ情報を付与しています。
* `--enable-cassert` により、アサーションチェックが有効化され、内部不整合の検出が容易になります。
* `gdb` ではブレークポイント設定（`break`）やスタックトレース確認（`bt`）が重要です。
