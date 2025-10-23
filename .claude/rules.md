# Rプロジェクトのルール

## ファイルエンコーディング

- 日本語テキストファイル（.txt、.csv等）を読み込む際は、**fileEncoding = "CP932"** を使用すること
- `read.table()`, `read.csv()` などでファイルを読み込む場合は、必ず `fileEncoding = "CP932"` を指定する

例:
```r
data <- read.table("ファイル名.txt", header = TRUE, fileEncoding = "CP932", sep = "\t")
```

## その他のルール

- コード内のコメントは日本語で記述する
- データフレームの列名も日本語で記述可能
