file <- "普及率.txt" # 読み込むファイル名を設定

data <- read.delim(                # ファイルを読み込んでdataに格納
  file,
  header=T,                        # 1行目は列名であることを指定
  fileEncoding="CP932"             # 文字コードをShift_JISに指定
)

# データフレームの各列をベクトルに代入
year <- c(data[,1])                # 1列目の変量をベクトルに代入
pene <- c(data[,2])                # 2列目の変量をベクトルに代入

# ロジスティック回帰分析を行う
glm <- glm(pene~year,family=binomial)

plot(year, pene,type="l")          # 実測値の散布図を描く
lines(year,                        # x座標は年代
      fitted(glm),                 # y座標は予測値
      lty=2,
      col="red",lwd=2)

exp <- cbind(data,                 # 実測値と予測値の表を作成
                fitted(glm))

