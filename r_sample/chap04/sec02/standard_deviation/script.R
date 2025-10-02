getDisper <- function(x) {       # 分散を返す関数
  dev <- x - mean(x)             # 偏差を求める
  return(sum(dev^2) / length(x)) # 分散を返す
}

data <- read.table(           # 店舗別売上.txtをdataに代入
  "販売台数.txt",
  header=T,                   # 1行目は列名であることを指定
  fileEncoding="CP932"        # 文字コードをShift_JISに指定
)

num_A  <- data$車種A          # 車種Aのデータをベクトルに代入
dspr_A <- getDisper(num_A)    # 車種Aの分散を求める
sd_A   <- sqrt(dspr_A)        # 車種Aの標準偏差を求める
cat("標準偏差：", sd_A, "\n") # 出力

num_B  <- data$車種B          # 車種Bのデータをベクトルに代入
dspr_B <- getDisper(num_B)    # 車種Bの分散を求める
sd_B   <- sqrt(dspr_B)        # 車種Bの標準偏差を求める
cat("標準偏差：", sd_B, "\n") # 出力
