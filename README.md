# Rプロジェクト

このフォルダにはRのプロジェクトを配置できます。

エディタ上で
shift + command + Vを押せばpreviewを見ることができる。

## Rの起動方法
コンソールで
```bash
R
```
と打てば起動できる。


```bash
# フォーマット・lintツールの一括インストール
make deps

# 個別にフォーマット実行
make fmt

# 個別にlint実行
make lint
```

## データの中身を見る方法

### 基本的なデータ確認コマンド
```r
# データフレームの最初の6行を表示
head(data)

# データフレームの最後の6行を表示
tail(data)

# データフレームの構造を表示
str(data)

# データフレームの要約統計量を表示
summary(data)

# データフレームの次元（行数、列数）を表示
dim(data)

# 列名を表示
names(data)
colnames(data)

# データフレームの概要を表示
glimpse(data)  # dplyrパッケージが必要
```

### CSVファイルの読み込みと確認
```r
# CSVファイルの読み込み
data <- read.csv("ファイル名.csv")

# データの確認
head(data)
str(data)
summary(data)
```

### データの詳細確認
```r
# 欠損値の確認
sum(is.na(data))
colSums(is.na(data))

# ユニークな値の数
sapply(data, function(x) length(unique(x)))

# データ型の確認
sapply(data, class)
```

### ターミナルからのデータ確認
```bash
# CSVファイルの最初の数行を表示
head -10 ファイル名.csv

# CSVファイルの行数を確認
wc -l ファイル名.csv

# Rスクリプトでデータを確認
Rscript -e 'data <- read.csv("ファイル名.csv"); str(data); summary(data)'
```

## Makefile コマンド

プロジェクトにMakefileを追加したので、以下のコマンドで様々なタスクを実行できます：

### 基本的なコマンド
```bash
# 利用可能なコマンド一覧を表示
make help

# 全てのRファイルをフォーマット（stylerが自動でインストールされる）
make fmt

# 全てのRファイルをlint（lintrが自動でインストールされる）
make lint

# フォーマットとlintを両方実行
make check

# プロジェクトに必要なパッケージをインストール
make install

# フォーマット・lintツールをインストール
make deps
```

### 開発用コマンド
```bash
# 生成されたファイルを削除（PDF、HTML、aux、logなど）
make clean

# testディレクトリのRスクリプトを実行
make test

# 全てのRmdファイルをPDFに変換
make render

# R セッションを開始
make serve
```

### 個別ファイル操作
```bash
# 特定のファイルをフォーマット
make fmt-file FILE=test/gganimate.R

# 特定のファイルをlint
make lint-file FILE=test/gganimate.R

# 特定のRスクリプトを実行
make run FILE=test.r

# 特定のRmdファイルをPDFに変換
make render-file FILE=test.Rmd

# CSVファイルの内容を確認（head、wc、Rでの要約表示）
make check-data FILE=jikken-matuoka/matuoka.csv
```

### 推奨ワークフロー
```bash
# 1. 依存関係のインストール
make deps
make install

# 2. 開発中のフォーマットとlintチェック
make check

# 3. テストの実行
make test

# 4. 不要ファイルの削除
make clean
```

**注意**: 全てのMakefileコマンドはCRANミラーの問題を回避するために`repos = "https://cran.rstudio.com/"`を指定しています。

## Rプロジェクト管理 (.Rprojファイル対応)

RStudioプロジェクトファイル（.Rproj）を使用することで、プロジェクト単位での管理が可能になります。
VSCodeとRStudioの両方で同じプロジェクトを扱うことができます。

### プロジェクトセットアップ
```bash
# .Rprojファイルを作成（RStudio互換）
make create-rproj

# 標準的なRプロジェクトディレクトリを作成
make setup-dirs

# renvを初期化してパッケージ管理を開始
make renv-init
```

### renvパッケージ管理
```bash
# パッケージ環境を復元
make renv-restore

# 現在のパッケージ状態をスナップショット
make renv-snapshot
```

### プロジェクト構造
```
プロジェクト名/
├── プロジェクト名.Rproj        # プロジェクトファイル
├── renv.lock                   # renvロックファイル
├── renv/                       # renvディレクトリ
├── R/                          # Rコード
├── data/                       # データファイル
├── docs/                       # ドキュメント
├── output/                     # 出力ファイル
├── tests/                      # テストファイル
├── README.md                   # プロジェクト説明
├── Makefile                    # ビルドコマンド
└── .gitignore                  # Git無視ファイル
```

### 推奨ワークフロー
```bash
# 1. プロジェクトの初期化
make create-rproj
make setup-dirs
make renv-init

# 2. 依存関係のインストール
make deps
make install

# 3. 開発作業
# (Rコードの編集)

# 4. フォーマットとlintチェック
make check

# 5. テストの実行
make test

# 6. 環境のスナップショット
make renv-snapshot
```

詳細なドキュメントは `docs/rproject-management.md` を参照してください。

これでrのコードを動かすことができる。
```bash
# 直接実行
Rscript test.r

# Makefileを使用して実行
make run FILE=test.r
```

## RMarkdownのPDF出力

Rコンソール上で以下のコマンドを実行することで、`test.Rmd`ファイルをPDFとして出力できます。

```R
rmarkdown::render("test.Rmd")
```

また、ターミナルから以下のコマンドを実行することで、一発でPDFを出力することも可能です。

```bash
# 直接実行
Rscript -e 'rmarkdown::render("test.Rmd")'

# Makefileを使用して全てのRmdファイルを一括変換
make render

# Makefileを使用して特定のRmdファイルを変換
make render-file FILE=test.Rmd
```

作業するディレクトリをこのディレクトリの中で作ってファイルを管理していきましょう。

## おすすめコード描画方法

### GitHub Copilot（こパイロット）を活用したRコードの書き方

- コメントで「やりたいこと」を具体的に書くと、Copilotが適切なRコードを提案しやすくなります。
  - 例: `# データフレームの要約統計量を表示する` など
- 入力や出力の例をコメントで示すと、より意図に沿ったコードが生成されます。
- 複雑な処理は、手順を分けてコメントしながら書くと精度が上がります。
- 生成されたコードは必ず自分で動作確認し、必要に応じて修正しましょう。

#### プロンプトエンジニアリングの注意点
- 「何をしたいか」「どんなデータを使うか」「どんな出力が欲しいか」を明確に書く
- 英語でも日本語でもOKですが、曖昧な表現は避ける
- 例や期待する出力形式をコメントで示すと効果的
- Copilotの提案は万能ではないので、エラーや非効率な部分がないか必ず確認する

---

例：
```r
# データフレームdfの平均値を計算し、結果を表示する
mean(df$column)
```

```r
# サンプルデータを作成し、散布図を描画する
x <- rnorm(100)
y <- rnorm(100)
plot(x, y)
```
