data <- read.table(         # 店舗別売上.txtをデータフレームとしてdataに代入
  "販売台数.txt",
  header=T,                 # 1行目は列名であることを指定
  fileEncoding="CP932"      # 文字コードをShift_JISに指定
)
hist(data$車種A)            # 車種Aのヒストグラムを作成
hist(data$車種B)            # 車種Bのヒストグラムを作成

me_A = mean(data$車種A)     # 車種Aの平均を求める
num_A <- data$車種A         # 車種Aの販売台数をベクトルに代入
dev_A <- num_A - me_A       # 車種Aの偏差を求める
cat("偏差：",dev_A, "\n")   # 出力

me_B = mean(data$車種B)     # 車種Bの平均を求める
num_B <- data$車種B         # 車種Bの販売台数をベクトルに代入
dev_B <- num_B - me_B       # 車種Bの偏差を求める
cat("偏差：",dev_B, "\n")   # 出力

# 車種Aの分散を求める
dspr_A <- sum(dev_A^2) / length(data$車種A)
cat("分散：", dspr_A, "\n")
# 車種Bの分散を求める
dspr_B <- sum(dev_B^2) / length(data$車種A)
cat("分散：", dspr_B, "\n")
