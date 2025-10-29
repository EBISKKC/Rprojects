# 母集団の標準偏差を求める関数
# 引数: x - 数値ベクトル
# 戻り値: 母集団の標準偏差

population_sd <- function(x) {
  # 欠損値を除外
  x <- x[!is.na(x)]

  # データ数
  n <- length(x)

  # 平均値
  mean_x <- mean(x)

  # 母集団の分散: Σ(xi - μ)² / N
  variance <- sum((x - mean_x)^2) / n

  # 母集団の標準偏差: √分散
  sd <- sqrt(variance)

  return(sd)
}

# 使用例
# data <- c(10, 20, 30, 40, 50)
# result <- population_sd(data)
# print(result)
