getSd <- function(x) {                  # 標準偏差を返す関数
  return(                               # 戻り値を返す
    sqrt(                               # 分散の平方根
      sum((x - mean(x))^2) / length(x)) # 分散の計算式
    )
}

data <- read.table(           # 店舗別売上.txtをdataに代入
  "販売台数.txt",
  header=T,                   # 1行目は列名であることを指定
  fileEncoding="CP932"        # 文字コードをShift_JISに指定
)

num_A <- data$車種A           # 車種Aのデータをベクトルに代入
sd_A <- getSd(num_A)          # 車種Aの標準偏差を求める
cat("標準偏差：", sd_A, "\n") # 出力

num_B <- data$車種B           # 車種Bのデータをベクトルに代入
sd_B <- getSd(num_B)          # 車種Bの標準偏差を求める
cat("標準偏差：", sd_B, "\n") # 出力
