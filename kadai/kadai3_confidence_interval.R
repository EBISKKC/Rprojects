# 課題③ 母平均の95%信頼区間推定
# データの読み込み
data <- read.csv("cv.csv", header = TRUE)

# ken, area2, area3以外の変数を選択
numeric_vars <- data[, !names(data) %in% c("ken", "area2", "area3")]

# 結果を格納するデータフレームを作成
results <- data.frame(
  変数名 = character(),
  標本平均 = numeric(),
  標本標準偏差 = numeric(),
  標本サイズ = integer(),
  標準誤差 = numeric(),
  下側信頼限界 = numeric(),
  上側信頼限界 = numeric(),
  stringsAsFactors = FALSE
)

# 各変数について95%信頼区間を計算
for (col in names(numeric_vars)) {
  # 標本統計量を計算
  x <- numeric_vars[[col]]
  x <- x[!is.na(x)] # 欠損値を除く
  n <- length(x)
  mean_x <- mean(x)
  sd_x <- sd(x) # 標本標準偏差（n-1で割る）
  se <- sd_x / sqrt(n) # 標準誤差

  # t分布を使用した95%信頼区間
  alpha <- 0.05
  t_val <- qt(1 - alpha / 2, df = n - 1)
  lower <- mean_x - t_val * se
  upper <- mean_x + t_val * se

  results <- rbind(results, data.frame(
    変数名 = col,
    標本平均 = mean_x,
    標本標準偏差 = sd_x,
    標本サイズ = n,
    標準誤差 = se,
    下側信頼限界 = lower,
    上側信頼限界 = upper
  ))
}

# 結果を表示
print(results)

# openxlsxパッケージを読み込み
if (!require(openxlsx)) install.packages("openxlsx")
library(openxlsx)

# 既存のワークブックを読み込み（なければ新規作成）
if (file.exists("kadai_results.xlsx")) {
  wb <- loadWorkbook("kadai_results.xlsx")
} else {
  wb <- createWorkbook()
}

# 課題③のシートを追加
addWorksheet(wb, "課題3_95%信頼区間")
writeData(wb, "課題3_95%信頼区間", results)

# 列幅を自動調整
setColWidths(wb, "課題3_95%信頼区間", cols = 1:7, widths = "auto")

# ワークブックを保存
saveWorkbook(wb, "kadai_results.xlsx", overwrite = TRUE)

cat("\n課題③の95%信頼区間をkadai_results.xlsxに保存しました。\n")
