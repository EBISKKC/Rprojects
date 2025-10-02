file <- "清涼飲料水売上.txt" # 読み込むファイル名を設定

data <- read.delim(          # ファイルを読み込んでdataに格納
  file,
  header=T,                  # 1行目は列名であることを指定
  fileEncoding="CP932"       # 文字コードをShift_JISに指定
)

var_1<- c(
  data[,1]                   # 1列目の変量をベクトルに代入
)

var_2<- c(
  data[,2]                   # 2列目の変量をベクトルに代入
)

plot(data)                   # 散布図を描く

coef <- cor(var_1, var_2)    # 相関係数を求める


# 線形単回帰分析を実行
salse.lm <- lm(var_2~var_1, data=data)
# 分析結果を表示
summary(salse.lm)

# 散布図に回帰直線を引く
plot(data)
abline(salse.lm)

# 分析結果の係数のみを表示する
round(coefficients(salse.lm), 2)

# 最高気温が30度のときの売上数を予測する
exp_30dg = -760.877 + 33.741 * 30

# 最高気温が31度のときの売上数を予測する
exp_31dg = -760.877 + 33.741 * 31

# 最高気温が36度のときの売上数を予測する
exp_36dg = -760.877 + 33.741 * 36

# 分析のもとデータと予測値、残差を一覧にする
exp <- predict(salse.lm)           # 元データに対する予測値
res <- residuals(salse.lm)         # データと予測値の残差
view <- data.frame(data, exp, res) # データフレームにまとめる
