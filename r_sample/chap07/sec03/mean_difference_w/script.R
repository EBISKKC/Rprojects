data <- read.delim(                      # 満足度調査.txtをdataに代入
  "満足度調査.txt",
  header=T,                              # 1行目は列名であることを指定
  fileEncoding="CP932"                   # 文字コードをShift_JISに指定
)

# A店の点数を欠損値を除いてベクトルに代入
a <- data$A店
# B店の点数をベクトルに代入
b <- data$B店[!is.na(data$B店)]

# ウェルチのt検定の実施
t.test(
  a,                  # 独立した2群のデータ1
  b,                  # 独立した2群のデータ2
)
