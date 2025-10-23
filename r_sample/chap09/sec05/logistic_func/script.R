actual.len  <- ToothGrowth[,1]                   # 歯の長さの実測値を取得
actual.supp <- ToothGrowth[,2]                   # 投与方法の実測値を取得
actual.dose <- ToothGrowth[,3]                   # 投与量の実測値を取得

# ロジスティック回帰分析
tooth.glm <- glm(actual.supp ~                   # 投与方法を目的変数にする
                   actual.len + actual.dose,     # 歯の長さと投与量を説明変数にする
                 family=binomial                 # 二項分布のリンク関数を指定
                 )

predict.supp <- round(                           # 四捨五入
                      fitted(tooth.glm)          # 予測値を取得
                      )

result  <- data.frame(actual.supp, predict.supp) # データフレームを作成
c_table <- table(actual.supp, predict.supp)      # クロス集計表を作成


# 以下はロジスティック曲線を描くコードです
# 冒頭の#を削除してコメントアウトを解除して
# お使いください。
# eta <- seq(from=-5, to=5, length=200)
# plot(eta, exp(eta) / (1 + exp(eta)), type="l" )
