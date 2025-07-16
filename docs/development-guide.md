# Rプロジェクト開発ガイド

このドキュメントでは、Rプロジェクトのディレクトリ構成と効果的な開発方法について説明します。

## プロジェクトのディレクトリ構成

### 基本構造

```
Rprojects/
├── Rprojects.Rproj          # RStudioプロジェクトファイル
├── README.md                # プロジェクトの説明
├── Makefile                 # ビルドコマンド
├── .gitignore               # Git無視ファイル
├── .Rprofile                # R起動時設定
├── renv.lock                # パッケージ環境固定ファイル
├── renv/                    # renvディレクトリ
│   ├── library/             # プロジェクト専用パッケージ
│   └── settings.json        # renv設定
├── R/                       # Rスクリプト
├── data/                    # データファイル
├── docs/                    # ドキュメント
├── output/                  # 出力ファイル
├── tests/                   # テストファイル
└── test/                    # 既存のテストファイル（レガシー）
```

### 各ディレクトリの役割

#### **R/** - Rスクリプト
メインのRコードを格納します。

```
R/
├── data_processing.R        # データ処理スクリプト
├── visualization.R          # 可視化スクリプト
├── analysis.R               # 分析スクリプト
├── utils.R                  # 共通関数
└── config.R                 # 設定ファイル
```

**用途:**
- データ処理ロジック
- 分析関数
- 可視化関数
- 共通ユーティリティ

**命名規則:**
- 機能別にファイルを分割
- 小文字とアンダースコア使用
- 動詞 + 名詞の形式推奨

#### **data/** - データファイル
生データや処理済みデータを格納します。

```
data/
├── raw/                     # 生データ
│   ├── survey_data.csv
│   └── experimental_data.xlsx
├── processed/               # 処理済みデータ
│   ├── cleaned_data.csv
│   └── merged_data.rds
└── sample_data.csv          # サンプルデータ
```

**用途:**
- 生データ（raw）
- 処理済みデータ（processed）
- 中間データ
- サンプルデータ

**注意点:**
- 大きなファイルは.gitignoreに追加
- データの説明をREADMEに記載
- データの権利関係に注意

#### **docs/** - ドキュメント
プロジェクトの説明、分析結果、レポートを格納します。

```
docs/
├── project_overview.md      # プロジェクト概要
├── data_dictionary.md       # データ辞書
├── analysis_report.Rmd      # 分析レポート
├── analysis_report.html     # 生成されたレポート
├── presentation.Rmd         # プレゼンテーション
└── meeting_notes.md         # 会議メモ
```

**用途:**
- プロジェクト説明
- 分析レポート
- データ辞書
- 会議メモ
- プレゼンテーション

#### **output/** - 出力ファイル
分析結果、グラフ、モデルなどを格納します。

```
output/
├── figures/                 # グラフ・図表
│   ├── scatter_plot.png
│   ├── histogram.png
│   └── correlation_matrix.pdf
├── tables/                  # テーブル
│   ├── summary_stats.csv
│   └── model_results.xlsx
├── models/                  # 保存されたモデル
│   ├── regression_model.rds
│   └── ml_model.pkl
└── reports/                 # 生成されたレポート
    ├── monthly_report.pdf
    └── presentation.pptx
```

**用途:**
- 図表・グラフ
- 統計結果
- モデル保存
- 生成レポート

#### **tests/** - テストファイル
コードのテストを格納します。

```
tests/
├── test_data_processing.R   # データ処理テスト
├── test_analysis.R          # 分析テスト
├── test_utils.R             # ユーティリティテスト
└── test_data/               # テスト用データ
    └── small_dataset.csv
```

**用途:**
- ユニットテスト
- 統合テスト
- テスト用データ
- テスト設定

## 開発フローの基本

### 1. プロジェクトの初期化

```bash
# 新しいプロジェクトの場合
mkdir my-new-project
cd my-new-project

# プロジェクト構造を作成
make create-rproj
make setup-dirs
make renv-init
```

### 2. 依存関係の管理

```bash
# 必要なパッケージをインストール
make install

# フォーマット・lintツールをインストール
make deps

# 現在の環境を保存
make renv-snapshot
```

### 3. 日常的な開発サイクル

#### A. コーディング
```bash
# 1. VSCodeでプロジェクトを開く
code .

# 2. Rスクリプトを R/ フォルダに作成
# 例: R/data_analysis.R

# 3. コードを書く
```

#### B. テスト・品質チェック
```bash
# コードの品質チェック
make check

# 特定のファイルをテスト
make run FILE=R/data_analysis.R

# テストの実行
make test
```

#### C. ドキュメント生成
```bash
# 分析レポートの生成
make render-file FILE=docs/analysis_report.Rmd

# 全ドキュメントの生成
make render
```

#### D. 環境の保存
```bash
# パッケージ環境の保存
make renv-snapshot

# 不要ファイルの削除
make clean
```

## 実際の開発例

### プロジェクト: データ分析パイプライン

#### 1. プロジェクト設定
```bash
# プロジェクト初期化
make create-rproj
make setup-dirs
make renv-init
make install
```

#### 2. データ処理スクリプト作成
```r
# R/data_processing.R
library(dplyr)
library(readr)

# データ読み込み関数
load_raw_data <- function(file_path) {
  read_csv(file_path)
}

# データクリーニング関数
clean_data <- function(data) {
  data %>%
    filter(!is.na(value)) %>%
    mutate(
      date = as.Date(date),
      category = as.factor(category)
    )
}

# データ保存関数
save_processed_data <- function(data, file_path) {
  write_csv(data, file_path)
}
```

#### 3. 分析スクリプト作成
```r
# R/analysis.R
library(ggplot2)
library(broom)

# 記述統計関数
descriptive_stats <- function(data) {
  data %>%
    group_by(category) %>%
    summarise(
      n = n(),
      mean = mean(value),
      sd = sd(value),
      .groups = "drop"
    )
}

# 可視化関数
create_scatter_plot <- function(data) {
  ggplot(data, aes(x = x, y = y, color = category)) +
    geom_point() +
    theme_minimal() +
    labs(title = "散布図", x = "X軸", y = "Y軸")
}
```

#### 4. メインスクリプト作成
```r
# R/main.R
source("R/data_processing.R")
source("R/analysis.R")

# メイン処理
main <- function() {
  # データ読み込み
  raw_data <- load_raw_data("data/raw/input.csv")
  
  # データクリーニング
  clean_data <- clean_data(raw_data)
  
  # 処理済みデータ保存
  save_processed_data(clean_data, "data/processed/cleaned_data.csv")
  
  # 分析実行
  stats <- descriptive_stats(clean_data)
  
  # 可視化
  plot <- create_scatter_plot(clean_data)
  
  # 結果保存
  write_csv(stats, "output/tables/summary_stats.csv")
  ggsave("output/figures/scatter_plot.png", plot)
  
  cat("分析完了\n")
}

# 実行
if (interactive()) {
  main()
}
```

#### 5. 実行とテスト
```bash
# メインスクリプト実行
make run FILE=R/main.R

# コード品質チェック
make check

# 結果確認
make check-data FILE=output/tables/summary_stats.csv
```

#### 6. レポート作成
```r
# docs/analysis_report.Rmd
---
title: "データ分析レポート"
output: html_document
---

# 分析結果

## データ概要
`r read_csv("output/tables/summary_stats.csv") %>% kable()`

## 可視化結果
![散布図](../output/figures/scatter_plot.png)
```

```bash
# レポート生成
make render-file FILE=docs/analysis_report.Rmd
```

## 開発のベストプラクティス

### 1. コード組織
- 機能別にファイルを分割
- 共通関数は `R/utils.R` に配置
- 設定は `R/config.R` に集約

### 2. データ管理
- 生データは `data/raw/` に保存
- 処理済みデータは `data/processed/` に保存
- データの説明を `docs/data_dictionary.md` に記載

### 3. 出力管理
- 図表は `output/figures/` に保存
- 統計結果は `output/tables/` に保存
- モデルは `output/models/` に保存

### 4. ドキュメント
- プロジェクト概要を `docs/project_overview.md` に記載
- 分析結果を `docs/analysis_report.Rmd` に記載
- 定期的にドキュメントを更新

### 5. バージョン管理
- 定期的に `make renv-snapshot` を実行
- 重要な変更前に環境を保存
- `.gitignore` で不要ファイルを除外

## よくある問題と解決方法

### 問題1: パッケージが見つからない
```bash
# 解決方法
make renv-restore
```

### 問題2: 作業ディレクトリが間違っている
```r
# 確認
getwd()

# プロジェクトルートに移動
setwd(here::here())
```

### 問題3: メモリ不足
```r
# 大きなオブジェクトを削除
rm(large_object)
gc()

# データを分割処理
```

### 問題4: 実行時間が長い
```r
# 進捗バー表示
library(progress)
pb <- progress_bar$new(total = 100)

# 並列処理
library(parallel)
mclapply(data, function, mc.cores = detectCores())
```

## まとめ

このディレクトリ構成と開発フローを使用することで：

1. **組織化されたコード** - 機能別にファイルを分割
2. **再現可能な分析** - renvによる環境管理
3. **効率的な開発** - Makefileによる自動化
4. **品質の高いコード** - lintとフォーマットチェック
5. **包括的なドキュメント** - 分析結果の記録

効果的なRプロジェクト開発が可能になります。
