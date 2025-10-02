data <- read.table(                  # 容量検査.txtをdataに代入
  "容量検査.txt",
  header=T,                          # 1行目は列名であることを指定
  fileEncoding="CP932"               # 文字コードをShift_JISに指定
)
prob <- 0.95                         # 信頼度を設定
z  <- abs(qnorm((1 - prob) / 2))     # z値を求める
n  <- length(data$容量)              # サンプルサイズを求める
m  <- mean(data$容量)                # 標本平均を求める
sd <- sd(data$容量)                  # 標本標準偏差をもとんる
border_low <- m - z * (sd / sqrt(n)) # 下側境界値
border_upp <- m + z * (sd/sqrt(n))   # 上側境界値
1