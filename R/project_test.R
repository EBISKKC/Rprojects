# プロジェクトのテスト用Rスクリプト
# このファイルは.Rprojファイルとrenvを使った開発の例を示します

# パッケージの読み込み
library(ggplot2)
library(dplyr)

# 作業ディレクトリの確認
cat("現在の作業ディレクトリ:", getwd(), "\n")

# プロジェクトの構造を確認
cat("プロジェクトの構造:\n")
list.files(recursive = TRUE) %>%
  head(10) %>%
  cat(sep = "\n")

# サンプルデータの作成
set.seed(123)
sample_data <- data.frame(
  x = rnorm(100),
  y = rnorm(100),
  group = sample(c("A", "B", "C"), 100, replace = TRUE)
)

# データをdata/フォルダに保存
write.csv(sample_data, "data/sample_data.csv", row.names = FALSE)
cat("サンプルデータを data/sample_data.csv に保存しました\n")

# 基本的なデータ分析
cat("データの要約:\n")
print(summary(sample_data))

# データの可視化
p <- ggplot(sample_data, aes(x = x, y = y, color = group)) +
  geom_point(alpha = 0.7) +
  labs(
    title = "サンプルデータの散布図",
    subtitle = "プロジェクト管理のテスト",
    x = "X軸",
    y = "Y軸"
  ) +
  theme_minimal()

# グラフをoutput/フォルダに保存
ggsave("output/sample_plot.png", p, width = 8, height = 6)
cat("グラフを output/sample_plot.png に保存しました\n")

# プロジェクトの情報を表示
cat("\n=== プロジェクト情報 ===\n")
cat("プロジェクト名:", basename(getwd()), "\n")
cat("Rのバージョン:", R.version.string, "\n")

# renvの状態を確認
if (requireNamespace("renv", quietly = TRUE)) {
  cat("renv が有効になっています\n")
  cat("renv ライブラリパス:", renv::paths$library(), "\n")
} else {
  cat("renv が利用できません\n")
}

cat("\n=== テスト完了 ===\n")
cat("この結果はプロジェクトの .Rproj ファイルと renv により管理されています\n")
