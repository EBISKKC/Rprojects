data <- read.delim(    # サプリの効果.txtをdataに代入
  "サプリの効果.txt",
  header=T,            # 1行目は列名であることを指定
  fileEncoding="CP932" # 文字コードをShift_JISに指定
)

# データフレームの各列の変量をベクトルに代入
variate <- c(
             data[,2],  # 2列目の変量をベクトルに代入
             data[,3],  # 3列目の変量をベクトルに代入
             data[,4]   # 4列目の変量をベクトルに代入
)

# 列のサイズ(行データの数)を取得
size <- length(data[,1])

# 識別子を作成
identifier <- factor(
  c(
    rep(colnames(data)[2], size), # 列2のタイトルを行データの数だけ登録
    rep(colnames(data)[3], size), # 列3のタイトルを行データの数だけ登録する
    rep(colnames(data)[4], size)  # 列4のタイトルを行データの数だけ登録する
  )
)

# summary()関数の引数にaov()関数の実行結果を指定
summary(
  aov(variate~identifier)
)

