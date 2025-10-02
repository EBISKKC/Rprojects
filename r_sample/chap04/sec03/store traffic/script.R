getSd <- function(x) {                  # 標準偏差を返す関数
  return(                               # 戻り値を返す
    sqrt(                               # 分散の平方根
      sum((x - mean(x))^2) / length(x)) # 分散の計算式
  )
}

data <- read.table(       # 来店者数.txtをdataに代入
  "来店者数.txt",
  header=T,               # 1行目は列名であることを指定
  fileEncoding="CP932"    # 文字コードをShift_JISに指定
)

num  <- data$来店者数     # 来店者数のデータをベクトルに代入
sd   <- getSd(num)        # 来店者数の標準偏差を求める
mean <- mean(num)         # 来店者数の平均
# 標準化係数をデータフレームにバインド
new_frm <- cbind(
              # もとのデータフレーム
              data,
              # 標準化係数のデータフレーム
              data.frame(
                # 標準化の計算
                (num - mean) / sd
              )
           )
