c.study <- dist(time,"canberra")              # キャンベラ距離を求める
c_s.study <- hclust(c.study, method="single") # 最近隣法で分析
par(family = "HiraKakuProN-W3")               ##### Macで日本語をプロットするために必要な記述
plot(c_s.study, hang=-1)                      # 樹形図を作成(葉の高さを揃える)

e.study <- dist(time, "euclidean")            # ユークリッド距離を求める
e_w.study <- hclust(e.study,method="ward.D2") # ウォード法で分析
plot(e_w.study, hang=-1)                      # 樹形図を作成(葉の高さを揃える)

cor(d.study,cophenetic(hc.study))  # ユークリッド距離と最遠隣法
cor(c.study,cophenetic(c_s.study)) # キャンベラ距離と最近隣法
cor(e.study,cophenetic(e_w.study)) # ユークリッド距離とウォード法

