data <- read.table(           # 店舗別売上.txtをデータフレームとしてdataに代入
  "店舗別売上.txt",
  header=T,                   # 1行目は列名であることを指定
  fileEncoding="CP932"        # 文字コードをShift_JISに指定
)

m <- median(data$売上高_千円) # 中央値を求める
cat("中央値",m)               # 出力
