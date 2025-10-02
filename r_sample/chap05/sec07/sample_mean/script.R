data <- read.table(             # テスト結果.txtをdataに代入
  "計測結果.txt",
  header=T,                     # 1行目は列名であることを指定
  fileEncoding="CP932"          # 文字コードをShift_JISに指定
)

sample_m <- as.numeric(NULL)    # 空の実数型ベクトルを用意

for (i in 1:15){                # 処理を15回繰り返す
  sample   <- sample(           # 抽出したサンプルをベクトルに代入
    data$容量,                  # 抽出元のデータ
    5,                          # サンプルサイズ
    replace = FALSE             # 復元抽出は行わない
    )
  # 標本平均をベクトルに追加
  sample_m <- c(sample_m, mean(sample))
}

s_mean <- mean(sample_m)        # 標本平均の平均を求める
p_mean <- mean(data$容量)       # 元データの平均

hist(
  sample_m,                     # すべての標本平均をヒストグラムにする
  freq = FALSE,                 # 相対度数を表示する
  col="red"                     # 棒の色は赤
)
