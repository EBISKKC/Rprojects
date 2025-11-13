# データのサマリを出力する関数
showSummary <- function(z) {
  smm = summary(data$売上高_千円)
  cat("最小値", smm["Min."] ,"\n")
  cat("第一数", smm["1st Qu."],"\n")
  cat("中央値", smm["Median"],"\n")
  cat("平均値", smm["Mean"],"\n")
  cat("第三数", smm["3rd Qu."],"\n")
  cat("最大値", smm["Max."],"\n")
}
data <- read.table(     # 店舗別売上.txtをデータフレームとしてdataに代入
  "店舗別売上.txt",
  header=T,             # 1行目は列名であることを指定
  fileEncoding="CP932"  # 文字コードをShift_JISに指定
)
showSummary(data)       # showSummary()を呼ぶ
