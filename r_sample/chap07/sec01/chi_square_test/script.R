data <- read.table(                      # 容量検査.txtをdataに代入
  "A店B店.txt",
  header=T,                              # 1行目は列名であることを指定
  fileEncoding="CP932"                   # 文字コードをShift_JISに指定
)

A_sum     <- data[1,3]                   # A店の注文数の合計
B_sum     <- data[2,3]                   # B店の注文数の合計
AB_sum    <- data[3,3]                   # A店舗B店の注文数の合計

menu1_sum <- data[3,1]                   # メニュー1の注文数の合計
menu2_sum <- data[3,2]                   # メニュー2の注文数の合計
menu_sales <- c(                         # 店舗ごとの注文数をベクトルに代入
                data[1,1],               # A店のメニュー1の注文数
                data[1,2],               # A店のメニュー2の注文数
                data[2,1],               # B店のメニュー1の注文数
                data[2,2]                # B店のメニュー2の注文数
                )


exp_A_m1  <- menu1_sum * A_sum / AB_sum  # A店メニュー1の期待値
exp_A_m2  <- menu2_sum * A_sum / AB_sum  # A店メニュー2の期待値
exp_B_m1  <- menu1_sum * B_sum / AB_sum  # B店メニュー1の期待値
exp_B_m2  <- menu2_sum * B_sum / AB_sum  # B店メニュー2の期待値

# すべての期待値をベクトルに代入
exp_freq  <- c(exp_A_m1, exp_A_m2, exp_B_m1, exp_B_m2)

# それぞれの売上について検定統計量を求める
chi_element <- (menu_sales - exp_freq) ^2/exp_freq
# 検定統計量χ2の実現値を求める
chi_elm_val <- sum(chi_element)
# 有意水準5％のχ2値（棄却域）を求める 
chi_val <- qchisq(0.05, 1,lower.tail=FALSE)

# 自由度1のχ2分布のグラフを描く
curve(dchisq(x, 1), 0, 6)
abline(v=qchisq(0.05, 1,lower.tail=FALSE))
