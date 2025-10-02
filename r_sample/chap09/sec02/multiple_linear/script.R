file <- "売上高と各種要因.txt" # 読み込むファイル名を設定

data <- read.delim(            # ファイルを読み込んでdataに格納
  file,
  header=T,                    # 1行目は列名であることを指定
  row.names=1,
  fileEncoding="CP932"         # 文字コードをShift_JISに指定
)

# データフレームの各列をベクトルに代入
var_1<- c(data[,1])           # 1列目の変量をベクトルに代入
var_2<- c(data[,2])           # 2列目の変量をベクトルに代入
var_3<- c(data[,3])           # 3列目の変量をベクトルに代入
var_4<- c(data[,4])           # 4列目の変量をベクトルに代入
var_5<- c(data[,5])           # 5列目の変量をベクトルに代入
var_6<- c(data[,6])           # 6列目の変量をベクトルに代入
 
coef <- cor(data)            # 相関係数を求める
