getSd <- function(x) {                  # 標準偏差を返す関数
  return(                               # 戻り値を返す
    sqrt(                               # 分散の平方根
      sum((x - mean(x))^2) / length(x)) # 分散の計算式
  )
}

data <- read.table(           # テスト結果.txtをdataに代入
  "テスト結果.txt",
  header=T,                   # 1行目は列名であることを指定
  fileEncoding="CP932"        # 文字コードをShift_JISに指定
)

num <- data$得点              # テスト結果の得点をベクトルに代入
sdv <- getSd(num)             # 得点の標準偏差を求める
men <- mean(num)              # 得点の平均
dev <- 
  (data$得点-men) / sdv*10+50 # 全員の偏差値を求める

data <- cbind(                # 偏差値を追加したデータフレームを生成
  data,                       # もとのデータフレーム
  data.frame("偏差値" = dev)  # 偏差値のデータフレーム

  )
