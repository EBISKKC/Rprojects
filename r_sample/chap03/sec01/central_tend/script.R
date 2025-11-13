tbl <- read.csv("access.csv", encoding = "UTF-8") # access.csvをtblに代入
m <- mean(tbl$アクセス数)                         # アクセス数の平均をmに代入
print(m)                                          # コンソールに出力
