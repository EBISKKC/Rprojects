data <- read.table(    # 定着度.txtをdataに代入
  "定着度.txt",
  header=T,            # 1行目は列名であることを指定
  fileEncoding="CP932" # 文字コードをShift_JISに指定
)

j <- length(data[1,])  # 列の数を調べる

for(i in c(1:j)) {
  assign(
    sprintf("x%d", i), # xに連番を付けた名前を作る
    data[,i]           # データフレムの1列目から代入する
  )
}
