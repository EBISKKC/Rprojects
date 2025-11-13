# 課題② ヒストグラムの作成
# データの読み込み
data <- read.csv("cv.csv", header = TRUE)

# ken, area2, area3以外の変数を選択
numeric_vars <- data[, !names(data) %in% c("ken", "area2", "area3")]

# openxlsxパッケージを読み込み
if (!require(openxlsx)) install.packages("openxlsx")
library(openxlsx)

# 既存のワークブックを読み込み（なければ新規作成）
if (file.exists("kadai_results.xlsx")) {
  wb <- loadWorkbook("kadai_results.xlsx")
} else {
  wb <- createWorkbook()
}

# 課題②のシートを追加
addWorksheet(wb, "課題2_ヒストグラム")

# ヒストグラムを作成して画像として保存
row_position <- 1

for (col in names(numeric_vars)) {
  # ヒストグラムのファイル名
  filename <- paste0("histogram_", col, ".png")

  # ヒストグラムを作成して保存
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

  row_position <- row_position + 21 # 次の画像の位置
}

# ワークブックを保存
saveWorkbook(wb, "kadai_results.xlsx", overwrite = TRUE)

cat("\n課題②のヒストグラムをkadai_results.xlsxに保存しました。\n")
