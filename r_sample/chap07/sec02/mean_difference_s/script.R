data <- read.delim(                      # 採点.txtをdataに代入
  "採点.txt",
  header=T,                              # 1行目は列名であることを指定
  fileEncoding="CP932"                   # 文字コードをShift_JISに指定
)

# 主力メニューの点数をベクトルに代入
menu1 <- data$当店
# 欠損値を除いてライバル店の点数をベクトルに代入
menu2 <- data$ライバル店[!is.na(data$ライバル店)]

mean_m1 <- mean(menu1)                   # 主力メニューの平均
mean_m2 <- mean(menu2)                   # ライバル店の平均

# ブールされた分散の平方根を求めることで「ブール標準偏差」を求める
pool <- sqrt(                            # 平方根を求めることで
  (
    (length(menu1) - 1) * var(menu1) +   # 主力メニューの標本分散×サイズ－1
      (length(menu2) - 1) * var(menu2)   # ライバル店の標本分散×サイズ－1
  )
  /(length(menu1) + length(menu2) - 2)   # サンプルサイズの合計－2
)
# 検定統計量tの分母の計算
dn <- pool * sqrt(1 / length(menu1) +
                    1 / length(menu2)
)
# 検定統計量tの実現値を求める
st <- (mean_m1 - mean_m2) / dn

# 自由度を求める
dof <- length(menu1) + length(menu2) - 2

# 自由度がサンプルサイズの合計－2のt分布における下側確率0.025のt値を求める
t_low <- qt(0.025, dof)

# 自由度がサンプルサイズの合計－2のt分布における上側確率0.025のt値を求める
t_upp <- qt(0.025, dof, lower.tail=FALSE)

curve(dt(x, dof), -3, 3)  # 自由度16のt分布のグラフを描く
abline(v=qt(0.025, dof))  # 下側確率0.025のt値のところにラインを引く
abline(v=qt(0.975, dof))  # 上側確率0.975のt値のところにラインを引く

p <- 2*pt(st, dof)        # 両側検定におけるp値を求める

t.test(
  menu1,                  # 独立した2群のデータ1
  menu2,                  # 独立した2群のデータ2
  var.equal = TRUE        # スチューデントのt検定を実施
  )
