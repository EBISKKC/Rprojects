# access.csvをtblに代入
tbl <- read.csv("access.csv", encoding="UTF-8")

# 階級の幅をbyに代入
cl <- 10
# 最小値、最大値を求める
fn <- fivenum(tbl$アクセス数)
# 最小値の上位2桁で丸め、階級幅×2を引いてminに代入
min <- signif(fn[1], 2) - cl * 2
# 最大値に階級幅×2を加えてmaxに代入
max <- fn[5] + cl * 2

hist(
  tbl$アクセス数,        # ヒストグラムにするデータを指定
  breaks = seq(          # シーケンスを持つベクトルを作成
    min,                 # 下限値
    max,                 # 上限値
    by = cl              # 階級の幅
  ),
  main = "アクセス状況", # タイトルを設定
  xlab = "アクセス数",   # 横軸の項目名を設定
  ylab = "頻度",         # 縦軸の項目名を設定
  col="limegreen"        # 棒グラフの色を設定
)
