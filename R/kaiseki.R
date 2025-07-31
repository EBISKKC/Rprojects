# クスノキの葉とダニ室の解析
# 日付: 2025年7月31日

# 必要なライブラリの読み込み
library(ggplot2)
library(dplyr)
library(readr)

# データの読み込み
data <- read.csv("data/25_7_22 - シート1 .csv", encoding = "UTF-8")

# データの確認
print("データの構造:")
str(data)
print("データの概要:")
summary(data)
print("最初の数行:")
head(data)

# データの前処理（列名の確認と整理）
print("列名:")
colnames(data)

# 1. 葉とダニ室の分布測定
print("=== 1. 葉とダニ室の分布測定 ===")

# 葉長の基本統計
print("葉長の基本統計:")
print(summary(data$Leaf_length_mm))

# ダニ室数の基本統計
print("ダニ室数の基本統計:")
print(summary(data$Numbers_of_domatia))

# 葉長のヒストグラム
p1 <- ggplot(data, aes(x = Leaf_length_mm)) +
  geom_histogram(bins = 15, fill = "lightblue", color = "black", alpha = 0.7) +
  labs(title = "葉長の分布",
       x = "葉長 (mm)",
       y = "頻度") +
  theme_minimal()

# ヒストグラムを保存
ggsave("output/leaf_length_histogram.png", p1, width = 8, height = 6, dpi = 300)
print("葉長のヒストグラムを保存しました: output/leaf_length_histogram.png")

# ダニ室数のヒストグラム
p2 <- ggplot(data, aes(x = Numbers_of_domatia)) +
  geom_histogram(bins = max(data$Numbers_of_domatia) + 1, fill = "lightcoral", color = "black", alpha = 0.7) +
  labs(title = "ダニ室数の分布",
       x = "ダニ室数",
       y = "頻度") +
  scale_x_continuous(breaks = 0:max(data$Numbers_of_domatia)) +
  theme_minimal()

# ヒストグラムを保存
ggsave("output/domatia_count_histogram.png", p2, width = 8, height = 6, dpi = 300)
print("ダニ室数のヒストグラムを保存しました: output/domatia_count_histogram.png")

# ダニ室数の分布型の分析
print("ダニ室数の分布:")
domatia_table <- table(data$Numbers_of_domatia)
print(domatia_table)
print("ダニ室数の度数分布の割合:")
print(prop.table(domatia_table))

# 2. 葉サイズとダニ室の関係
print("=== 2. 葉サイズとダニ室の関係 ===")

# 散布図（横軸：葉長、縦軸：ダニ室数）
p3 <- ggplot(data, aes(x = Leaf_length_mm, y = Numbers_of_domatia)) +
  geom_point(size = 3, alpha = 0.7, color = "darkgreen") +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "葉長とダニ室数の関係",
       x = "葉長 (mm)",
       y = "ダニ室数") +
  theme_minimal()

# 散布図を保存
ggsave("output/leaf_length_vs_domatia_scatter.png", p3, width = 8, height = 6, dpi = 300)
print("散布図を保存しました: output/leaf_length_vs_domatia_scatter.png")

# 相関分析
correlation <- cor(data$Leaf_length_mm, data$Numbers_of_domatia)
print(paste("葉長とダニ室数の相関係数:", round(correlation, 3)))

# 線形回帰分析
lm_model <- lm(Numbers_of_domatia ~ Leaf_length_mm, data = data)
print("線形回帰分析の結果:")
print(summary(lm_model))

# 結果のまとめ
print("=== 解析結果のまとめ ===")
print(paste("サンプル数:", nrow(data)))
print(paste("葉長の平均:", round(mean(data$Leaf_length_mm), 2), "mm"))
print(paste("葉長の標準偏差:", round(sd(data$Leaf_length_mm), 2), "mm"))
print(paste("ダニ室数の平均:", round(mean(data$Numbers_of_domatia), 2)))
print(paste("ダニ室数の標準偏差:", round(sd(data$Numbers_of_domatia), 2)))
print(paste("葉長とダニ室数の相関係数:", round(correlation, 3)))
