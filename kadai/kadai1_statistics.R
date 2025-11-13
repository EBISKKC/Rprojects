# 課題① 母平均、中央値、母分散、母標準偏差の計算
# データの読み込み
data <- read.csv("cv.csv", header = TRUE)

# ken, area2, area3以外の変数を選択
numeric_vars <- data[, !names(data) %in% c("ken", "area2", "area3")]

# 結果を格納するデータフレームを作成
results <- data.frame(
  変数名 = character(),
  母平均 = numeric(),
  中央値 = numeric(),
  母分散 = numeric(),
  母標準偏差 = numeric(),
  stringsAsFactors = FALSE
)

# 各変数について統計量を計算
for (col in names(numeric_vars)) {
  mean_val <- mean(numeric_vars[[col]], na.rm = TRUE)
  median_val <- median(numeric_vars[[col]], na.rm = TRUE)
  # 母分散（n で割る）
  n <- sum(!is.na(numeric_vars[[col]]))
  var_pop <- sum((numeric_vars[[col]] - mean_val)^2, na.rm = TRUE) / n
  # 母標準偏差
  sd_pop <- sqrt(var_pop)

  results <- rbind(results, data.frame(
    変数名 = col,
    母平均 = mean_val,
    中央値 = median_val,
    母分散 = var_pop,
    母標準偏差 = sd_pop
  ))
}

# 結果を表示
print(results)

# Excelファイルに書き出し（openxlsxパッケージを使用）
if (!require(openxlsx)) install.packages("openxlsx")
library(openxlsx)

# Excelワークブックを作成
wb <- createWorkbook()

# 課題①のシートを追加
addWorksheet(wb, "課題1_統計量")
writeData(wb, "課題1_統計量", results)

# 列幅を自動調整
setColWidths(wb, "課題1_統計量", cols = 1:5, widths = "auto")

# 一旦保存
saveWorkbook(wb, "kadai_results.xlsx", overwrite = TRUE)

cat("\n課題①の結果をkadai_results.xlsxに保存しました。\n")
