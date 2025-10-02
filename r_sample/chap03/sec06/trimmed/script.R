# 店舗別売上.txtをデータフレームとしてdataに代入
data <- read.table(
                    "店舗別売上.txt",
                    header=T,
                    fileEncoding="CP932"
                  )
# 平均を求める
average = mean(data$"売上高_千円")

# ヒストグラムを作成
hist(data$"売上高_千円")

# 売上高が0のデータを2件追加
data = rbind(
  data, 
  data.frame(店舗名="dummy", 売上高_千円=0),# 1行ぶんのデータ
  data.frame(店舗名="dummy", 売上高_千円=0) # 1行ぶんのデータ
)

# 上側2件を除いたトリム平均を求める
trim = mean(
  data$"売上高_千円", # 売上高の列を対象にする
  trim = 0.1          # 上側と下側から10％ぶん除外する
)
