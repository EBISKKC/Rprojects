# SSlogis()を引数にして非線形回帰分析
func.nls <- nls(pene ~ 
                  SSlogis(year, Asym, xmid, scal)
                )

summary(func.nls)                   # 分析結果を表示

func.coef <- coefficients(func.nls) # 係数を取得

# 係数を取り出す
Asym <- as.vector(func.coef[1])     # aの値
xmid <- as.vector(func.coef[2])     # bの値
scal <- as.vector(func.coef[3])     # cの値
x    <- 10                          # xの値

# ロジスティック曲線モデル
func.y    <- Asym / (1 + exp((xmid - x) / scal))

expe_2    <- cbind(data,            # 実測値と予測値の表を作成
                   fitted(relat.nls),
                   fitted(func.nls))


plot(year, pene, cex=1)             # 実測値の散布図を作成
lines(year,                         # x座標は年代
      fitted(func.nls),             # y座標は予測値
      col="RED",
      lty="dotted",
      lwd=2)

