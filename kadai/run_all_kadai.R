# すべての課題を実行する統合スクリプト
# 作業ディレクトリを設定（このスクリプトがあるディレクトリに設定）
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

cat("=================================================\n")
cat("課題の分析を開始します\n")
cat("=================================================\n\n")

# データの読み込み
cat("データを読み込んでいます...\n")
data <- read.csv("cv.csv", header = TRUE)
cat("データの読み込みが完了しました。\n")
cat("データサイズ:", nrow(data), "行 ×", ncol(data), "列\n\n")

# ken, area2, area3以外の変数を選択
numeric_vars <- data[, !names(data) %in% c("ken", "area2", "area3")]
cat("分析対象変数:", paste(names(numeric_vars), collapse = ", "), "\n\n")

# openxlsxパッケージの確認とインストール
if (!require(openxlsx)) {
  cat("openxlsxパッケージをインストールしています...\n")
  install.packages("openxlsx")
}
library(openxlsx)

# Excelワークブックを作成
wb <- createWorkbook()

# =================================================
# 課題① 母平均、中央値、母分散、母標準偏差の計算
# =================================================
cat("=================================================\n")
cat("課題① 基本統計量の計算\n")
cat("=================================================\n")

results1 <- data.frame(
  変数名 = character(),
  母平均 = numeric(),
  中央値 = numeric(),
  母分散 = numeric(),
  母標準偏差 = numeric(),
  stringsAsFactors = FALSE
)

for (col in names(numeric_vars)) {
  mean_val <- mean(numeric_vars[[col]], na.rm = TRUE)
  median_val <- median(numeric_vars[[col]], na.rm = TRUE)
  n <- sum(!is.na(numeric_vars[[col]]))
  var_pop <- sum((numeric_vars[[col]] - mean_val)^2, na.rm = TRUE) / n
  sd_pop <- sqrt(var_pop)

  results1 <- rbind(results1, data.frame(
    変数名 = col,
    母平均 = mean_val,
    中央値 = median_val,
    母分散 = var_pop,
    母標準偏差 = sd_pop
  ))
}

print(results1)
cat("\n")

# 課題①のシートを追加
addWorksheet(wb, "課題1_統計量")
writeData(wb, "課題1_統計量", results1)
setColWidths(wb, "課題1_統計量", cols = 1:5, widths = "auto")

cat("課題①が完了しました。\n\n")

# =================================================
# 課題② ヒストグラムの作成
# =================================================
cat("=================================================\n")
cat("課題② ヒストグラムの作成\n")
cat("=================================================\n")

# 課題②のシートを追加
addWorksheet(wb, "課題2_ヒストグラム")

# ヒストグラムディレクトリを作成
if (!dir.exists("histograms")) {
  dir.create("histograms")
}

row_position <- 1

for (col in names(numeric_vars)) {
  cat("  ", col, "のヒストグラムを作成中...\n")

  filename <- paste0("histograms/histogram_", col, ".png")

  png(filename, width = 600, height = 400)
  hist(numeric_vars[[col]],
    main = paste(col, "のヒストグラム"),
    xlab = col,
    ylab = "度数",
    col = "lightblue",
    border = "black"
  )
  dev.off()

  # Excelシートに画像を挿入
  insertImage(wb, "課題2_ヒストグラム",
    file = filename,
    startRow = row_position,
    startCol = 1,
    width = 6,
    height = 4
  )

  # 変数名をラベルとして追加
  writeData(wb, "課題2_ヒストグラム",
    x = col,
    startRow = row_position,
    startCol = 8
  )

  row_position <- row_position + 21
}

cat("課題②が完了しました。\n\n")

# =================================================
# 課題③ 母平均の95%信頼区間推定
# =================================================
cat("=================================================\n")
cat("課題③ 95%信頼区間の推定\n")
cat("=================================================\n")

results3 <- data.frame(
  変数名 = character(),
  標本平均 = numeric(),
  標本標準偏差 = numeric(),
  標本サイズ = integer(),
  標準誤差 = numeric(),
  下側信頼限界 = numeric(),
  上側信頼限界 = numeric(),
  stringsAsFactors = FALSE
)

for (col in names(numeric_vars)) {
  x <- numeric_vars[[col]]
  x <- x[!is.na(x)]
  n <- length(x)
  mean_x <- mean(x)
  sd_x <- sd(x)
  se <- sd_x / sqrt(n)

  alpha <- 0.05
  t_val <- qt(1 - alpha / 2, df = n - 1)
  lower <- mean_x - t_val * se
  upper <- mean_x + t_val * se

  results3 <- rbind(results3, data.frame(
    変数名 = col,
    標本平均 = mean_x,
    標本標準偏差 = sd_x,
    標本サイズ = n,
    標準誤差 = se,
    下側信頼限界 = lower,
    上側信頼限界 = upper
  ))
}

print(results3)
cat("\n")

# 課題③のシートを追加
addWorksheet(wb, "課題3_95%信頼区間")
writeData(wb, "課題3_95%信頼区間", results3)
setColWidths(wb, "課題3_95%信頼区間", cols = 1:7, widths = "auto")

cat("課題③が完了しました。\n\n")

# =================================================
# Excelファイルを保存
# =================================================
cat("=================================================\n")
cat("Excelファイルを保存しています...\n")
saveWorkbook(wb, "kadai_results.xlsx", overwrite = TRUE)
cat("kadai_results.xlsx に結果を保存しました。\n")
cat("=================================================\n\n")

cat("すべての課題が完了しました！\n")
cat("以下のファイルが生成されました:\n")
cat("  - kadai_results.xlsx (すべての結果)\n")
cat("  - histograms/ (ヒストグラム画像)\n")
