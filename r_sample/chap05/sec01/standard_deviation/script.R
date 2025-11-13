getSd <- function(x) {                  # 標本分散をもとに標準偏差を返す関数
  return(                               # 標準偏差を返す
    sqrt(                               # 分散の平方根
      sum((x - mean(x))^2) / length(x)) # 分散の計算式
  )
}

data <- read.table(                     # 売上状況.txtをdataに代入
  "売上状況.txt",
  header=T,                             # 1行目は列名であることを指定
  fileEncoding="CP932"                  # 文字コードをShift_JISに指定
)
# 必要なデータを用意
num <- data$売上額                      # 売上額のデータをベクトルに代入
sdv <- getSd(num)                       # 売上額の標準偏差を求める
seq <- seq(30, 60, by=5)                # 10～100までの5刻みのシーケンスを生成

# 累積確率を求める
cmp <- pnorm(
  seq,                                  # 累積確率を求めるデータ
  mean       = mean(data$売上額),       # 来店者数の平均
  sd         = sdv,                     # 来店者数の標準偏差
  lower.tail = TRUE                     # 累積確率を求める
  )

# 5万円刻みの売上額と累積確率のデータフレームを作成
cp_frm <- data.frame(
  "売上額"=seq,
  "累積確率"=cmp
  )

how = 1 - cp_frm[3,2]
