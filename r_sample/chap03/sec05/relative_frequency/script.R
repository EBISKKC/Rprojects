# access.csvをデータフレームとしてdataに代入
data <- read.csv("access.csv", encoding="UTF-8")
# ヒストグラムを作成し、hist()の戻り値をhstに代入
hst <- hist(data$アクセス数)

# 度数分布表を作成
freq <- data.frame(
                   "階級値"=hst$mids, # 階級値の列
                   "度数"=hst$counts  # 度数の列
                   )

# 相対度数を求める
rela_freq <- hst$counts / length(data$アクセス数)

# 累積相対度数を求める
cumu_freq <- cumsum(rela_freq)
# 相対度数分布表を作成
freqtable <- data.frame(
  freq,                     # 度数分布表
  "相対度数"=rela_freq,     # 階級ごとの相対度数
  "累積相対度数"=cumu_freq  # 階級ごとの累積相対度数
)

# 相対度数の棒グラフを作成
barplot(
  freqtable$相対度数,          # freqtableの$相対度数の列をグラフにする
  names.arg = freqtable$階級値,# グラフの横軸に階級値を表示
  col = "RED",                 # 棒の色を赤にする
  border = TRUE,               # 棒の境界線を表示
  space = 0                    # 棒と棒の間のスペースを0にする
)
