# 課題1: データ可視化と記述統計

# 1. ライブラリの読み込み
if (!require("tidyverse")) {
  install.packages("tidyverse", repos = "http://cran.rstudio.com/")
}
library(tidyverse)

# 2. データの読み込みと前処理
# ファイルパスは環境に合わせて修正してください
file_path <- "/Users/ebisushingo/Desktop/Rprojects/jikken-matuoka/matuoka.csv"

# ヘッダー部分(3行目と4行目)を別々に読み込みます
header_row3 <- read.csv(file_path, skip = 2, nrows = 1, header = FALSE, fileEncoding = "UTF-8", stringsAsFactors = FALSE)
header_row4 <- read.csv(file_path, skip = 3, nrows = 1, header = FALSE, fileEncoding = "UTF-8", stringsAsFactors = FALSE)

# データ本体(5行目以降)を読み込みます
df <- read.csv(file_path, skip = 4, header = FALSE, fileEncoding = "UTF-8")

# 2行に分かれているヘッダーを結合して、列名を生成します
col_names <- c(as.character(header_row3[1,1]), as.character(header_row3[1,2]))
for (i in seq(3, ncol(header_row3), by = 2)) {
  base_name <- as.character(header_row3[1, i])
  if (!is.na(base_name) && base_name != "" && i + 1 <= ncol(header_row4)) {
    col_names <- c(col_names, paste(base_name, as.character(header_row4[1, i]), sep = "_"))
    col_names <- c(col_names, paste(base_name, as.character(header_row4[1, i+1]), sep = "_"))
  }
}

# データフレームの列数に合わせて列名を調整します
colnames(df) <- col_names[1:ncol(df)]

# 不要な列(班名, 氏名)を削除し、データが不完全な行を削除します
df_wide <- df[, -c(1, 2)]

# すべての列を数値型に強制変換
df_wide[] <- lapply(df_wide, function(x) as.numeric(as.character(x)))

# 欠損値のある行を除去
df_wide <- na.omit(df_wide)

# データを扱いやすいように「ワイド形式」から「ロング形式」に変換します
df_long <- df_wide %>%
  pivot_longer(
    cols = everything(),
    names_to = c(".value", "species"),
    # 列名の末尾にある "_野生種" または "_栽培種" を基準に分割します
    names_pattern = "(.+)_([^_]+)$"
  )

# species列を因子型(カテゴリ変数)に変換します
df_long$species <- as.factor(df_long$species)

# 3. 課題1-1: 箱ひげ図の作成
# species列以外のすべての量的形質の名前を取得します
traits <- names(df_long)[-1]

# 各形質について箱ひげ図を生成し、pngファイルとして保存します
for (trait in traits) {
  p <- ggplot(df_long, aes(x = species, y = .data[[trait]], fill = species)) +
    geom_boxplot() +
    labs(title = paste(trait, "の比較"), x = "種", y = "値") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5)) # タイトルを中央揃え
  
  print(p)
  ggsave(paste0("/Users/ebisushingo/Desktop/Rprojects/jikken-matuoka/kadai1_boxplot_", make.names(trait), ".png"), plot = p, width = 6, height = 4)
}

# 4. 課題1-2: ヒストグラムの作成
# 各形質についてヒストグラムを生成し、pngファイルとして保存します
for (trait in traits) {
  p <- ggplot(df_long, aes(x = .data[[trait]], fill = species)) +
    geom_histogram(position = "identity", alpha = 0.7, bins = 15) +
    facet_wrap(~species, ncol = 1) +
    labs(title = paste(trait, "のヒストグラム"), x = "値", y = "度数") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
    
  print(p)
  ggsave(paste0("/Users/ebisushingo/Desktop/Rprojects/jikken-matuoka/kadai1_histogram_", make.names(trait), ".png"), plot = p, width = 6, height = 5)
}

# 5. 課題1-3: 記述統計量の計算
# 種(species)ごとにグループ化し、すべての量的形質について記述統計量を計算します
summary_stats <- df_long %>%
  group_by(species) %>%
  summarise(across(all_of(traits),
                   list(
                     平均 = ~mean(.x, na.rm = TRUE),
                     中央値 = ~median(.x, na.rm = TRUE),
                     分散 = ~var(.x, na.rm = TRUE),
                     標準偏差 = ~sd(.x, na.rm = TRUE)
                   )), .groups = 'drop')

# 計算結果をコンソールに出力します
print("記述統計量:")
print(summary_stats)

# 結果をCSVファイルとして保存します
write.csv(summary_stats, "/Users/ebisushingo/Desktop/Rprojects/jikken-matuoka/kadai1_summary_stats.csv", row.names = FALSE)
