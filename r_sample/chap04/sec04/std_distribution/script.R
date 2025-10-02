# 0～2を0.01刻みにしたシーケンスを生成
n <- seq(0, 2, by = 0.01)
# 標準正規分布の確率密度関数で確率を求める
dn <- dnorm(n, mean=0, sd=1)

# 区間面積用の数値ベクトルを作る
s_area <- as.numeric(NULL)
# 累積面積用の数値ベクトルを作る
t_area <- as.numeric(NULL)

# 区間面積と累計面積を計算
i <- 0                             # カウンター変数
for (value in n){                  # nの要素のぶんだけ繰り返す
  if(value == 0){                  # nが0であれば実行
    s_area <- 0                    # 区間面積を0とする
    t_area <- 0                    # 累計面積を0とする
    i <- i + 1                     # カウンターの値を1増やす
  } else {                         # nの要素が0以外の場合の処理
    # 区間面積のベクトルに区間面積を追加
    s_area <- c(
      s_area,                      # 代入先のベクトル
      (dn[i] + dn[i+1]) * 0.01 / 2 # 区間面積を台形の面積で近似
      )
    # 累計面積のベクトルに累計面積を追加
    t_area <- c(
      t_area,                      # 代入先のベクトル
      t_area[i] + s_area[i+1]      # 累計の面積を計算
      )
    i <- i + 1                     # カウンターの値を1増やす
  }
}
# 標準正規分布の数表を作成
dframe <- data.frame(
  x_value      = n,                # 0～2までの連続値
  section_area = s_area,           # 区間面積
  total_area   = t_area            # 累計面積
  )


