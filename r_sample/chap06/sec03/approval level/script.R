z          <- abs(qnorm(0.025))             # z値を求める
p          <- 0.45                          # 比率をセット
param      <- 1000                          # 母集団のサイズ
border_low <- p - z * sqrt(p*(1 - p)/1000)  # 下側境界値
border_upp <- p + z * sqrt(p*(1 - p)/1000)  # 上側境界値