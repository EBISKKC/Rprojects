data <- read.delim(             # 模試結果.txtをdataに代入
  "模試結果.txt",
  header=T,                     # 1行目は列名であることを指定
  fileEncoding="CP932"          # 文字コードをShift_JISに指定
)

# データフレームの各列の変量をベクトルに代入
variate <- c(
             data[,1],          # 1列目の変量をベクトルに代入
             data[,2],          # 2列目の変量をベクトルに代入
             data[,3]           # 3列目の変量をベクトルに代入
            )

# 各列のサイズを取得
l1 <- length(data[,1])
l2 <- length(data[,2])
l3 <- length(data[,3])

identifier <- factor(           # ベクトルを要因型に変換
  c(
    rep(colnames(data)[1], l1), # 1列目の項目を名変量の数だけ登録する
    rep(colnames(data)[2], l2), # 2列目の項目名を変量の数だけ登録する
    rep(colnames(data)[3], l3)  # 3列目の項目名を変量の数だけ登録する
    )
  )

# oneway.test()を実行
oneway.test(
  variate~identifier,           # variateにidentifierを対応付けるモデル式
  var.equal=TRUE                # 等分散を仮定してF検定を実施
  )

# aov()を実行
aov(variate~identifier)

# summary()関数の引数にaov()関数の実行結果を指定
summary(
  aov(variate~identifier)
  )

# anova()を実行
anova(
  lm(variate~identifier)        # variateにidentifierを対応付けるモデル式
  )

m_A <- mean(data[,1])
m_B <- mean(data[,2])
m_C <- mean(data[,3])
m_all <- mean(variate)
