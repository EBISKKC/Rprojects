# .rdsファイルの使用例デモンストレーション

library(ggplot2)
library(dplyr)

cat("=== .rdsファイルの使用例デモ ===\n\n")

# 1. 基本的なデータフレームの保存と読み込み
cat("1. 基本的なデータフレームの保存と読み込み\n")
sample_data <- data.frame(
  id = 1:100,
  name = paste("user", 1:100, sep = "_"),
  score = rnorm(100, 75, 10),
  grade = sample(c("A", "B", "C"), 100, replace = TRUE),
  date = seq(as.Date("2024-01-01"), by = "day", length.out = 100)
)

# .rdsファイルに保存
saveRDS(sample_data, "output/sample_data.rds")
cat("サンプルデータを output/sample_data.rds に保存しました\n")

# 読み込み
loaded_data <- readRDS("output/sample_data.rds")
cat("データを読み込みました - 行数:", nrow(loaded_data), "列数:", ncol(loaded_data), "\n\n")

# 2. 統計モデルの保存
cat("2. 統計モデルの保存\n")
linear_model <- lm(score ~ as.numeric(date), data = sample_data)
saveRDS(linear_model, "output/models/linear_model.rds")
cat("線形回帰モデルを output/models/linear_model.rds に保存しました\n")

# モデルの読み込みと使用
loaded_model <- readRDS("output/models/linear_model.rds")
cat("モデル係数:", coef(loaded_model)[1], ",", coef(loaded_model)[2], "\n")
cat("R-squared:", summary(loaded_model)$r.squared, "\n\n")

# 3. 複雑なオブジェクト（リスト）の保存
cat("3. 複雑なオブジェクトの保存\n")
analysis_results <- list(
  data = sample_data,
  model = linear_model,
  summary_stats = summary(sample_data$score),
  plot_data = sample_data %>%
    group_by(grade) %>%
    summarise(
      count = n(),
      mean_score = mean(score),
      sd_score = sd(score),
      .groups = "drop"
    ),
  metadata = list(
    analysis_date = Sys.Date(),
    r_version = R.version.string,
    total_observations = nrow(sample_data)
  )
)

saveRDS(analysis_results, "output/complete_analysis.rds")
cat("分析結果全体を output/complete_analysis.rds に保存しました\n")

# 4. ggplotオブジェクトの保存
cat("4. ggplotオブジェクトの保存\n")
scatter_plot <- ggplot(sample_data, aes(x = as.numeric(date), y = score, color = grade)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "スコアの時系列変化",
    x = "日付",
    y = "スコア",
    color = "グレード"
  ) +
  theme_minimal()

saveRDS(scatter_plot, "output/plots/scatter_plot.rds")
cat("ggplotオブジェクトを output/plots/scatter_plot.rds に保存しました\n")

# 5. 因子変数の保存（レベル情報も保持）
cat("5. 因子変数の保存\n")
ordered_grade <- factor(sample_data$grade,
  levels = c("C", "B", "A"),
  ordered = TRUE
)
saveRDS(ordered_grade, "output/ordered_grade.rds")

loaded_grade <- readRDS("output/ordered_grade.rds")
cat("因子レベル:", levels(loaded_grade), "\n")
cat("順序付き因子:", is.ordered(loaded_grade), "\n\n")

# 6. ファイルサイズの比較
cat("6. ファイルサイズの比較\n")
# CSVとの比較
write.csv(sample_data, "output/sample_data.csv", row.names = FALSE)

rds_size <- file.size("output/sample_data.rds")
csv_size <- file.size("output/sample_data.csv")

cat("RDSファイルサイズ:", rds_size, "バイト\n")
cat("CSVファイルサイズ:", csv_size, "バイト\n")
cat("RDSはCSVの", round(rds_size / csv_size * 100, 1), "%のサイズ\n\n")

# 7. 圧縮オプションの比較
cat("7. 圧縮オプションの比較\n")
# 異なる圧縮方法で保存
saveRDS(sample_data, "output/data_gzip.rds", compress = "gzip")
saveRDS(sample_data, "output/data_bzip2.rds", compress = "bzip2")
saveRDS(sample_data, "output/data_xz.rds", compress = "xz")

gzip_size <- file.size("output/data_gzip.rds")
bzip2_size <- file.size("output/data_bzip2.rds")
xz_size <- file.size("output/data_xz.rds")

cat("gzip圧縮:", gzip_size, "バイト\n")
cat("bzip2圧縮:", bzip2_size, "バイト\n")
cat("xz圧縮:", xz_size, "バイト\n\n")

# 8. 保存した分析結果の活用例
cat("8. 保存した分析結果の活用例\n")
# 完全な分析結果を読み込み
complete_results <- readRDS("output/complete_analysis.rds")

cat("保存されたデータの行数:", nrow(complete_results$data), "\n")
cat("保存されたモデルのR-squared:", summary(complete_results$model)$r.squared, "\n")
cat("分析実行日:", complete_results$metadata$analysis_date, "\n")

# 保存されたプロットを表示・保存
saved_plot <- readRDS("output/plots/scatter_plot.rds")
ggsave("output/figures/loaded_plot.png", saved_plot, width = 10, height = 6)
cat("保存されたプロットを output/figures/loaded_plot.png に出力しました\n\n")

# 9. 大きなオブジェクトの処理例
cat("9. 大きなオブジェクトの処理例\n")
# 大きなデータセットを作成
big_data <- data.frame(
  x = rnorm(100000),
  y = rnorm(100000),
  z = rnorm(100000),
  category = sample(letters[1:20], 100000, replace = TRUE)
)

# 処理時間の測定
start_time <- Sys.time()
saveRDS(big_data, "output/big_data.rds", compress = "bzip2")
save_time <- Sys.time() - start_time

start_time <- Sys.time()
loaded_big_data <- readRDS("output/big_data.rds")
load_time <- Sys.time() - start_time

cat("大きなデータ（", nrow(big_data), "行）の保存時間:", round(save_time, 2), "秒\n")
cat("大きなデータの読み込み時間:", round(load_time, 2), "秒\n")
cat("オブジェクトサイズ:", round(object.size(big_data) / 1024 / 1024, 2), "MB\n")
cat("ファイルサイズ:", round(file.size("output/big_data.rds") / 1024 / 1024, 2), "MB\n\n")

# 10. エラーハンドリングの例
cat("10. エラーハンドリングの例\n")
safe_load_rds <- function(file_path) {
  tryCatch(
    {
      readRDS(file_path)
    },
    error = function(e) {
      cat("エラー: ファイル", file_path, "を読み込めませんでした:", e$message, "\n")
      NULL
    }
  )
}

# 存在しないファイルの読み込み
result <- safe_load_rds("output/nonexistent.rds")
cat("存在しないファイルの読み込み結果:", is.null(result), "\n\n")

# 11. 実際の分析でのワークフロー例
cat("11. 実際の分析でのワークフロー例\n")
# ステップ1: データ前処理
processed_data <- sample_data %>%
  mutate(
    score_normalized = scale(score)[, 1],
    high_performer = score > quantile(score, 0.8)
  )
saveRDS(processed_data, "output/workflow_step1.rds")

# ステップ2: モデル構築
step1_data <- readRDS("output/workflow_step1.rds")
classification_model <- glm(high_performer ~ score_normalized + grade,
  data = step1_data,
  family = binomial()
)
saveRDS(classification_model, "output/workflow_step2.rds")

# ステップ3: 結果の統合
final_results <- list(
  processed_data = readRDS("output/workflow_step1.rds"),
  classification_model = readRDS("output/workflow_step2.rds"),
  predictions = predict(classification_model, step1_data, type = "response")
)
saveRDS(final_results, "output/workflow_final.rds")

cat("ワークフローの各ステップの結果を保存しました\n")
cat("最終結果の要素数:", length(final_results), "\n")

cat("\n=== デモンストレーション完了 ===\n")
cat("生成されたファイル:\n")
cat("- output/sample_data.rds\n")
cat("- output/models/linear_model.rds\n")
cat("- output/complete_analysis.rds\n")
cat("- output/plots/scatter_plot.rds\n")
cat("- output/figures/loaded_plot.png\n")
cat("- output/workflow_final.rds\n")
cat("など\n")
