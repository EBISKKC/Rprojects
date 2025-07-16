# カイコ鼓動データ解析スクリプト
# data/sakamoto実験 - シート1.csv を解析し、温度ごとの平均・標準偏差・グラフを作成

library(tidyverse)



# 本当のヘッダーが5行目にある場合（上4行をスキップ）
df <- read.csv("data/sakamoto実験 - シート1.csv", check.names = FALSE, skip = 4, header = TRUE)

# カラム名を確認
print(colnames(df))

# 1列目を「個体番号」に強制
colnames(df)[1] <- "個体番号"

# 「個体番号」以外のカラム名を抽出し、不正なカラムを除外
temp_cols <- setdiff(colnames(df), "個体番号")
temp_cols <- temp_cols[temp_cols != "" & !is.na(temp_cols)]
print(temp_cols) # デバッグ用

# データをlong型に変換（tidyデータ化）
df_long <- df %>%
  pivot_longer(
    all_of(temp_cols),
    names_to = "温度",
    values_to = "鼓動回数"
  ) %>%
  mutate(
    温度 = as.numeric(gsub("[^0-9.]", "", 温度)), # 温度名から数値だけ抽出
    鼓動回数 = as.numeric(鼓動回数)
  ) %>%
  drop_na()

# 温度順に並べ替え
df_long <- df_long %>% arrange(温度)

# 温度ごとの統計量
summary_stats <- df_long %>%
  group_by(温度) %>%
  summarise(
    個体数 = n(),
    平均 = mean(鼓動回数, na.rm = TRUE),
    標準偏差 = sd(鼓動回数, na.rm = TRUE)
  )
print(summary_stats)

# 平均＋標準偏差エラーバー付きグラフ
p <- ggplot(summary_stats, aes(x = 温度, y = 平均)) +
  geom_line(group = 1, color = "steelblue", size = 1.2) +
  geom_point(size = 3, color = "steelblue") +
  geom_errorbar(aes(ymin = 平均 - 標準偏差, ymax = 平均 + 標準偏差), width = 0.5, color = "orange") +
  labs(
    title = "温度別の平均鼓動回数と標準偏差",
    x = "温度 (℃)",
    y = "1分間の鼓動回数"
  ) +
  theme_minimal(base_size = 14)

print(p)
ggsave("output/kaiko_heartbeat_by_temp.png", p, width = 7, height = 5)

# 個体ごとの推移も可視化（オプション）
p2 <- ggplot(df_long, aes(x = 温度, y = 鼓動回数, group = 個体番号, color = 個体番号)) +
  geom_line(alpha = 0.5) +
  geom_point() +
  labs(
    title = "個体ごとの温度別鼓動回数推移",
    x = "温度 (℃)",
    y = "1分間の鼓動回数"
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none")

print(p2)
ggsave("output/kaiko_heartbeat_individual.png", p2, width = 7, height = 5)
