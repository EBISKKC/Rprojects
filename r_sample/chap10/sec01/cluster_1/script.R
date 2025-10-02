file <- "学習時間.txt"                # 読み込むファイル名を設定

data <- read.delim(                   # ファイルを読み込んでdataに格納
  file,
  header=T,                           # 1行目は列名
  row.names=1,                        # 1列目が行名
  fileEncoding="CP932"                # 文字コードをShift_JISに指定
)

time <- matrix(c(data[1,],            # データフレーム1行目から順に
                 data[2,],            # 読み込んで行列を作る
                 data[3,],
                 data[4,],
                 data[5,],
                 data[6,],
                 data[7,]
), 7, 5, byrow = TRUE # 7×5の行列にする
)
colnames(time) <- c(colnames(data))   # 列名を設定
rownames(time) <- c(rownames(data))   # 行名を設定

