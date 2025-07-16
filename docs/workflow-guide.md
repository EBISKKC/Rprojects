# Rプロジェクト ワークフロー実践ガイド

このドキュメントでは、日常的なRプロジェクト開発における具体的なワークフローを実例とともに説明します。

## 開発ワークフローの全体像

```
1. プロジェクト初期化
   ↓
2. データ収集・準備
   ↓
3. 探索的データ分析
   ↓
4. 分析・モデリング
   ↓
5. 結果の可視化
   ↓
6. レポート作成
   ↓
7. 成果物の整理
```

## 1. プロジェクト初期化

### 新規プロジェクトの場合

```bash
# 1. プロジェクトディレクトリを作成
mkdir sales_analysis_2024
cd sales_analysis_2024

# 2. プロジェクト構造を初期化
make create-rproj
make setup-dirs
make renv-init

# 3. 依存関係をインストール
make deps
make install

# 4. 初期コミット（Gitを使用する場合）
git init
git add .
git commit -m "Initial project setup"
```

### 既存プロジェクトの場合

```bash
# 1. プロジェクトをクローン
git clone https://github.com/username/sales_analysis_2024.git
cd sales_analysis_2024

# 2. 環境を復元
make renv-restore

# 3. 依存関係を確認
make deps
```

## 2. データ収集・準備

### データ収集スクリプト作成

```r
# R/data_collection.R
library(readr)
library(readxl)
library(httr)
library(jsonlite)

# CSVファイル読み込み
load_sales_data <- function(file_path) {
  read_csv(file_path, locale = locale(encoding = "UTF-8"))
}

# Excelファイル読み込み
load_customer_data <- function(file_path) {
  read_excel(file_path, sheet = "customers")
}

# API経由でデータ取得
fetch_product_data <- function(api_url) {
  response <- GET(api_url)
  content(response, "text") %>%
    fromJSON() %>%
    as.data.frame()
}

# データ収集実行
collect_all_data <- function() {
  # 売上データ
  sales <- load_sales_data("data/raw/sales_2024.csv")
  
  # 顧客データ
  customers <- load_customer_data("data/raw/customers.xlsx")
  
  # 商品データ
  products <- fetch_product_data("https://api.example.com/products")
  
  # 生データを保存
  write_csv(sales, "data/raw/sales_raw.csv")
  write_csv(customers, "data/raw/customers_raw.csv")
  write_csv(products, "data/raw/products_raw.csv")
  
  list(sales = sales, customers = customers, products = products)
}
```

### データ前処理スクリプト

```r
# R/data_preprocessing.R
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)

# データクリーニング
clean_sales_data <- function(sales_data) {
  sales_data %>%
    # 日付の変換
    mutate(
      order_date = ymd(order_date),
      year = year(order_date),
      month = month(order_date),
      quarter = quarter(order_date)
    ) %>%
    # 欠損値の処理
    filter(!is.na(amount), !is.na(customer_id)) %>%
    # 異常値の除去
    filter(amount > 0, amount < 1000000) %>%
    # 文字列の正規化
    mutate(
      product_name = str_trim(product_name),
      customer_name = str_to_title(customer_name)
    )
}

# データ統合
merge_datasets <- function(sales, customers, products) {
  sales %>%
    left_join(customers, by = "customer_id") %>%
    left_join(products, by = "product_id") %>%
    # 必要な列のみ選択
    select(
      order_date, year, month, quarter,
      customer_id, customer_name, customer_segment,
      product_id, product_name, product_category,
      amount, quantity, unit_price
    )
}

# 前処理実行
preprocess_data <- function() {
  # 生データ読み込み
  sales_raw <- read_csv("data/raw/sales_raw.csv")
  customers_raw <- read_csv("data/raw/customers_raw.csv")
  products_raw <- read_csv("data/raw/products_raw.csv")
  
  # データクリーニング
  sales_clean <- clean_sales_data(sales_raw)
  
  # データ統合
  merged_data <- merge_datasets(sales_clean, customers_raw, products_raw)
  
  # 処理済みデータ保存
  write_csv(merged_data, "data/processed/sales_processed.csv")
  
  merged_data
}
```

### 実行

```bash
# データ収集
make run FILE=R/data_collection.R

# データ前処理
make run FILE=R/data_preprocessing.R

# 結果確認
make check-data FILE=data/processed/sales_processed.csv
```

## 3. 探索的データ分析

### 探索的分析スクリプト

```r
# R/exploratory_analysis.R
library(ggplot2)
library(dplyr)
library(corrplot)
library(VIM)

# データ概要の取得
get_data_summary <- function(data) {
  summary_stats <- data %>%
    select(where(is.numeric)) %>%
    summary()
  
  missing_values <- data %>%
    summarise(across(everything(), ~ sum(is.na(.))))
  
  list(
    summary = summary_stats,
    missing = missing_values,
    dimensions = dim(data)
  )
}

# 基本統計量の可視化
create_summary_plots <- function(data) {
  # 売上金額の分布
  amount_hist <- ggplot(data, aes(x = amount)) +
    geom_histogram(bins = 50, fill = "steelblue", alpha = 0.7) +
    labs(title = "売上金額の分布", x = "売上金額", y = "頻度") +
    theme_minimal()
  
  # 月別売上推移
  monthly_sales <- data %>%
    group_by(year, month) %>%
    summarise(total_sales = sum(amount), .groups = "drop") %>%
    mutate(date = as.Date(paste(year, month, "01", sep = "-")))
  
  monthly_plot <- ggplot(monthly_sales, aes(x = date, y = total_sales)) +
    geom_line(color = "steelblue", size = 1) +
    geom_point(color = "steelblue", size = 2) +
    labs(title = "月別売上推移", x = "月", y = "売上金額") +
    theme_minimal()
  
  # 商品カテゴリ別売上
  category_sales <- data %>%
    group_by(product_category) %>%
    summarise(total_sales = sum(amount), .groups = "drop") %>%
    arrange(desc(total_sales))
  
  category_plot <- ggplot(category_sales, aes(x = reorder(product_category, total_sales), y = total_sales)) +
    geom_col(fill = "steelblue") +
    coord_flip() +
    labs(title = "商品カテゴリ別売上", x = "商品カテゴリ", y = "売上金額") +
    theme_minimal()
  
  list(
    amount_hist = amount_hist,
    monthly_plot = monthly_plot,
    category_plot = category_plot
  )
}

# 相関分析
analyze_correlations <- function(data) {
  numeric_data <- data %>%
    select(amount, quantity, unit_price) %>%
    na.omit()
  
  cor_matrix <- cor(numeric_data)
  
  # 相関行列の可視化
  corrplot(cor_matrix, method = "color", type = "upper", 
           order = "hclust", tl.cex = 0.8, tl.col = "black")
  
  cor_matrix
}

# 探索的分析実行
run_exploratory_analysis <- function() {
  # データ読み込み
  data <- read_csv("data/processed/sales_processed.csv")
  
  # データ概要
  summary_info <- get_data_summary(data)
  
  # 可視化
  plots <- create_summary_plots(data)
  
  # 相関分析
  correlations <- analyze_correlations(data)
  
  # 結果保存
  ggsave("output/figures/amount_distribution.png", plots$amount_hist)
  ggsave("output/figures/monthly_sales.png", plots$monthly_plot)
  ggsave("output/figures/category_sales.png", plots$category_plot)
  
  # 統計結果保存
  write_csv(as.data.frame(summary_info$summary), "output/tables/data_summary.csv")
  
  list(summary = summary_info, plots = plots, correlations = correlations)
}
```

### 実行

```bash
# 探索的分析実行
make run FILE=R/exploratory_analysis.R

# 生成された図表確認
ls output/figures/
ls output/tables/
```

## 4. 分析・モデリング

### 分析スクリプト

```r
# R/statistical_analysis.R
library(broom)
library(modelr)
library(forecast)

# 記述統計分析
descriptive_analysis <- function(data) {
  # 顧客セグメント別分析
  segment_analysis <- data %>%
    group_by(customer_segment) %>%
    summarise(
      customer_count = n_distinct(customer_id),
      total_sales = sum(amount),
      avg_order_value = mean(amount),
      median_order_value = median(amount),
      .groups = "drop"
    )
  
  # 商品別分析
  product_analysis <- data %>%
    group_by(product_category) %>%
    summarise(
      order_count = n(),
      total_sales = sum(amount),
      avg_unit_price = mean(unit_price),
      .groups = "drop"
    )
  
  list(
    segment_analysis = segment_analysis,
    product_analysis = product_analysis
  )
}

# 時系列分析
time_series_analysis <- function(data) {
  # 月次売上データ準備
  monthly_sales <- data %>%
    group_by(year, month) %>%
    summarise(total_sales = sum(amount), .groups = "drop") %>%
    arrange(year, month)
  
  # 時系列オブジェクト作成
  ts_data <- ts(monthly_sales$total_sales, frequency = 12, start = c(2024, 1))
  
  # 時系列分解
  decomposition <- decompose(ts_data)
  
  # 予測モデル
  forecast_model <- auto.arima(ts_data)
  forecast_result <- forecast(forecast_model, h = 6)
  
  list(
    ts_data = ts_data,
    decomposition = decomposition,
    forecast_model = forecast_model,
    forecast_result = forecast_result
  )
}

# 回帰分析
regression_analysis <- function(data) {
  # 売上金額を目的変数とした回帰分析
  model <- lm(amount ~ quantity + unit_price + customer_segment + product_category, data = data)
  
  # モデル診断
  model_summary <- tidy(model)
  model_metrics <- glance(model)
  
  # 予測値と残差
  predictions <- augment(model, data)
  
  list(
    model = model,
    summary = model_summary,
    metrics = model_metrics,
    predictions = predictions
  )
}

# 分析実行
run_statistical_analysis <- function() {
  # データ読み込み
  data <- read_csv("data/processed/sales_processed.csv")
  
  # 各種分析実行
  descriptive_results <- descriptive_analysis(data)
  ts_results <- time_series_analysis(data)
  regression_results <- regression_analysis(data)
  
  # 結果保存
  write_csv(descriptive_results$segment_analysis, "output/tables/segment_analysis.csv")
  write_csv(descriptive_results$product_analysis, "output/tables/product_analysis.csv")
  write_csv(regression_results$summary, "output/tables/regression_summary.csv")
  
  # モデル保存
  saveRDS(regression_results$model, "output/models/sales_regression_model.rds")
  saveRDS(ts_results$forecast_model, "output/models/forecast_model.rds")
  
  list(
    descriptive = descriptive_results,
    time_series = ts_results,
    regression = regression_results
  )
}
```

### 実行

```bash
# 統計分析実行
make run FILE=R/statistical_analysis.R

# 結果確認
make check-data FILE=output/tables/segment_analysis.csv
make check-data FILE=output/tables/regression_summary.csv
```

## 5. 結果の可視化

### 可視化スクリプト

```r
# R/visualization.R
library(ggplot2)
library(plotly)
library(gganimate)

# 分析結果の可視化
create_analysis_visualizations <- function() {
  # データ読み込み
  data <- read_csv("data/processed/sales_processed.csv")
  segment_analysis <- read_csv("output/tables/segment_analysis.csv")
  
  # 顧客セグメント別売上
  segment_plot <- ggplot(segment_analysis, aes(x = customer_segment, y = total_sales, fill = customer_segment)) +
    geom_col() +
    scale_fill_viridis_d() +
    labs(title = "顧客セグメント別売上", x = "顧客セグメント", y = "売上金額") +
    theme_minimal() +
    theme(legend.position = "none")
  
  # インタラクティブ散布図
  scatter_plot <- plot_ly(data, x = ~quantity, y = ~amount, color = ~product_category,
                         type = "scatter", mode = "markers",
                         hovertemplate = "<b>%{fullData.product_category}</b><br>" +
                                       "数量: %{x}<br>" +
                                       "売上: %{y}<br>" +
                                       "<extra></extra>") %>%
    layout(title = "数量と売上の関係",
           xaxis = list(title = "数量"),
           yaxis = list(title = "売上金額"))
  
  # アニメーション付き時系列グラフ
  monthly_data <- data %>%
    group_by(year, month, product_category) %>%
    summarise(total_sales = sum(amount), .groups = "drop") %>%
    mutate(date = as.Date(paste(year, month, "01", sep = "-")))
  
  animated_plot <- ggplot(monthly_data, aes(x = date, y = total_sales, color = product_category)) +
    geom_line(size = 1.2) +
    geom_point(size = 3) +
    scale_color_viridis_d() +
    labs(title = "商品カテゴリ別売上推移", x = "月", y = "売上金額") +
    theme_minimal() +
    transition_reveal(date)
  
  list(
    segment_plot = segment_plot,
    scatter_plot = scatter_plot,
    animated_plot = animated_plot
  )
}

# 可視化実行
run_visualization <- function() {
  plots <- create_analysis_visualizations()
  
  # 静的グラフ保存
  ggsave("output/figures/segment_sales.png", plots$segment_plot, width = 10, height = 6)
  
  # インタラクティブプロット保存
  htmlwidgets::saveWidget(plots$scatter_plot, "output/figures/interactive_scatter.html")
  
  # アニメーション保存
  anim <- animate(plots$animated_plot, width = 800, height = 600, fps = 10, duration = 8)
  anim_save("output/figures/sales_animation.gif", anim)
  
  plots
}
```

### 実行

```bash
# 可視化実行
make run FILE=R/visualization.R

# 生成されたファイル確認
ls output/figures/
```

## 6. レポート作成

### 分析レポート

```r
# docs/sales_analysis_report.Rmd
---
title: "売上分析レポート 2024"
author: "データ分析チーム"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_depth: 3
    theme: united
    highlight: tango
  pdf_document:
    toc: true
    latex_engine: xelatex
---

# エグゼクティブサマリー

本レポートは2024年の売上データを分析し、以下の主要な発見を得ました：

1. 総売上は前年比15%増加
2. プレミアム顧客セグメントが売上の60%を占める
3. 電子機器カテゴリが最も高い収益性

# データ概要

## データセット

```{r data-overview}
library(knitr)
data <- read_csv("../data/processed/sales_processed.csv")
cat("データ行数:", nrow(data), "\n")
cat("データ列数:", ncol(data), "\n")
```

## 期間
- 分析期間: 2024年1月〜12月
- 総注文数: `r nrow(data)` 件

# 分析結果

## 顧客セグメント別分析

```{r segment-analysis}
segment_data <- read_csv("../output/tables/segment_analysis.csv")
kable(segment_data, caption = "顧客セグメント別売上")
```

![顧客セグメント別売上](../output/figures/segment_sales.png)

## 商品カテゴリ別分析

```{r product-analysis}
product_data <- read_csv("../output/tables/product_analysis.csv")
kable(product_data, caption = "商品カテゴリ別分析")
```

## 時系列分析

![月別売上推移](../output/figures/monthly_sales.png)

## 回帰分析結果

```{r regression-results}
regression_data <- read_csv("../output/tables/regression_summary.csv")
kable(regression_data, caption = "回帰分析結果")
```

# 結論と推奨事項

## 主要な発見

1. **顧客セグメント**: プレミアム顧客の重要性
2. **商品カテゴリ**: 電子機器の高収益性
3. **季節性**: 12月の売上ピーク

## 推奨事項

1. プレミアム顧客向けのロイヤリティプログラム強化
2. 電子機器カテゴリの商品ラインナップ拡充
3. 季節性を考慮した在庫管理の改善

# 付録

## 分析環境

- R version: `r R.version.string`
- 分析実行日: `r Sys.Date()`
- 使用パッケージ: dplyr, ggplot2, broom, forecast

## データ品質

- 欠損値: 0.5%未満
- 異常値: 除去済み
- データ検証: 完了
```

### 実行

```bash
# レポート生成
make render-file FILE=docs/sales_analysis_report.Rmd

# 生成されたレポート確認
open docs/sales_analysis_report.html
```

## 7. 成果物の整理

### 最終チェック

```bash
# 1. コード品質チェック
make check

# 2. テスト実行
make test

# 3. 全ドキュメント生成
make render

# 4. 環境保存
make renv-snapshot

# 5. 不要ファイル削除
make clean
```

### 成果物の確認

```bash
# プロジェクト構造確認
tree -I 'renv|.git'

# 出力ファイル確認
ls -la output/figures/
ls -la output/tables/
ls -la output/models/
ls -la docs/
```

### 最終的なプロジェクト構造

```
sales_analysis_2024/
├── README.md
├── Makefile
├── sales_analysis_2024.Rproj
├── renv.lock
├── R/
│   ├── data_collection.R
│   ├── data_preprocessing.R
│   ├── exploratory_analysis.R
│   ├── statistical_analysis.R
│   └── visualization.R
├── data/
│   ├── raw/
│   │   ├── sales_2024.csv
│   │   └── customers.xlsx
│   └── processed/
│       └── sales_processed.csv
├── docs/
│   ├── sales_analysis_report.Rmd
│   └── sales_analysis_report.html
├── output/
│   ├── figures/
│   │   ├── segment_sales.png
│   │   ├── monthly_sales.png
│   │   └── interactive_scatter.html
│   ├── tables/
│   │   ├── segment_analysis.csv
│   │   └── regression_summary.csv
│   └── models/
│       ├── sales_regression_model.rds
│       └── forecast_model.rds
└── tests/
    └── test_data_processing.R
```

## まとめ

このワークフローにより、以下が実現できます：

1. **体系的な分析プロセス**
2. **再現可能な結果**
3. **品質の高いコード**
4. **包括的なドキュメント**
5. **効率的な共同作業**

各ステップで適切なツールとMakefileコマンドを使用することで、効率的で品質の高いデータ分析プロジェクトを実行できます。

## 補足: .rdsファイルについて

### .rdsファイルとは

.rdsファイルは、**R Data Serialization**の略で、Rの任意のオブジェクトを保存するためのRネイティブのバイナリファイル形式です。

### 基本的な使い方

```r
# オブジェクトの保存
my_data <- data.frame(x = 1:10, y = rnorm(10))
saveRDS(my_data, "output/models/my_data.rds")

# オブジェクトの読み込み
loaded_data <- readRDS("output/models/my_data.rds")
```

### .rdsファイルの特徴

#### 1. **任意のRオブジェクトを保存可能**
```r
# データフレーム
df <- data.frame(a = 1:5, b = letters[1:5])
saveRDS(df, "data.rds")

# リスト
my_list <- list(numbers = 1:10, text = "hello", logical = TRUE)
saveRDS(my_list, "list.rds")

# 関数
my_function <- function(x) x^2
saveRDS(my_function, "function.rds")

# 統計モデル
model <- lm(mpg ~ wt, data = mtcars)
saveRDS(model, "model.rds")

# 複雑なオブジェクト
complex_object <- list(
  data = mtcars,
  model = lm(mpg ~ wt, data = mtcars),
  plot = ggplot(mtcars, aes(wt, mpg)) + geom_point()
)
saveRDS(complex_object, "complex.rds")
```

#### 2. **データ型とメタデータの完全保存**
```r
# 因子変数も正確に保存される
factor_data <- factor(c("low", "medium", "high"), 
                     levels = c("low", "medium", "high"), 
                     ordered = TRUE)
saveRDS(factor_data, "factor.rds")

# 読み込み時も同じ構造
loaded_factor <- readRDS("factor.rds")
str(loaded_factor)  # 因子レベルも保持される
```

#### 3. **高い圧縮率**
```r
# 大きなデータフレーム
big_data <- data.frame(
  x = rnorm(1000000),
  y = rnorm(1000000),
  group = sample(letters[1:10], 1000000, replace = TRUE)
)

# 圧縮保存
saveRDS(big_data, "big_data.rds", compress = TRUE)
# または
saveRDS(big_data, "big_data.rds", compress = "gzip")  # デフォルト
saveRDS(big_data, "big_data.rds", compress = "bzip2")  # より高圧縮
```

### 実際の使用例

#### 1. **機械学習モデルの保存**
```r
# R/model_training.R
library(randomForest)

train_model <- function() {
  # データ準備
  data <- read_csv("data/processed/sales_processed.csv")
  
  # モデル訓練
  rf_model <- randomForest(amount ~ quantity + unit_price + customer_segment, 
                          data = data, ntree = 100)
  
  # モデル保存
  saveRDS(rf_model, "output/models/random_forest_model.rds")
  
  # 予測精度も保存
  predictions <- predict(rf_model, data)
  accuracy_metrics <- list(
    rmse = sqrt(mean((data$amount - predictions)^2)),
    mae = mean(abs(data$amount - predictions)),
    r_squared = cor(data$amount, predictions)^2
  )
  saveRDS(accuracy_metrics, "output/models/model_metrics.rds")
  
  rf_model
}
```

#### 2. **分析結果の保存**
```r
# R/analysis_results.R
save_analysis_results <- function() {
  # 複数の分析結果をまとめて保存
  analysis_results <- list(
    descriptive_stats = read_csv("output/tables/segment_analysis.csv"),
    regression_model = readRDS("output/models/sales_regression_model.rds"),
    time_series_forecast = readRDS("output/models/forecast_model.rds"),
    plots = list(
      segment_plot = readRDS("output/plots/segment_plot.rds"),
      time_series_plot = readRDS("output/plots/ts_plot.rds")
    ),
    metadata = list(
      analysis_date = Sys.Date(),
      r_version = R.version.string,
      packages_used = c("dplyr", "ggplot2", "forecast")
    )
  )
  
  saveRDS(analysis_results, "output/analysis_complete_results.rds")
}
```

#### 3. **中間処理結果の保存**
```r
# R/data_processing_pipeline.R
process_data_pipeline <- function() {
  # ステップ1: データクリーニング
  raw_data <- read_csv("data/raw/sales_2024.csv")
  clean_data <- clean_sales_data(raw_data)
  saveRDS(clean_data, "data/processed/step1_cleaned.rds")
  
  # ステップ2: 特徴量エンジニアリング
  clean_data <- readRDS("data/processed/step1_cleaned.rds")
  engineered_data <- create_features(clean_data)
  saveRDS(engineered_data, "data/processed/step2_engineered.rds")
  
  # ステップ3: 最終データ
  engineered_data <- readRDS("data/processed/step2_engineered.rds")
  final_data <- finalize_data(engineered_data)
  saveRDS(final_data, "data/processed/final_data.rds")
}
```

### .rdsファイルの利点

#### 1. **完全性**
- Rオブジェクトの構造を完全に保持
- データ型、属性、クラス情報を保持
- 因子レベル、日付形式なども正確に保存

#### 2. **効率性**
- バイナリ形式で高速な読み書き
- 優れた圧縮率
- メモリ効率が良い

#### 3. **互換性**
- R専用形式でRとの完全互換
- 複雑なオブジェクトも保存可能
- バージョン間の互換性も高い

### 他のファイル形式との比較

| 形式 | 用途 | 利点 | 欠点 |
|------|------|------|------|
| .rds | Rオブジェクト保存 | 完全性、効率性 | R専用 |
| .csv | データ交換 | 汎用性 | データ型情報消失 |
| .xlsx | スプレッドシート | 視覚的編集 | 大きなファイルサイズ |
| .json | Web・API | 構造化データ | R固有の型に対応困難 |

### 実践的な使用パターン

#### 1. **分析パイプライン**
```bash
# 1. データ処理（重い処理）
make run FILE=R/heavy_processing.R
# → 結果を .rds で保存

# 2. 分析（軽い処理）
make run FILE=R/quick_analysis.R
# → .rds から読み込んで分析
```

#### 2. **モデル開発**
```r
# 訓練済みモデルの保存
trained_model <- train_complex_model(data)
saveRDS(trained_model, "output/models/production_model.rds")

# 本番環境での使用
production_model <- readRDS("output/models/production_model.rds")
predictions <- predict(production_model, new_data)
```

#### 3. **結果の共有**
```r
# 分析結果パッケージ
analysis_package <- list(
  data = processed_data,
  models = list(rf = rf_model, lm = linear_model),
  plots = list(scatter = p1, histogram = p2),
  summary = summary_stats
)
saveRDS(analysis_package, "shared_analysis_results.rds")
```

### 注意点

#### 1. **バージョン互換性**
```r
# バージョン情報を含めて保存
saveRDS(list(
  data = my_data,
  r_version = R.version.string,
  package_versions = sessionInfo()
), "versioned_data.rds")
```

#### 2. **ファイルサイズ**
```r
# 非常に大きなオブジェクトの場合
object.size(big_object)  # サイズ確認
saveRDS(big_object, "big_object.rds", compress = "bzip2")  # 高圧縮
```

#### 3. **エラーハンドリング**
```r
# 安全な読み込み
safe_load_rds <- function(file_path) {
  tryCatch({
    readRDS(file_path)
  }, error = function(e) {
    cat("Error loading", file_path, ":", e$message, "\n")
    NULL
  })
}
```

.rdsファイルは、Rでの分析作業において中間結果の保存、モデルの永続化、複雑なオブジェクトの共有に非常に便利な形式です。
