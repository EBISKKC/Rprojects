# access.csvをtblに代入
tbl <- read.csv("access.csv", encoding="UTF-8")
# 階級を自動で設定してヒストグラムを作成
hist(
  tbl$アクセス数  # "アクセス数"の列を対象にする
)
