airquality <- na.omit(airquality)# airqualityから欠損値がある行を削除

lm <- lm(Ozone ~                # 線形重回帰分析を実行
            Solar.R + Wind + Temp,
          data=airquality
         )

lm <- lm(airquality[,1] ~       # 線形重回帰分析を実行
           airquality[,2] + airquality[,3] + airquality[,4],
         data=airquality
)

qqnorm(                         # 残差の散布図を描く
  resid(lm)                     # 残差の行列を抽出
  )
qqline(                         # 散布図に上下四分位点を結ぶ直線を描く
  resid(lm),                    # 残差の行列を抽出
  lwd=2,col="red")

# 一般化線形モデルに正規分布を使う
glm1 <- glm(airquality[,1] ~    # 線形重回帰分析を実行
              airquality[,2] + airquality[,3] + airquality[,4],
            data=airquality,
            family = gaussian   # 正規分布を使用
            )

# 一般化線形モデルにガンマ分布を使う
glm2 <- glm(airquality[,1] ~    # 線形重回帰分析を実行
              airquality[,2] + airquality[,3] + airquality[,4],
            data=airquality,
            family = Gamma      # ガンマ分布を使用
            )

exp <- cbind(airquality[,1],    # 実測値と予測値の表を作成
             fitted(glm1),      # 正規分布を仮定した予測値
             fitted(glm2))      # ガンマ分布を仮定した予測値

AIC(lm)
AIC(glm1)
AIC(glm2)

# 分布図と直線を描いてみる
qqnorm(resid(glm1))
qqline(resid(glm1),lwd=2,col="red")
qqnorm(resid(glm2))
qqline(resid(glm2),lwd=2,col="red")
