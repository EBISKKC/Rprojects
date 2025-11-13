file <- "普及率.txt"               # 読み込むファイル名を設定

data <- read.delim(                # ファイルを読み込んでdataに格納
  file,
  header=T,                        # 1行目は列名であることを指定
  fileEncoding="CP932"             # 文字コードをShift_JISに指定
)

# データフレームの各列をベクトルに代入
year <- c(data[,1])                # 1列目の変量をベクトルに代入
pene <- c(data[,2])                # 2列目の変量をベクトルに代入

# 普及率の散布図を描く
plot(data, col="red")

