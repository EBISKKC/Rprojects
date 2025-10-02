getDisper <- function(x) {       # 標本分散を返す関数
  dev <- x - mean(x)             # 偏差を求める
  return(sum(dev^2) / length(x)) # 分散を返す
}

data <- read.table(              # 計測結果結果.txtをdataに代入
  "計測結果.txt",
  header=T,                      # 1行目は列名であることを指定
  fileEncoding="CP932"           # 文字コードをShift_JISに指定
)

sample_m <- as.numeric(NULL)     # 空の実数型ベクトルを用意

for (i in 1:15){                 # 処理を15回繰り返す
  sample   <- sample(
    data$容量,                   # 抽出元のデータ
    5,                           # サンプルサイズ
    replace = FALSE              # 復元抽出は行わない
  )
  # サンプルの平均をベクトルに追加
  sample_m <- c(sample_m, mean(sample))
}

s_mean <- mean(sample_m)        # 標本平均の平均
s_var  <- getDisper(sample_m)   # 標本平均の分散
p_mean <- mean(data$容量)       # 母集団の平均
#p_var  <- getDisper(data$容量)  # 母集団の分散
