# if文による数字の処理

# 例1: 成績判定
cat("=== 成績判定 ===\n")
score <- 85

if (score >= 90) {
  grade <- "A"
} else if (score >= 80) {
  grade <- "B"
} else if (score >= 70) {
  grade <- "C"
} else if (score >= 60) {
  grade <- "D"
} else {
  grade <- "F"
}

cat("点数:", score, "→ 評価:", grade, "\n")

# 例2: 複数の数値を判定
cat("\n=== 複数の数値を判定 ===\n")
scores <- c(95, 72, 88, 45, 100)

for (s in scores) {
  if (s >= 90) {
    result <- "優秀"
  } else if (s >= 60) {
    result <- "合格"
  } else {
    result <- "不合格"
  }
  cat("点数:", s, "→", result, "\n")
}

# 例3: 偶数・奇数の判定
cat("\n=== 偶数・奇数の判定 ===\n")
numbers <- c(10, 15, 22, 33, 48)

for (n in numbers) {
  if (n %% 2 == 0) {
    cat(n, "は偶数\n")
  } else {
    cat(n, "は奇数\n")
  }
}

# 例4: 範囲チェック
cat("\n=== 温度による警告 ===\n")
temperatures <- c(-5, 10, 25, 35, 42)

for (temp in temperatures) {
  if (temp < 0) {
    status <- "凍結注意"
  } else if (temp >= 0 && temp < 15) {
    status <- "寒い"
  } else if (temp >= 15 && temp < 30) {
    status <- "快適"
  } else if (temp >= 30 && temp < 40) {
    status <- "暑い"
  } else {
    status <- "危険な暑さ"
  }
  cat("気温:", temp, "℃ →", status, "\n")
}

# 例5: ifelse関数（ベクトル全体に適用）
cat("\n=== ifelse関数の使用 ===\n")
test_scores <- c(45, 78, 92, 65, 55, 88)
results <- ifelse(test_scores >= 60, "合格", "不合格")
result_df <- data.frame(点数 = test_scores, 結果 = results)
print(result_df)

# 例6: 数値の符号判定
cat("\n=== 数値の符号判定 ===\n")
nums <- c(-10, 0, 15, -3, 8)

for (num in nums) {
  if (num > 0) {
    cat(num, "は正の数\n")
  } else if (num < 0) {
    cat(num, "は負の数\n")
  } else {
    cat(num, "はゼロ\n")
  }
}

# 例7: switch文（文字列による分岐）
cat("\n=== switch文: 曜日による営業時間 ===\n")
days <- c("月", "水", "土", "日")

for (day in days) {
  hours <- switch(day,
    "月" = "9:00-18:00",
    "火" = "9:00-18:00",
    "水" = "9:00-18:00",
    "木" = "9:00-18:00",
    "金" = "9:00-20:00",
    "土" = "10:00-17:00",
    "日" = "定休日",
    "不明"  # デフォルト値
  )
  cat(day, "曜日:", hours, "\n")
}

# 例8: switch文（数値による分岐）
cat("\n=== switch文: 数値による月の季節判定 ===\n")
months <- c(1, 5, 8, 12)

for (month in months) {
  season <- switch(as.character(month),
    "1" = "冬", "2" = "冬", "12" = "冬",
    "3" = "春", "4" = "春", "5" = "春",
    "6" = "夏", "7" = "夏", "8" = "夏",
    "9" = "秋", "10" = "秋", "11" = "秋",
    "不明"
  )
  cat(month, "月 →", season, "\n")
}

# 例9: switch文とifの組み合わせ（成績によるコメント）
cat("\n=== switch文: 成績によるコメント ===\n")
grades <- c("A", "B", "C", "D", "F")

for (g in grades) {
  comment <- switch(g,
    "A" = "素晴らしい！",
    "B" = "よくできました",
    "C" = "合格です",
    "D" = "もう少し頑張りましょう",
    "F" = "再試験が必要です",
    "評価不明"
  )
  cat("評価", g, ":", comment, "\n")
}
