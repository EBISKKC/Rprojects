k.study <- kmeans(time,2)
k.study$cluster  # 分類結果を取得
k.study$centers  # クラスターの中心を取得
k.study$size     # 各クラスター内の個体の数を取得

# クラスター毎に色を変え散布図を描く
plot(time, col = k.study$cluster)
# クラスターの中心点を上描き
points(k.study$centers, col = 1:2, pch = 8, cex=2)

