data <- read.delim(       # 体重の変化.txtをdataに代入
  "体重の変化.txt",
  header=T,               # 1行目は列名であることを指定
  fileEncoding="CP932"    # 文字コードをShift_JISに指定
)

before <- data$摂取前     # 摂取前の体重をベクトルに代入
after <- data$摂取後      # 摂取後の体重をベクトルに代入

mean_m1 <- mean(before)   # 摂取前の体重の平均
mean_m2 <- mean(after)    # 摂取後の体重の平均

change <- after - before  # 変化量を求める

denom <- sd(change) / sqrt(length(change)) # 検定統計量の分母の計算

numer <- mean(change)                      # 検定統計量の分子の計算
st <- numer / denom                        # 検定統計量の実現値を求める


dof <- length(change) - 1 # 自由度を求める

# 自由度がサンプルサイズの合計－2のt分布における下側確率0.025のt値を求める
t_low <- qt(0.025, dof)

# 自由度がサンプルサイズの合計－2のt分布における上側確率0.025のt値を求める
t_upp <- qt(0.025, dof, lower.tail=FALSE)

curve(dt(x, dof), -3, 3)  # 自由度N-1のt分布のグラフを描く
abline(v=qt(0.025, dof))  # 下側確率0.025のt値のところにラインを引く
abline(v=qt(0.975, dof))  # 上側確率0.975のt値のところにラインを引く

p <- 2*pt(st, dof)        # 両側検定におけるp値を求める

t.test(change)            # t.test()の実施

t.test(                   # t.test()の実施
  before,                 # データ1
  after,                  # データ2
  paired=TRUE             # 対応ありを指定
  )
