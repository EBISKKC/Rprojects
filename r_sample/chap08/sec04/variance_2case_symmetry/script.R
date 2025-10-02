data <- read.delim(             # 学習効果.txtをdataに代入
  "学習効果.txt",
  header=T,                     # 1行目は列名であることを指定
  fileEncoding="CP932"          # 文字コードをShift_JISに指定
)

# データフレームの各列の変量をベクトルに代入
variate <- c(
  data[,2],                     # 1列目の変量をベクトルに代入
  data[,3],                     # 2列目の変量をベクトルに代入
  data[,4],                     # 3列目の変量をベクトルに代入
  data[,5],                     # 4列目の変量をベクトルに代入
  data[,6],                     # 5列目の変量をベクトルに代入
  data[,7]                      # 6列目の変量をベクトルに代入
)

# 1要因に含まれるデータの数を取得
size     <- length(data[,1]) * (length(colnames(data))-1) / 2
# 1つの列に含まれるデータの数を取得
size_col <- length(data[,1])
# 条件の数を取得
size_row <- length(colnames(data))-1

# 1つ目の要因の水準を識別子としてデータの数だけ作成
fac1 <- factor(
  c(
    rep("fac_A_1", size),       # 1つ目の要因に含まれるデータの数だけ登録
    rep("fac_A_2", size)        # 2つ目の要因に含まれるデータの数だけ登録
  )
)

# 2つ目の要因の水準を識別子としてデータの数だけ作成
fac2 <- factor(
  rep(
    c(
      rep("fac_B_1", size_col), # 1列目の識別子を行データの数だけ登録
      rep("fac_B_2", size_col), # 2列目の識別子を行データの数だけ登録
      rep("fac_B_3", size_col)  # 3列目の識別子を行データの数だけ登録
    ),2
  )
)

# 第3の識別子をデータの数だけ作成
fac3 <- factor(
  rep(
    c(
      "fac_C_1",                # 1人目
      "fac_C_2",                # 2人目
      "fac_C_3",                # 3人目
      "fac_C_4",                # 4人目
      "fac_C_5"                 # 5人目
    ),6
  )
)


# aov()関数を実行して分散分析表を出力
summary(
  aov( variate ~ fac1 * fac2 + Error( fac3 + 
                                      fac3 : fac1 + 
                                      fac3 : fac2 +
                                      fac1 : fac2 : fac3 )
  )
)

