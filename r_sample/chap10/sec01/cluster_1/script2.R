d.study  <- round(dist(time))         # 距離を求めて小数点以下を四捨五入

d.study  <- dist(time)                # ユークリッド距離を求める
hc.study <- hclust(d.study)           # デフォルトの最遠隣法で分析

par(family = "HiraKakuProN-W3")       ##### Macで日本語をプロットするために必要な記述

plot(hc.study)                        # 樹形図を作成
plot(hc.study, hang=-1)               # 樹形図を作成(葉の高さを揃える)
hc.study$merge                        # クラスタリングの過程を示す行列を取得
hc.study$height                       # クラスターの枝の高さを取得
cophenetic(hc.study)                  # コーフェン行列を取得
hc.study$order                        # 樹形図の個体番号を取得

