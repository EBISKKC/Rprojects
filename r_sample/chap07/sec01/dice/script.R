data <- read.table(     # サイコロ.txtをdataに代入
  "サイコロ.txt",
  header=T,             # 1行目は列名であることを指定
  fileEncoding="CP932"  # 文字コードをShift_JISに指定
)

freq <- c(
  data[1,2],            # 1の目の観測度数
  data[2,2],            # 2の目の観測度数
  data[3,2],            # 3の目の観測度数
  data[4,2],            # 4の目の観測度数
  data[5,2],            # 5の目の観測度数
  data[6,2]             # 6の目の観測度数
)

# それぞれの観測度数について検定統計量を求める
element <- (freq - 2)^2 / 2
# 検定統計量χ2の実現値を求める
elm_val <- sum(element)
# 有意水準5％のχ2値（棄却域）を求める 
chi_val <- qchisq(
                  0.05,            # 有意水準5%
                  5,               # 自由度
                  lower.tail=FALSE # 上側確率を求める
                  )
