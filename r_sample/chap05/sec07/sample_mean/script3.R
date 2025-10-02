getDisper <- function(x) {                # 分散を返す関数
  dev <- x - mean(x)                      # 偏差を求める
  return(sum(dev^2) / length(x))          # 分散を返す
}

getSd <- function(x) {                    # 標準偏差を返す関数
  return(                                 # 戻り値を返す
    sqrt(                                 # 分散の平方根
      sum(
        (x - mean(x))^2) / length(x)      # 分散の計算式
    )
  )
}

data <- read.table(                       # テスト結果.txtをdataに代入
  "計測結果.txt",
  header=T,                               # 1行目は列名であることを指定
  fileEncoding="CP932"                    # 文字コードをShift_JISに指定
)

sample_m <- as.numeric(NULL)              # 標本平均を格納する空のベクトルを用意
rp <- c(1:1000)                           # 繰り返す回数をベクトルに代入
size <- 20                      　        # サンプルサイズをベクトルに代入

for (i in rp){                            # 処理を10000回繰り返す
  sample   <- sample(
    data$容量,                            # 抽出元のデータ
    size,                                 # サンプルサイズ
    replace = FALSE                       # 復元抽出は行わない
  )
  # 標本平均をベクトルに追加
  sample_m <- c(sample_m, mean(sample))
}

s_mean <- mean(sample_m)                  # 標本平均の平均を求める
p_mean <- mean(data$容量)                 # 母集団の平均

hist(
  sample_m,                               # すべての標本平均をヒストグラムにする
  freq = FALSE,                           # 相対度数を表示する
  col="red"                               # 棒の色は赤
)
lines(density(sample_m))                  # 確率密度の近似値をラインで描画

# 標本平均の平均の分散を求める
sample_m_dsp   <- getDisper(sample_m)
# 母集団から標本平均の分散を割り出す
sample_m_dsp_est <- getDisper(data$容量)/size
# 標準誤差を求める
standard_error <- sqrt(sample_m_dsp)
# 標準偏差÷√サンプルサイズで標準誤差を求める
standard_error_by_sd <-getSd(data$容量)/sqrt(size)
