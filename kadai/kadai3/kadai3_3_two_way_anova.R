# 課題③ 2要因分散分析
# 地域（東日本、中日本、西日本）と人口規模（170万人以上/未満）の
# 2つの要因が各変数に与える影響を検証

# データの読み込み
data <- read.csv("../cv.csv", header = TRUE)

cat("=================================================\n")
cat("課題③ 2要因分散分析（Two-way ANOVA）\n")
cat("要因1: 地域（area3）\n")
cat("要因2: 人口規模（170万人以上/未満）\n")
cat("=================================================\n\n")

# 人口規模の変数を作成（170万人 = 1700千人）
data$pop_category <- ifelse(data$pop >= 1700, "170万人以上", "170万人未満")

cat("人口カテゴリの分布:\n")
print(table(data$area3, data$pop_category))
cat("\n")

# 連続変数を選択（ken, area2, area3, pop以外）
continuous_vars <- names(data)[!names(data) %in% c("ken", "area2", "area3", "pop", "pop_category")]

# 結果を格納するデータフレーム
results <- data.frame(
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
for (var in continuous_vars) {
  cat("分析中:", var, "\n")

  # データフレームを作成
  test_data <- data.frame(
    value = data[[var]],
    area = factor(data$area3),
    pop_cat = factor(data$pop_category)
  )

  # 2要因分散分析（交互作用を含む）
  anova_result <- aov(value ~ area * pop_cat, data = test_data)
  anova_summary <- summary(anova_result)

  # 結果を取得
  area_f <- anova_summary[[1]]$`F value`[1]
  area_p <- anova_summary[[1]]$`Pr(>F)`[1]
  pop_f <- anova_summary[[1]]$`F value`[2]
  pop_p <- anova_summary[[1]]$`Pr(>F)`[2]
  inter_f <- anova_summary[[1]]$`F value`[3]
  inter_p <- anova_summary[[1]]$`Pr(>F)`[3]

  # 有意差の判定
  area_sig <- ifelse(area_p < 0.01, "**",
    ifelse(area_p < 0.05, "*", "n.s.")
  )
  pop_sig <- ifelse(pop_p < 0.01, "**",
    ifelse(pop_p < 0.05, "*", "n.s.")
  )
  inter_sig <- ifelse(inter_p < 0.01, "**",
    ifelse(inter_p < 0.05, "*", "n.s.")
  )

  # 結果を追加
  results <- rbind(results, data.frame(
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

# 結果を表示
print(results)

cat("\n=================================================\n")
cat("解説\n")
cat("=================================================\n")
cat("**：p < 0.01（1%水準で有意）\n")
cat("*：p < 0.05（5%水準で有意）\n")
cat("n.s.：有意差なし（not significant）\n\n")

# 地域に有意差がある変数
cat("【地域（area3）に有意差がある変数】\n")
area_sig_vars <- results[results$地域p値 < 0.05, ]
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

# 人口規模に有意差がある変数
cat("【人口規模に有意差がある変数】\n")
pop_sig_vars <- results[results$人口p値 < 0.05, ]
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

# 交互作用がある変数
cat("【交互作用（地域×人口規模）に有意差がある変数】\n")
inter_sig_vars <- results[results$交互作用p値 < 0.05, ]
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
  cat("=================================================\n")
  cat("交互作用プロットを作成します\n")
  cat("=================================================\n\n")

  # プロットディレクトリを作成
  if (!dir.exists("interaction_plots")) {
    dir.create("interaction_plots")
  }

  for (var in inter_sig_vars$変数名) {
    # 各群の平均値を計算
    means <- aggregate(data[[var]], by = list(data$area3, data$pop_category), FUN = mean)
    names(means) <- c("area", "pop_cat", "mean")

    # プロットを作成
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
    cat("  ", filename, "を作成しました。\n")
  }
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

addWorksheet(wb, "2要因分散分析")
writeData(wb, "2要因分散分析", results)
setColWidths(wb, "2要因分散分析", cols = 1:10, widths = "auto")

# 交互作用プロットをExcelに追加
if (nrow(inter_sig_vars) > 0) {
  addWorksheet(wb, "交互作用プロット")
  row_position <- 1

  for (var in inter_sig_vars$変数名) {
    filename <- paste0("interaction_plots/interaction_", var, ".png")
    if (file.exists(filename)) {
      insertImage(wb, "交互作用プロット",
        file = filename,
        startRow = row_position,
        startCol = 1,
        width = 6,
        height = 4
      )
      writeData(wb, "交互作用プロット",
        x = var,
        startRow = row_position,
        startCol = 8
      )
      row_position <- row_position + 21
    }
  }
}

saveWorkbook(wb, "kadai3_results.xlsx", overwrite = TRUE)

cat("\n結果を kadai3_results.xlsx に保存しました。\n")
