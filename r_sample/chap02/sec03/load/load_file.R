# ファイルをデータフレームに読み込む関数
load.file <- function(path) {
  data <- read.table(    # ファイルを読み込んでデータフレームを作成
    path,                # 受け取ったファイル名
    header=T,            # 1行目は列名であることを指定
    fileEncoding="CP932" # 文字コードをShift_JISに指定
  )
  return(data)           # 作成したデータフレームを戻り値として返す
}
