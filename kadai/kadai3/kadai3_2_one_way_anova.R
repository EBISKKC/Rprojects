# 課題② 1要因分散分析
# 東日本、中日本、西日本で平均値に有意な差があるかを検証

# データの読み込み
data <- read.csv("../cv.csv", header = TRUE)

cat("=================================================\n")
cat("課題② 1要因分散分析（One-way ANOVA）\n")
cat("東日本 vs 中日本 vs 西日本の平均値の差の検定\n")
cat("=================================================\n\n")

# 連続変数を選択（ken, area2, area3以外）
continuous_vars <- names(data)[!names(data) %in% c("ken", "area2", "area3")]

# 結果を格納するデータフレーム
results <- data.frame(
  変数名 = character(),
  東日本平均 = numeric(),
  中日本平均 = numeric(),
  西日本平均 = numeric(),
  F値 = numeric(),
  自由度1 = integer(),
  自由度2 = integer(),
  p値 = numeric(),
  有意差 = character(),
  stringsAsFactors = FALSE
)

# 各変数について1要因分散分析を実行
for (var in continuous_vars) {
  # データフレームを作成
  test_data <- data.frame(
    value = data[[var]],
    group = data$area3
  )

  # 1要因分散分析
  anova_result <- aov(value ~ group, data = test_data)
  anova_summary <- summary(anova_result)

  # 各群の平均値
  mean_higashi <- mean(data[data$area3 == "higashi", var], na.rm = TRUE)
  mean_naka <- mean(data[data$area3 == "naka", var], na.rm = TRUE)
  mean_nishi <- mean(data[data$area3 == "nishi", var], na.rm = TRUE)

  # F値とp値を取得
  f_value <- anova_summary[[1]]$`F value`[1]
  p_value <- anova_summary[[1]]$`Pr(>F)`[1]
  df1 <- anova_summary[[1]]$Df[1]
  df2 <- anova_summary[[1]]$Df[2]

  # p値に基づく有意差の判定
  significance <- ifelse(p_value < 0.01, "**（1%水準で有意）",
    ifelse(p_value < 0.05, "*（5%水準で有意）",
      "有意差なし"
    )
  )

  # 結果を追加
  results <- rbind(results, data.frame(
    変数名 = var,
    東日本平均 = mean_higashi,
    中日本平均 = mean_naka,
    西日本平均 = mean_nishi,
    F値 = f_value,
    自由度1 = df1,
    自由度2 = df2,
    p値 = p_value,
    有意差 = significance
  ))
}

# 結果を表示
print(results)

cat("\n=================================================\n")
cat("解説\n")
cat("=================================================\n")
cat("**：p < 0.01（1%水準で有意）\n")
cat("*：p < 0.05（5%水準で有意）\n")
cat("有意差なし：p >= 0.05\n\n")

# 有意差がある変数をリストアップ
significant_vars <- results[results$p値 < 0.05, ]
if (nrow(significant_vars) > 0) {
  cat("有意差が認められた変数:\n")
  for (i in 1:nrow(significant_vars)) {
    cat(sprintf(
      "- %s: 東=%.2f, 中=%.2f, 西=%.2f (F=%.2f, p=%.4f)\n",
      significant_vars$変数名[i],
      significant_vars$東日本平均[i],
      significant_vars$中日本平均[i],
      significant_vars$西日本平均[i],
      significant_vars$F値[i],
      significant_vars$p値[i]
    ))
  }
  cat("\n")

  # 多重比較（Tukey HSD）を実施
  cat("=================================================\n")
  cat("多重比較（Tukey HSD）\n")
  cat("=================================================\n\n")

  for (var in significant_vars$変数名) {
    cat("【", var, "】\n", sep = "")
    test_data <- data.frame(
      value = data[[var]],
      group = data$area3
    )
    anova_result <- aov(value ~ group, data = test_data)
    tukey_result <- TukeyHSD(anova_result)
    print(tukey_result)
    cat("\n")
  }
} else {
  cat("有意差が認められた変数はありません。\n")
}

# Excelファイルに保存
if (!require(openxlsx)) install.packages("openxlsx")
library(openxlsx)

# 既存のワークブックを読み込み（なければ新規作成）
if (file.exists("kadai3_results.xlsx")) {
  wb <- loadWorkbook("kadai3_results.xlsx")
} else {
  wb <- createWorkbook()
}

addWorksheet(wb, "1要因分散分析")
writeData(wb, "1要因分散分析", results)
setColWidths(wb, "1要因分散分析", cols = 1:9, widths = "auto")

saveWorkbook(wb, "kadai3_results.xlsx", overwrite = TRUE)

cat("\n結果を kadai3_results.xlsx に保存しました。\n")
