# 非線形回帰分析
nls.relation. <- nls(
                 pene ~ a / (1 + b * exp(c * year)), # 関係式
                 start=c(a=1, b=1, c=-1),            # 初期値を設定
                 trace="TRUE"                        # 計算過程をトレース
                 )

year <-(1:19)       																 # 年度を1～19にする

# 非線形回帰分析
relat.nls <- nls(
                 pene ~ a / (1 + b * exp(c * year)), # 関係式
                 start=c(a=1, b=1, c=-1),            # 初期値を設定
                 trace="TRUE"                        # 計算過程をトレース
                 )

summary(relat.nls)                      # 分析結果を表示

relat.coef <- coefficients(relat.nls)   # 係数を取得

# 係数を取り出す
a<- as.vector(relat.coef[1])            # aの値
b<- as.vector(relat.coef[2])            # bの値
c<- as.vector(relat.coef[3])            # cの値
x <- 10                                 # xの値

relat.y <- a / ( 1 + b * exp(c * x))    # 非線形の回帰モデル

expe_1 <- cbind(data,    # 実測値と予測値の表を作成
                fitted(relat.nls))

plot(year, pene, cex=1)  # 実測値の散布図を作成
lines(year,              # x座標は年代
      fitted(relat.nls), # y座標は予測値
      col="RED",         # 赤にする
      lty="dotted",      # ドットで描画
      lwd=2)             # 太さは2



