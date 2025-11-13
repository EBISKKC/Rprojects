# すべての課題を実行する統合スクリプト（課題3）

cat("=======================================================\n")
cat("              課題3 統計検定の実行                     \n")
cat("=======================================================\n\n")

cat("作業ディレクトリ:", getwd(), "\n\n")

# データの読み込み
cat("データを読み込んでいます...\n")
data <- read.csv("../cv.csv", header = TRUE)
cat("データの読み込みが完了しました。\n")
cat("データサイズ:", nrow(data), "行 ×", ncol(data), "列\n\n")

# openxlsxパッケージの確認とインストール
if (!require(openxlsx)) {
  cat("openxlsxパッケージをインストールしています...\n")
  install.packages("openxlsx")
}
library(openxlsx)

# Excelワークブックを作成
wb <- createWorkbook()

# =======================================================
# 課題① ウェルチのt検定
# =======================================================
cat("=======================================================\n")
cat("課題① ウェルチのt検定\n")
cat("東日本 vs 西日本の平均値の差の検定\n")
cat("=======================================================\n\n")

# 連続変数を選択
continuous_vars <- names(data)[!names(data) %in% c("ken", "area2", "area3")]

# 結果を格納するデータフレーム
results1 <- data.frame(
  変数名 = character(),
  東日本平均 = numeric(),
  西日本平均 = numeric(),
  t値 = numeric(),
  自由度 = numeric(),
  p値 = numeric(),
  有意差 = character(),
  stringsAsFactors = FALSE
)

# 各変数についてウェルチのt検定を実行
for (var in continuous_vars) {
  higashi <- data[data$area2 == "higashi", var]
  nishi <- data[data$area2 == "nishi", var]

  test_result <- t.test(higashi, nishi, var.equal = FALSE)

  mean_higashi <- mean(higashi, na.rm = TRUE)
  mean_nishi <- mean(nishi, na.rm = TRUE)

  significance <- ifelse(test_result$p.value < 0.01, "**（1%水準で有意）",
    ifelse(test_result$p.value < 0.05, "*（5%水準で有意）",
      "有意差なし"
    )
  )

  results1 <- rbind(results1, data.frame(
    変数名 = var,
    東日本平均 = mean_higashi,
    西日本平均 = mean_nishi,
    t値 = test_result$statistic,
    自由度 = test_result$parameter,
    p値 = test_result$p.value,
    有意差 = significance
  ))
}

print(results1)
cat("\n")

# 有意差がある変数をリストアップ
significant_vars1 <- results1[results1$p値 < 0.05, ]
if (nrow(significant_vars1) > 0) {
  cat("有意差が認められた変数:\n")
  for (i in 1:nrow(significant_vars1)) {
    cat(sprintf(
      "- %s: 東日本=%.2f, 西日本=%.2f (p=%.4f)\n",
      significant_vars1$変数名[i],
      significant_vars1$東日本平均[i],
      significant_vars1$西日本平均[i],
      significant_vars1$p値[i]
    ))
  }
} else {
  cat("有意差が認められた変数はありません。\n")
}

# Excelに追加
addWorksheet(wb, "1_ウェルチのt検定")
writeData(wb, "1_ウェルチのt検定", results1)
setColWidths(wb, "1_ウェルチのt検定", cols = 1:7, widths = "auto")

cat("\n課題①が完了しました。\n\n")

# =======================================================
# 課題② 1要因分散分析
# =======================================================
cat("=======================================================\n")
cat("課題② 1要因分散分析（One-way ANOVA）\n")
cat("東日本 vs 中日本 vs 西日本の平均値の差の検定\n")
cat("=======================================================\n\n")

# 結果を格納するデータフレーム
results2 <- data.frame(
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
  test_data <- data.frame(
    value = data[[var]],
    group = data$area3
  )

  anova_result <- aov(value ~ group, data = test_data)
  anova_summary <- summary(anova_result)

  mean_higashi <- mean(data[data$area3 == "higashi", var], na.rm = TRUE)
  mean_naka <- mean(data[data$area3 == "naka", var], na.rm = TRUE)
  mean_nishi <- mean(data[data$area3 == "nishi", var], na.rm = TRUE)

  f_value <- anova_summary[[1]]$`F value`[1]
  p_value <- anova_summary[[1]]$`Pr(>F)`[1]
  df1 <- anova_summary[[1]]$Df[1]
  df2 <- anova_summary[[1]]$Df[2]

  significance <- ifelse(p_value < 0.01, "**（1%水準で有意）",
    ifelse(p_value < 0.05, "*（5%水準で有意）",
      "有意差なし"
    )
  )

  results2 <- rbind(results2, data.frame(
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

print(results2)
cat("\n")

# 有意差がある変数をリストアップ
significant_vars2 <- results2[results2$p値 < 0.05, ]
if (nrow(significant_vars2) > 0) {
  cat("有意差が認められた変数:\n")
  for (i in 1:nrow(significant_vars2)) {
    cat(sprintf(
      "- %s: 東=%.2f, 中=%.2f, 西=%.2f (F=%.2f, p=%.4f)\n",
      significant_vars2$変数名[i],
      significant_vars2$東日本平均[i],
      significant_vars2$中日本平均[i],
      significant_vars2$西日本平均[i],
      significant_vars2$F値[i],
      significant_vars2$p値[i]
    ))
  }
  cat("\n")

  # 多重比較（Tukey HSD）
  cat("多重比較（Tukey HSD）を実施:\n\n")
  for (var in significant_vars2$変数名) {
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

# Excelに追加
addWorksheet(wb, "2_1要因分散分析")
writeData(wb, "2_1要因分散分析", results2)
setColWidths(wb, "2_1要因分散分析", cols = 1:9, widths = "auto")

cat("\n課題②が完了しました。\n\n")

# =======================================================
# 課題③ 2要因分散分析
# =======================================================
cat("=======================================================\n")
cat("課題③ 2要因分散分析（Two-way ANOVA）\n")
cat("要因1: 地域（area3）\n")
cat("要因2: 人口規模（170万人以上/未満）\n")
cat("=======================================================\n\n")

# 人口規模の変数を作成
data$pop_category <- ifelse(data$pop >= 1700, "170万人以上", "170万人未満")

cat("人口カテゴリの分布:\n")
print(table(data$area3, data$pop_category))
cat("\n")

# pop以外の連続変数を選択
continuous_vars3 <- continuous_vars[continuous_vars != "pop"]

# 結果を格納するデータフレーム
results3 <- data.frame(
  変数名 = character(),
  地域F値 = numeric(),
  地域p値 = numeric(),
  地域有意差 = character(),
  人口F値 = numeric(),
  人口p値 = numeric(),
  人口有意差 = character(),
  交互作用F値 = numeric(),
  交互作用p値 = numeric(),
  交互作用有意差 = character(),
  stringsAsFactors = FALSE
)

# 各変数について2要因分散分析を実行
for (var in continuous_vars3) {
  cat("分析中:", var, "\n")

  test_data <- data.frame(
    value = data[[var]],
    area = factor(data$area3),
    pop_cat = factor(data$pop_category)
  )

  anova_result <- aov(value ~ area * pop_cat, data = test_data)
  anova_summary <- summary(anova_result)

  area_f <- anova_summary[[1]]$`F value`[1]
  area_p <- anova_summary[[1]]$`Pr(>F)`[1]
  pop_f <- anova_summary[[1]]$`F value`[2]
  pop_p <- anova_summary[[1]]$`Pr(>F)`[2]
  inter_f <- anova_summary[[1]]$`F value`[3]
  inter_p <- anova_summary[[1]]$`Pr(>F)`[3]

  area_sig <- ifelse(area_p < 0.01, "**",
    ifelse(area_p < 0.05, "*", "n.s.")
  )
  pop_sig <- ifelse(pop_p < 0.01, "**",
    ifelse(pop_p < 0.05, "*", "n.s.")
  )
  inter_sig <- ifelse(inter_p < 0.01, "**",
    ifelse(inter_p < 0.05, "*", "n.s.")
  )

  results3 <- rbind(results3, data.frame(
    変数名 = var,
    地域F値 = area_f,
    地域p値 = area_p,
    地域有意差 = area_sig,
    人口F値 = pop_f,
    人口p値 = pop_p,
    人口有意差 = pop_sig,
    交互作用F値 = inter_f,
    交互作用p値 = inter_p,
    交互作用有意差 = inter_sig
  ))
}

print(results3)
cat("\n")

# 有意差のまとめ
cat("【地域（area3）に有意差がある変数】\n")
area_sig_vars <- results3[results3$地域p値 < 0.05, ]
if (nrow(area_sig_vars) > 0) {
  for (i in 1:nrow(area_sig_vars)) {
    cat(sprintf("- %s (F=%.2f, p=%.4f)\n",
      area_sig_vars$変数名[i],
      area_sig_vars$地域F値[i],
      area_sig_vars$地域p値[i]
    ))
  }
} else {
  cat("なし\n")
}
cat("\n")

cat("【人口規模に有意差がある変数】\n")
pop_sig_vars <- results3[results3$人口p値 < 0.05, ]
if (nrow(pop_sig_vars) > 0) {
  for (i in 1:nrow(pop_sig_vars)) {
    cat(sprintf("- %s (F=%.2f, p=%.4f)\n",
      pop_sig_vars$変数名[i],
      pop_sig_vars$人口F値[i],
      pop_sig_vars$人口p値[i]
    ))
  }
} else {
  cat("なし\n")
}
cat("\n")

cat("【交互作用（地域×人口規模）に有意差がある変数】\n")
inter_sig_vars <- results3[results3$交互作用p値 < 0.05, ]
if (nrow(inter_sig_vars) > 0) {
  for (i in 1:nrow(inter_sig_vars)) {
    cat(sprintf("- %s (F=%.2f, p=%.4f)\n",
      inter_sig_vars$変数名[i],
      inter_sig_vars$交互作用F値[i],
      inter_sig_vars$交互作用p値[i]
    ))
  }
} else {
  cat("なし\n")
}
cat("\n")

# 交互作用プロットの作成
if (nrow(inter_sig_vars) > 0) {
  cat("交互作用プロットを作成します...\n")

  if (!dir.exists("interaction_plots")) {
    dir.create("interaction_plots")
  }

  for (var in inter_sig_vars$変数名) {
    means <- aggregate(data[[var]], by = list(data$area3, data$pop_category), FUN = mean)
    names(means) <- c("area", "pop_cat", "mean")

    filename <- paste0("interaction_plots/interaction_", var, ".png")
    png(filename, width = 600, height = 400)

    par(mar = c(5, 5, 4, 2))
    plot(1:3, means[means$pop_cat == "170万人以上", "mean"],
      type = "b", col = "blue", pch = 16, lwd = 2,
      ylim = range(means$mean), xlab = "地域", ylab = var,
      main = paste(var, "の交互作用プロット"),
      xaxt = "n"
    )
    lines(1:3, means[means$pop_cat == "170万人未満", "mean"],
      type = "b", col = "red", pch = 17, lwd = 2
    )
    axis(1, at = 1:3, labels = c("東日本", "中日本", "西日本"))
    legend("topright",
      legend = c("170万人以上", "170万人未満"),
      col = c("blue", "red"), pch = c(16, 17), lwd = 2
    )

    dev.off()
    cat("  ", filename, "を作成\n")
  }
}

# Excelに追加
addWorksheet(wb, "3_2要因分散分析")
writeData(wb, "3_2要因分散分析", results3)
setColWidths(wb, "3_2要因分散分析", cols = 1:10, widths = "auto")

# 交互作用プロットをExcelに追加
if (nrow(inter_sig_vars) > 0) {
  addWorksheet(wb, "3_交互作用プロット")
  row_position <- 1

  for (var in inter_sig_vars$変数名) {
    filename <- paste0("interaction_plots/interaction_", var, ".png")
    if (file.exists(filename)) {
      insertImage(wb, "3_交互作用プロット",
        file = filename,
        startRow = row_position,
        startCol = 1,
        width = 6,
        height = 4
      )
      writeData(wb, "3_交互作用プロット",
        x = var,
        startRow = row_position,
        startCol = 8
      )
      row_position <- row_position + 21
    }
  }
}

cat("\n課題③が完了しました。\n\n")

# =======================================================
# Excelファイルを保存
# =======================================================
cat("=======================================================\n")
cat("Excelファイルを保存しています...\n")
saveWorkbook(wb, "kadai3_results.xlsx", overwrite = TRUE)
cat("kadai3_results.xlsx に結果を保存しました。\n")
cat("=======================================================\n\n")

cat("すべての課題が完了しました！\n")
cat("以下のファイルが生成されました:\n")
cat("  - kadai3_results.xlsx (すべての結果)\n")
if (nrow(inter_sig_vars) > 0) {
  cat("  - interaction_plots/ (交互作用プロット)\n")
}
