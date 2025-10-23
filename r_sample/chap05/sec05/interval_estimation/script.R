getDisper <- function(x) {                # 分散を返す関数
  dev <- x - mean(x)                      # 偏差を求める
  return(sum(dev^2) / length(x))          # 分散を返す
}

test <- c(                                # テスト結果
  75, 68, 96, 76, 84, 74, 64,	94,	77,	82,
  86,	56,	82,	69,	59,	81,	61,	85,	64,	63,
  68,	79,	61,	57,	63,	89,	74,	63,	71,	69,
  95,	84,	76
  )

m1 <- mean(test[1:5])                     # 平均
d1 <- getDisper(test[1:5])                # 分散

d2 <- var(test[1:5])                      # 不偏分散
