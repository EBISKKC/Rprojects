data <- read.delim(    # 模試結果.txtをdataに代入
  "模試結果.txt",
  header=T,            # 1行目は列名であることを指定
  fileEncoding="CP932" # 文字コードをShift_JISに指定
)

# 分散を返す関数
getDisper <- function(x) {       
  dev <- x - mean(x) 
  return(sum(dev^2) / length(x))
}

# データフレームの各列の変量をベクトルに代入
score <- c(
            data[,1],  # 講座Aの受講者の得点をベクトルに代入
            data[,2],  # 講座Bの受講者の得点をベクトルに代入
            data[,3]   # 講座Cの受講者の得点をベクトルに代入
            )

# 各列のサイズを取得
l1    <- length(data[,1])
l2    <- length(data[,2])
l3    <- length(data[,3])

# 平均を求める
m_A   <- mean(data[,1])
m_B   <- mean(data[,2])
m_C   <- mean(data[,3])
m_all <- mean(score)

# 群間の平方和
cohort_s_sum       <- sum(
                          (m_A - m_all)^2 * l1,
                          (m_B - m_all)^2 * l2,
                          (m_C - m_all)^2 * l3
                          )

# 群内の平方和
cohort_in_s_sum    <- sum(
                          getDisper(data[,1]) * l1,
                          getDisper(data[,2]) * l2,
                          getDisper(data[,3]) * l3
                          )

# 群間の不偏分散
cohort_unbiased <- cohort_s_sum / (length(data[1,]) - 1)

# 群内の不偏分散
cohort_in_unbiased <- cohort_in_s_sum / ((l1-1) + (l2-1) +(l3-1))

# 検定統計量Fの実現値
f <- cohort_unbiased / cohort_in_unbiased
