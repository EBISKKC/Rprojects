temp<-floor(
  runif(1000,   # 試行回数
        1,      # 出力する乱数の最小値
        7       # 出力する乱数の最大値の次の値
  )
)

hist(           # ヒストグラムを作成
  temp,
  breaks = seq(
    0,          # 下限
    6,          # 上限
    1           # 階級の幅
  ),
  freq = FALSE, # 相対度数を表示する
  col="red"     # 棒の色は赤
)
