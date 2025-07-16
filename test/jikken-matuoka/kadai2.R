# 課題2: t検定

# 1. ライブラリの読み込み
library(tidyverse)

# 2. データの読み込みと前処理 (kadai1.Rと同様)
file_path <- "/Users/ebisushingo/Desktop/Rprojects/jikken-matuoka/matuoka.csv"
header_row3 <- read.csv(file_path, skip = 2, nrows = 1, header = FALSE, fileEncoding = "UTF-8", stringsAsFactors = FALSE)
header_row4 <- read.csv(file_path, skip = 3, nrows = 1, header = FALSE, fileEncoding = "UTF-8", stringsAsFactors = FALSE)
df <- read.csv(file_path, skip = 4, header = FALSE, fileEncoding = "UTF-8")

col_names <- c(as.character(header_row3[1, 1]), as.character(header_row3[1, 2]))
for (i in seq(3, ncol(header_row3), by = 2)) {
  base_name <- as.character(header_row3[1, i])
  if (!is.na(base_name) && base_name != "" && i + 1 <= ncol(header_row4)) {
    col_names <- c(col_names, paste(base_name, as.character(header_row4[1, i]), sep = "_"))
    col_names <- c(col_names, paste(base_name, as.character(header_row4[1, i + 1]), sep = "_"))
  }
}

colnames(df) <- col_names[1:ncol(df)]
df_wide <- df[, -c(1, 2)]

# すべての列を数値型に強制変換
df_wide[] <- lapply(df_wide, function(x) as.numeric(as.character(x)))

# 欠損値のある行を除去
df_wide <- na.omit(df_wide)

# --- ハズレ値除去処理を追加 ---
drop_outliers <- function(df) {
  for (col in names(df)) {
    x <- df[[col]]
    Q1 <- quantile(x, 0.25, na.rm = TRUE)
    Q3 <- quantile(x, 0.75, na.rm = TRUE)
    IQR <- Q3 - Q1
    lower <- Q1 - 1.5 * IQR
    upper <- Q3 + 1.5 * IQR
    x[x < lower | x > upper] <- NA
    df[[col]] <- x
  }
  df <- na.omit(df)
  return(df)
}
df_wide <- drop_outliers(df_wide)
# --- ここまで ---

df_long <- df_wide %>%
  pivot_longer(
    cols = everything(),
    names_to = c(".value", "species"),
    names_pattern = "(.+)_([^_]+)$"
  )

df_long$species <- as.factor(df_long$species)

# 3. t検定の実行と結果の出力
# 結果を保存するファイル
output_file <- "/Users/ebisushingo/Desktop/Rprojects/jikken-matuoka/kadai2_ttest_results.txt"
# ファイルを空にする
cat("", file = output_file)

# 形質のリスト
traits <- names(df_long)[-1]

# 各形質についてt検定を実行
for (trait in traits) {
  # 野生種と栽培種のデータを抽出
  wild_data <- df_long %>%
    filter(species == "野生種") %>%
    pull(.data[[trait]])
  cultivated_data <- df_long %>%
    filter(species == "栽培種") %>%
    pull(.data[[trait]])

  # t検定を実行
  ttest_result <- t.test(wild_data, cultivated_data)

  # 結果をファイルに追記
  sink(output_file, append = TRUE)

  cat("--------------------------------------------------\n")
  cat("形質: ", trait, " のt検定\n")
  cat("--------------------------------------------------\n\n")

  # ステップ1: 仮説の設定
  cat("ステップ1: 仮説の設定\n")
  cat("  - 帰無仮説 (H0): 野生種と栽培種の", trait, "の母平均に差はない。\n")
  cat("  - 対立仮説 (H1): 野生種と栽培種の", trait, "の母平均に差がある。\n\n")

  # ステップ2: 有意水準の設定
  cat("ステップ2: 有意水準の設定\n")
  cat("  - 有意水準 α = 0.05\n\n")

  # ステップ3: 検定統計量の計算
  cat("ステップ3: 検定統計量の計算\n")
  cat("  - t統計量: ", round(ttest_result$statistic, 4), "\n")
  cat("  - 自由度: ", round(ttest_result$parameter, 4), "\n")
  cat("  - p値: ", format.pval(ttest_result$p.value, digits = 4), "\n\n")

  # ステップ4: 意思決定
  cat("ステップ4: 意思決定\n")
  if (ttest_result$p.value < 0.05) {
    cat("  - p値 (", format.pval(ttest_result$p.value, digits = 4), ") < 有意水準 α (0.05) であるため、帰無仮説 H0 を棄却する。\n")
    cat("  - 結論: 野生種と栽培種の", trait, "の母平均には、統計的に有意な差があると言える。\n\n")
  } else {
    cat("  - p値 (", format.pval(ttest_result$p.value, digits = 4), ") >= 有意水準 α (0.05) であるため、帰無仮説 H0 を採択する。\n")
    cat("  - 結論: 野生種と栽培種の", trait, "の母平均には、統計的に有意な差があるとは言えない。\n\n")
  }

  # sinkを閉じる
  sink()
}

# 完了メッセージ
print(paste("t検定の結果が", output_file, "に保存されました。"))
