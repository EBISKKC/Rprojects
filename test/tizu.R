# --- 0. 準備：パッケージのインストールとデータの用意 ---


# 必要なパッケージのリスト
required_packages <- c(
  "tidyverse", "gganimate", "gifski", "plotly", "GGally",
  "ggridges", "leaflet", "highcharter", "patchwork",
  "ggraph", "igraph"
)

# パッケージがインストールされているか確認し、されていなければインストール
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cran.rstudio.com/")
  }
}

# 必要なライブラリをすべて読み込みます
library(tidyverse) # Tidyverse (ggplot2, dplyrなどを含む)
library(gganimate) # アニメーション
library(gifski) # GIF作成
library(plotly) # インタラクティブなグラフ
library(GGally) # ペアプロット
library(ggridges) # リッジラインプロット
library(leaflet) # インタラクティブな地図
library(highcharter) # インタラクティブなチャート
library(patchwork) # グラフの組み合わせ
library(ggraph) # ネットワーク図
library(igraph) # ネットワーク分析


# 今回使用する都道府県データを作成します。
# (本来は外部から読み込みますが、ここではコード内で完結させます)
pref_data <- tibble::tribble(
  ~code, ~prefecture, ~region, ~capital, ~lat, ~lon, ~population_2023, ~area_km2, ~income_M_yen, ~pop_density,
  1, "北海道", "北海道", "札幌市", 43.06, 141.35, 511, 83424, 280, 61,
  2, "青森県", "東北", "青森市", 40.82, 140.74, 119, 9646, 250, 123,
  3, "岩手県", "東北", "盛岡市", 39.7, 141.15, 117, 15275, 260, 77,
  4, "宮城県", "東北", "仙台市", 38.27, 140.87, 227, 7282, 300, 312,
  5, "秋田県", "東北", "秋田市", 39.72, 140.1, 92, 11638, 240, 79,
  6, "山形県", "東北", "山形市", 38.24, 140.36, 103, 9323, 250, 110,
  7, "福島県", "東北", "福島市", 37.76, 140.47, 177, 13784, 270, 128,
  8, "茨城県", "関東", "水戸市", 36.34, 140.45, 283, 6097, 310, 464,
  9, "栃木県", "関東", "宇都宮市", 36.57, 139.88, 191, 6408, 320, 298,
  10, "群馬県", "関東", "前橋市", 36.39, 139.06, 191, 6362, 310, 300,
  11, "埼玉県", "関東", "さいたま市", 35.86, 139.65, 734, 3798, 320, 1933,
  12, "千葉県", "関東", "千葉市", 35.61, 140.12, 628, 5158, 330, 1217,
  13, "東京都", "関東", "東京", 35.69, 139.69, 1409, 2194, 550, 6422,
  14, "神奈川県", "関東", "横浜市", 35.45, 139.64, 924, 2416, 380, 3824,
  15, "新潟県", "中部", "新潟市", 37.9, 139.02, 214, 12584, 280, 170,
  16, "富山県", "中部", "富山市", 36.7, 137.21, 100, 4248, 310, 235,
  17, "石川県", "中部", "金沢市", 36.59, 136.63, 111, 4186, 300, 265,
  18, "福井県", "中部", "福井市", 36.07, 136.22, 74, 4190, 320, 177,
  19, "山梨県", "中部", "甲府市", 35.66, 138.57, 80, 4465, 300, 179,
  20, "長野県", "中部", "長野市", 36.65, 138.18, 201, 13562, 290, 148,
  21, "岐阜県", "中部", "岐阜市", 35.42, 136.77, 193, 10621, 300, 182,
  22, "静岡県", "中部", "静岡市", 34.98, 138.38, 357, 7777, 340, 459,
  23, "愛知県", "中部", "名古屋市", 35.18, 136.91, 749, 5173, 400, 1448,
  24, "三重県", "中部", "津市", 34.73, 136.51, 172, 5774, 330, 298,
  25, "滋賀県", "近畿", "大津市", 35.0, 135.87, 141, 4017, 340, 351,
  26, "京都府", "近畿", "京都市", 35.02, 135.76, 254, 4612, 350, 551,
  27, "大阪府", "近畿", "大阪市", 34.69, 135.5, 878, 1905, 370, 4609,
  28, "兵庫県", "近畿", "神戸市", 34.69, 135.19, 538, 8401, 320, 640,
  29, "奈良県", "近畿", "奈良市", 34.69, 135.8, 130, 3691, 280, 352,
  30, "和歌山県", "近畿", "和歌山市", 34.23, 135.17, 89, 4725, 270, 188,
  31, "鳥取県", "中国", "鳥取市", 35.5, 134.24, 54, 3507, 240, 154,
  32, "島根県", "中国", "松江市", 35.47, 133.05, 65, 6708, 250, 97,
  33, "岡山県", "中国", "岡山市", 34.66, 133.93, 185, 7115, 290, 260,
  34, "広島県", "中国", "広島市", 34.4, 132.46, 277, 8479, 310, 327,
  35, "山口県", "中国", "山口市", 34.19, 131.47, 130, 6112, 300, 213,
  36, "徳島県", "四国", "徳島市", 34.07, 134.56, 70, 4147, 280, 169,
  37, "香川県", "四国", "高松市", 34.34, 134.04, 93, 1877, 290, 495,
  38, "愛媛県", "四国", "松山市", 33.84, 132.77, 130, 5676, 270, 229,
  39, "高知県", "四国", "高知市", 33.56, 133.53, 67, 7104, 250, 94,
  40, "福岡県", "九州", "福岡市", 33.61, 130.4, 511, 4986, 320, 1025,
  41, "佐賀県", "九州", "佐賀市", 33.25, 130.3, 80, 2441, 270, 328,
  42, "長崎県", "九州", "長崎市", 32.75, 129.87, 128, 4132, 260, 310,
  43, "熊本県", "九州", "熊本市", 32.79, 130.7, 171, 7409, 270, 231,
  44, "大分県", "九州", "大分市", 33.24, 131.61, 110, 6341, 270, 173,
  45, "宮崎県", "九州", "宮崎市", 31.91, 131.42, 105, 7735, 250, 136,
  46, "鹿児島県", "九州", "鹿児島市", 31.56, 130.56, 159, 9187, 260, 173,
  47, "沖縄県", "九州", "那覇市", 26.21, 127.68, 147, 2281, 240, 644
)

# --- 1. GGally: ペアプロットでデータの全体像を把握 ---
# 量的変数間の関係性（散布図、相関係数、分布）を一覧表示します。
ggpairs_plot <- ggpairs(
  pref_data,
  columns = c("population_2023", "area_km2", "income_M_yen", "pop_density"),
  title = "都道府県データのペアプロット (GGally)",
  upper = list(continuous = wrap("cor", use = "pairwise")), # 相関係数は全体で計算
  lower = list(continuous = wrap("points", mapping = aes(color = region, alpha = 0.6))), # 散布図のみ色分け
  diag = list(continuous = wrap("densityDiag", mapping = aes(fill = region, alpha = 0.6))) # 密度プロットも色分け
)
print(ggpairs_plot)


# --- 2. ggridges: リッジラインプロットで地方別の分布を比較 ---
# 地方ごとに、一人あたり県民所得の分布がどう違うかを見てみます。
ridges_plot <- ggplot(pref_data, aes(x = income_M_yen, y = fct_reorder(region, income_M_yen), fill = region)) +
  geom_density_ridges(scale = 0.9, alpha = 0.8) +
  labs(
    title = "地方別の県民所得の分布",
    x = "一人あたり県民所得 (万円)",
    y = "地方"
  ) +
  theme_ridges(grid = TRUE) +
  theme(legend.position = "none")
print(ridges_plot)


# --- 3. plotly: インタラクティブな3D散布図 ---
# 人口、面積、所得の関係を3次元でインタラクティブに可視化します。
# 右下のViewerペインでマウスでぐりぐり動かせます。
plotly_3d_plot <- plot_ly(
  pref_data,
  x = ~population_2023,
  y = ~area_km2,
  z = ~income_M_yen,
  color = ~region,
  text = ~prefecture, # マウスオーバーで県名を表示
  hoverinfo = "text+x+y+z",
  type = "scatter3d",
  mode = "markers"
) %>% layout(
  title = "人口・面積・所得の3D散布図 (Plotly)",
  scene = list(
    xaxis = list(title = "人口(万人)"),
    yaxis = list(title = "面積(km2)"),
    zaxis = list(title = "所得(万円)")
  )
)
print(plotly_3d_plot)


# --- 4. leaflet: インタラクティブな地図 ---
# 各都道府県の人口密度を地図上に円の大きさでプロットします。
leaflet_map <- leaflet(pref_data) %>%
  addTiles() %>%
  addCircleMarkers(
    lng = ~lon, lat = ~lat,
    radius = ~ sqrt(pop_density) / 5, # 人口密度の平方根で円の半径を調整
    color = "tomato",
    stroke = FALSE, fillOpacity = 0.6,
    popup = ~ paste(prefecture, "<br>", "人口密度:", pop_density, "人/km2")
  ) %>%
  addControl("都道府県別 人口密度 (Leaflet)", position = "topright")
print(leaflet_map)


# --- 5. patchwork: 複数のグラフを組み合わせる ---
# 人口トップ10の棒グラフと、面積と所得の散布図を並べて表示します。
p1 <- pref_data %>%
  slice_max(order_by = population_2023, n = 10) %>%
  ggplot(aes(x = reorder(prefecture, population_2023), y = population_2023, fill = region)) +
  geom_col() +
  coord_flip() +
  labs(title = "人口トップ10", x = "", y = "人口 (万人)") +
  theme(legend.position = "none")

p2 <- ggplot(pref_data, aes(x = area_km2, y = income_M_yen, color = region)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "面積と所得の関係", x = "面積 (km2)", y = "所得 (万円)")

patchwork_plot <- (p1 | p2) + plot_annotation(title = "都道府県データの組み合わせグラフ (Patchwork)")
print(patchwork_plot)


# --- 6. gganimate: アニメーションで変化を表現 ---
# 1995年から2020年までの人口推移をアニメーションにします。（※データは簡易的なものです）
# まずはアニメーション用のデータを作成
anim_data <- pref_data %>%
  mutate(
    pop_1995 = population_2023 * runif(47, 0.85, 0.95),
    pop_2010 = population_2023 * runif(47, 0.95, 1.02)
  ) %>%
  select(prefecture, region, pop_1995, pop_2010, population_2023) %>%
  rename(pop_2023 = population_2023) %>%
  pivot_longer(
    cols = starts_with("pop_"),
    names_to = "year",
    names_prefix = "pop_",
    values_to = "population"
  ) %>%
  mutate(year = as.integer(year))

# アニメーションを作成
gganim_plot <- ggplot(anim_data, aes(x = population, y = reorder(prefecture, population), fill = region)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = prefecture), hjust = 1.1, color = "white", size = 3) +
  labs(
    title = "都道府県別 人口推移ランキング",
    subtitle = "Year: {frame_time}",
    x = "人口 (万人)",
    y = ""
  ) +
  theme_minimal() +
  theme(axis.text.y = element_blank(), legend.position = "top") +
  # ここからがgganimateの魔法
  transition_time(year) +
  ease_aes("linear") +
  view_follow(fixed_y = TRUE) # y軸の表示範囲を固定

# アニメーションを実行（GIFファイルが生成されます）
animate(gganim_plot, nframes = 200, fps = 10, renderer = gifski_renderer("pref_population.gif"))


# --- 7. highcharter: インタラクティブな棒グラフ ---
# 地方ごとの平均所得をインタラクティブな棒グラフで表示します。
highchart_plot <- pref_data %>%
  group_by(region) %>%
  summarise(avg_income = mean(income_M_yen)) %>%
  hchart(
    "column", hcaes(x = region, y = avg_income, color = region)
  ) %>%
  hc_title(text = "地方別の平均所得 (Highcharter)") %>%
  hc_xAxis(title = list(text = "地方")) %>%
  hc_yAxis(title = list(text = "平均所得 (万円)"))
print(highchart_plot)


# --- 8. ggraph: ネットワーク図で地理的な関係性を可視化 ---
# 隣接する都道府県を線で結んだネットワーク図を作成します。
# まず、隣接関係データを作成
edges <- tribble(
  ~from, ~to,
  "北海道", "青森県", # 津軽海峡
  "青森県", "岩手県", "青森県", "秋田県",
  "岩手県", "宮城県", "岩手県", "秋田県",
  "宮城県", "秋田県", "宮城県", "山形県", "宮城県", "福島県",
  "秋田県", "山形県",
  "山形県", "福島県", "山形県", "新潟県",
  "福島県", "茨城県", "福島県", "栃木県", "福島県", "群馬県", "福島県", "新潟県",
  "茨城県", "栃木県", "茨城県", "埼玉県", "茨城県", "千葉県",
  "栃木県", "群馬県", "栃木県", "埼玉県",
  "群馬県", "埼玉県", "群馬県", "新潟県", "群馬県", "長野県",
  "埼玉県", "千葉県", "埼玉県", "東京都", "埼玉県", "山梨県", "埼玉県", "長野県",
  "千葉県", "東京都",
  "東京都", "神奈川県", "東京都", "山梨県",
  "神奈川県", "山梨県", "神奈川県", "静岡県",
  "新潟県", "富山県", "新潟県", "長野県",
  "富山県", "石川県", "富山県", "長野県", "富山県", "岐阜県",
  "石川県", "福井県", "石川県", "岐阜県",
  "福井県", "岐阜県", "福井県", "滋賀県", "福井県", "京都府",
  "山梨県", "長野県", "山梨県", "静岡県",
  "長野県", "岐阜県", "長野県", "静岡県", "長野県", "愛知県",
  "岐阜県", "愛知県", "岐阜県", "三重県", "岐阜県", "滋賀県",
  "静岡県", "愛知県",
  "愛知県", "三重県",
  "三重県", "滋賀県", "三重県", "京都府", "三重県", "奈良県", "三重県", "和歌山県",
  "滋賀県", "京都府",
  "京都府", "大阪府", "京都府", "兵庫県", "京都府", "奈良県",
  "大阪府", "兵庫県", "大阪府", "奈良県", "大阪府", "和歌山県",
  "兵庫県", "鳥取県", "兵庫県", "岡山県",
  "奈良県", "和歌山県",
  "鳥取県", "島根県", "鳥取県", "岡山県", "鳥取県", "広島県",
  "島根県", "広島県", "島根県", "山口県",
  "岡山県", "広島県", "岡山県", "香川県", # 瀬戸大橋
  "広島県", "山口県", "広島県", "愛媛県", # しまなみ海道
  "山口県", "福岡県", # 関門海峡
  "徳島県", "香川県", "徳島県", "愛媛県", "徳島県", "高知県",
  "香川県", "愛媛県",
  "愛媛県", "高知県",
  "福岡県", "佐賀県", "福岡県", "熊本県", "福岡県", "大分県",
  "佐賀県", "長崎県",
  "熊本県", "大分県", "熊本県", "宮崎県", "熊本県", "鹿児島県",
  "大分県", "宮崎県",
  "宮崎県", "鹿児島県"
)

# igraphオブジェクトを作成
graph <- graph_from_data_frame(edges, directed = FALSE, vertices = pref_data)

# ggraphで可視化
ggraph_plot <- ggraph(graph, layout = "manual", x = pref_data$lon, y = pref_data$lat) +
  geom_edge_fan(aes(alpha = 0.5), width = 0.5) +
  geom_node_point(aes(color = region), size = 5) +
  geom_node_text(aes(label = prefecture), repel = TRUE, size = 2.5) +
  theme_graph() +
  labs(title = "都道府県の隣接関係ネットワーク (ggraph)")
print(ggraph_plot)
