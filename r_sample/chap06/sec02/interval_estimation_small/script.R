data <- read.table(                  # 容量検査.txtをdataに代入
  "容量検査.txt",
  header=T,                          # 1行目は列名であることを指定
  fileEncoding="CP932"               # 文字コードをShift_JISに指定
)

prob <- 0.95                         # 信頼度を設定
n    <- length(data$容量)            # サンプルサイズを求める
m    <- mean(data$容量)              # 標本平均を求める
vr   <- var(data$容量)               # 標本の不偏分散を求める

t    <- abs(                         # 絶対値を求める
            qt(                      # t値を求める
               (1 - prob) / 2,       # 優位水準αを求める
               n - 1                 # サンプルサイズ - 1
            )
        )

border_low <- m - t * sqrt(vr / n)   # 下側境界値
border_upp <- m + t * sqrt(vr / n)   # 上側境界値
