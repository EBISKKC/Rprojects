# --- はじめに ---
# 必要なパッケージのリスト
required_packages <- c("plotly", "GGally", "ggridges", "ggplot2")

# パッケージがインストールされているか確認し、されていなければインストール
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cran.rstudio.com/")
  }
}


# --- 例1: plotlyによるインタラクティブな3D散布図 ---
# 3つの量的変数の関係を、マウスでぐりぐり動かせる3Dグラフで表現します。
# データの塊（クラスター）を直感的に捉えるのに非常に便利です。

library(plotly)

# plot_ly関数を使って3D散布図を作成
fig_3d <- plot_ly(
  iris, 
  x = ~Sepal.Length, 
  y = ~Sepal.Width, 
  z = ~Petal.Length, 
  color = ~Species, # 品種(Species)で色分け
  colors = c('#636EFA', '#EF553B', '#00CC96'), # 色の指定
  type = "scatter3d", # グラフの種類
  mode = "markers",   # 点でプロット
  marker = list(size = 5, opacity = 0.8) # マーカーのサイズと透明度
)

# グラフのレイアウトを設定
fig_3d <- fig_3d %>% layout(
  title = "Irisデータセットの3D散布図 (Plotly)",
  scene = list(
    xaxis = list(title = "がくの長さ (Sepal Length)"),
    yaxis = list(title = "がくの幅 (Sepal Width)"),
    zaxis = list(title = "花びらの長さ (Petal Length)")
  )
)

# グラフを表示
# RStudioのViewerペインにインタラクティブなグラフが表示されます
print(fig_3d)


# --- 例2: GGallyによるペアプロット（散布図行列） ---
# データセットに含まれる全ての量的変数の組み合わせについて、
# 散布図、相関係数、分布（密度プロット）を一度に表示します。
# データ全体の概観を把握するのに非常に強力なグラフです。

library(GGally)

# ggpairs関数を使ってペアプロットを作成
# columnsでプロットする列を指定し、aesのcolorで品種(Species)による色分けを指定
fig_pairs <- ggpairs(
  iris,
  columns = 1:4, # 1列目から4列目（量的変数）を使用
  aes(color = Species, alpha = 0.5), # 品種で色分けし、少し透明にする
  title = "Irisデータセットのペアプロット (GGally)",
  upper = list(continuous = wrap("cor", size = 3)), # 上三角に行列の相関係数を表示
  lower = list(continuous = wrap("points", size = 2)) # 下三角に散布図を表示
) +
  theme_minimal() # シンプルなテーマを適用

# グラフを表示
print(fig_pairs)


# --- 例3: ggridgesによるリッジラインプロット ---
# 各カテゴリ（品種）ごとの量的変数（がくの長さ）の分布を、
# まるで山脈が連なっているかのように描画します。
# 分布の違いを視覚的に、そして美しく比較することができます。

library(ggplot2)
library(ggridges)

# ggplotとgeom_density_ridgesを使ってリッジラインプロットを作成
fig_ridges <- ggplot(iris, aes(x = Sepal.Length, y = Species, fill = Species)) +
  geom_density_ridges(
    alpha = 0.7, # 透明度
    scale = 0.9  # 各プロットの重なり具合を調整
  ) +
  scale_fill_viridis_d() + # 見やすいカラーパレットを適用
  labs(
    title = "品種ごとの「がくの長さ」の分布",
    subtitle = "リッジラインプロット (ggridges)",
    x = "がくの長さ (Sepal Length)",
    y = "品種 (Species)"
  ) +
  theme_ridges(grid = TRUE) + # リッジラインプロット用のテーマ
  theme(legend.position = "none") # 凡例は不要なので消す

# グラフを表示
print(fig_ridges)
