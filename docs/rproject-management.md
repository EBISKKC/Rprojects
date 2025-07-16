# Rプロジェクト管理 (.Rprojファイル対応)

RStudioプロジェクトファイル（.Rproj）を使用することで、プロジェクト単位での管理が可能になります。
VSCodeとRStudioの両方で同じプロジェクトを扱うことができます。

## .Rprojファイルとは

.Rprojファイルは、RStudioプロジェクトの設定を保存するファイルです。以下の情報が含まれます：

- プロジェクトの作業ディレクトリ
- プロジェクトの設定（コード補完、デバッグ設定など）
- プロジェクトの環境設定
- パッケージの依存関係

## .Rprojファイルの作成方法

### 1. 手動で作成
プロジェクトルートディレクトリに `.Rproj` ファイルを作成します。

### 2. RStudioで作成
1. RStudioを開く
2. File → New Project → Existing Directory
3. プロジェクトフォルダを選択
4. Create Project をクリック

### 3. VSCodeで作成
VSCodeの拡張機能「R」を使用して、.Rprojファイルを作成できます。

## .Rprojファイルの基本構造

```
Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

RnwWeave: Sweave
LaTeX: pdfLaTeX

AutoAppendNewline: Yes
StripTrailingWhitespace: Yes
LineEndingConversion: Posix

BuildType: Package
PackageUseDevtools: Yes
PackageInstallArgs: --no-multiarch --with-keep.source
PackageRoxygenize: rd,collate,namespace
```

## プロジェクト管理の利点

### 1. 作業ディレクトリの自動設定
プロジェクトを開くと、作業ディレクトリが自動的にプロジェクトルートに設定されます。

### 2. 環境の分離
プロジェクトごとに独立した環境を維持できます。

### 3. 設定の共有
チームメンバー間で同じプロジェクト設定を共有できます。

### 4. パッケージ管理
`renv`パッケージと組み合わせて、プロジェクトごとのパッケージ管理が可能です。

## VSCodeとRStudioの併用

### 共通の利点
- 同じプロジェクト構造を使用
- 同じ.Rprojファイルを共有
- 同じパッケージ環境を使用

### VSCodeでの作業
```bash
# VSCodeでプロジェクトを開く
code .

# Rターミナルでプロジェクトを確認
R
getwd()  # プロジェクトルートが表示される
```

### RStudioでの作業
1. RStudioを開く
2. File → Open Project
3. .Rprojファイルを選択

## renvパッケージとの連携

プロジェクトごとのパッケージ管理を行うために、`renv`パッケージを使用できます。

### 基本的な使用方法

```r
# renvの初期化
renv::init()

# パッケージのインストール
install.packages("ggplot2")

# 現在の環境をスナップショット
renv::snapshot()

# 環境の復元
renv::restore()

# プロジェクトの状態確認
renv::status()
```

### Makefileとの連携

```bash
# renvの初期化
make renv-init

# パッケージの復元
make renv-restore

# 環境のスナップショット
make renv-snapshot
```

## プロジェクトの推奨構造

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

## 実践例

### 1. プロジェクトの作成
```bash
# プロジェクトディレクトリを作成
mkdir my-r-project
cd my-r-project

# .Rprojファイルを作成
make create-rproj

# 必要なディレクトリを作成
make setup-dirs

# renvを初期化
make renv-init
```

### 2. 開発の流れ
```bash
# 1. プロジェクトを開く
code .

# 2. 依存関係をインストール
make install

# 3. 開発作業
# (Rコードの編集)

# 4. フォーマットとlint
make check

# 5. テストの実行
make test

# 6. 環境のスナップショット
make renv-snapshot
```

## トラブルシューティング

### 問題1: 作業ディレクトリが設定されない
```r
# 現在のディレクトリを確認
getwd()

# プロジェクトルートに移動
setwd("プロジェクトパス")
```

### 問題2: パッケージが見つからない
```r
# renvの状態確認
renv::status()

# パッケージの復元
renv::restore()
```

### 問題3: VSCodeでRプロジェクトが認識されない
1. VSCodeのR拡張機能を確認
2. R.exe のパスを確認
3. プロジェクトを再読み込み

## 参考資料

### 関連ドキュメント
- [開発ガイド](development-guide.md) - ディレクトリ構成と開発方法の詳細
- [ワークフローガイド](workflow-guide.md) - 実際の開発フローの実践例
- [プロジェクトテスト](project_test.html) - 動作確認結果

### 外部リンク
- [RStudio Projects](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects)
- [renv package](https://rstudio.github.io/renv/)
- [R for VSCode](https://github.com/REditorSupport/vscode-R)
