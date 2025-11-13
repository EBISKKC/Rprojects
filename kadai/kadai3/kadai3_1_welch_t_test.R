# 課題① ウェルチのt検定
# 東日本と西日本で平均値に有意な差があるかを検証

# データの読み込み
data <- read.csv("../cv.csv", header = TRUE)

cat("=================================================\n")
cat("課題① ウェルチのt検定\n")
cat("東日本 vs 西日本の平均値の差の検定\n")
cat("=================================================\n\n")

# 連続変数を選択（ken, area2, area3以外）
continuous_vars <- names(data)[!names(data) %in% c("ken", "area2", "area3")]

# 結果を格納するデータフレーム
results <- data.frame(
  変数名 = character(),
  東日本平均 = numeric(),
  西日本平均 = numeric(),
  t値 = numeric(),
  自由度 = numeric(),
  p値 = numeric(),
  有意差 = character(),
  stringsAsFactors = FALSE
)

# 各変数についてウェルチのt検定を実行
for (var in continuous_vars) {
  # 東日本と西日本のデータを抽出
  higashi <- data[data$area2 == "higashi", var]
  nishi <- data[data$area2 == "nishi", var]

  # ウェルチのt検定（等分散性を仮定しない）
  test_result <- t.test(higashi, nishi, var.equal = FALSE)

  # 平均値
  mean_higashi <- mean(higashi, na.rm = TRUE)
  mean_nishi <- mean(nishi, na.rm = TRUE)

  # p値に基づく有意差の判定
  significance <- ifelse(test_result$p.value < 0.01, "**（1%水準で有意）",
    ifelse(test_result$p.value < 0.05, "*（5%水準で有意）",
      "有意差なし"
    )
  )

  # 結果を追加
  results <- rbind(results, data.frame(
    変数名 = var,
    東日本平均 = mean_higashi,
    西日本平均 = mean_nishi,
    t値 = test_result$statistic,
    自由度 = test_result$parameter,
    p値 = test_result$p.value,
    有意差 = significance
  ))
}

# 結果を表示
print(results)

cat("\n=================================================\n")
cat("解説\n")
cat("=================================================\n")
cat("**：p < 0.01（1%水準で有意）\n")
cat("*：p < 0.05（5%水準で有意）\n")
cat("有意差なし：p >= 0.05\n\n")

# 有意差がある変数をリストアップ
significant_vars <- results[results$p値 < 0.05, ]
if (nrow(significant_vars) > 0) {
  cat("有意差が認められた変数:\n")
  for (i in 1:nrow(significant_vars)) {
    cat(sprintf(
      "- %s: 東日本平均=%.2f, 西日本平均=%.2f (p=%.4f)\n",
      significant_vars$変数名[i],
      significant_vars$東日本平均[i],
      significant_vars$西日本平均[i],
      significant_vars$p値[i]
    ))
  }
} else {
  cat("有意差が認められた変数はありません。\n")
}

# Excelファイルに保存
if (!require(openxlsx)) install.packages("openxlsx")
library(openxlsx)

wb <- createWorkbook()
addWorksheet(wb, "ウェルチのt検定")
writeData(wb, "ウェルチのt検定", results)
setColWidths(wb, "ウェルチのt検定", cols = 1:7, widths = "auto")

saveWorkbook(wb, "kadai3_results.xlsx", overwrite = TRUE)

cat("\n結果を kadai3_results.xlsx に保存しました。\n")
