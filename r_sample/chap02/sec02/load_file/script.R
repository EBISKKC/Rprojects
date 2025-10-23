data <- read.table(             # 店舗別売上.txtをdataに代入
  "店舗別売上.txt",
  header=TRUE,                  # 1行目は列名であることを指定
  fileEncoding="CP932"          # 文字コードをShift_JISに指定
)
