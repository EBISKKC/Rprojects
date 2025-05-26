# データのインポートとグラフ描画
# ファイルパスを指定
file_path <- "gakujitsu2025data - シート1.csv"

# データの読み込み
library(readr)
data <- read_csv(file_path, locale = locale(encoding = "UTF-8"), show_col_types = FALSE)

# 先頭列名が空の場合は削除（read_csvの仕様で...1列ができる場合があるため）
if ("...1" %in% names(data)) {
  data <- data[ , !(names(data) %in% "...1")]
}

# データの内容を確認
print(head(data))

# 可視化1: USDA_SoilOrderをx軸、SOM_colorをy軸、点の色をSOM_alkaliで表現
library(ggplot2)
p1 <- ggplot(data, aes(x = factor(USDA_SoilOrder), y = SOM_color, color = SOM_alkali)) +
  geom_jitter(width = 0.2, size = 3) +
labs(x = "USDA Soil Order", y = "SOM color", color = "SOM alkali", title = "SOM color and SOM alkali by USDA Soil Order") +
  theme_minimal()
print(p1)

# 可視化2: SOM_alkaliをx軸、pH_H2OとpH_KClをy軸に重ねて描画
library(tidyr)
data_long <- pivot_longer(data, cols = c(pH_H2O, pH_KCl), names_to = "pH_type", values_to = "pH_value")
p2 <- ggplot(data_long, aes(x = SOM_alkali, y = pH_value, color = pH_type)) +
  geom_point(size = 3) +
  geom_line(aes(group = Name), alpha = 0.5) +
labs(x = "SOM alkali", y = "pH value", color = "pH type", title = "Relationship between SOM alkali and pH values") +
  theme_minimal()
print(p2)

# 可視化3: USDA_SoilOrderをx軸、複数項目をy軸として比較（箱ひげ図＋facet）
vars1 <- c("deltapH", "exH", "CEC_eff", "CEC_pot")
data_box1 <- pivot_longer(data, cols = all_of(vars1), names_to = "variable", values_to = "value")
p3_1 <- ggplot(data_box1, aes(x = factor(USDA_SoilOrder), y = value, fill = factor(USDA_SoilOrder))) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_jitter(width = 0.2, size = 1, alpha = 0.5) +
  facet_wrap(~variable, scales = "free_y") +
  labs(x = "USDA Soil Order", y = "Value", fill = "USDA Soil Order", title = "Comparison of deltapH, exH, CEC_eff, CEC_pot by USDA Soil Order") +
  theme_minimal()
print(p3_1)

vars2 <- c("CationSaturation", "ExCa", "ExMg", "ExK")
data_box2 <- pivot_longer(data, cols = all_of(vars2), names_to = "variable", values_to = "value")
p3_2 <- ggplot(data_box2, aes(x = factor(USDA_SoilOrder), y = value, fill = factor(USDA_SoilOrder))) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_jitter(width = 0.2, size = 1, alpha = 0.5) +
  facet_wrap(~variable, scales = "free_y") +
  labs(x = "USDA Soil Order", y = "Value", fill = "USDA Soil Order", title = "Comparison of CationSaturation, ExCa, ExMg, ExK by USDA Soil Order") +
  theme_minimal()
print(p3_2)

vars3 <- c("ExNa", "Pabsorption")
data_box3 <- pivot_longer(data, cols = all_of(vars3), names_to = "variable", values_to = "value")
p3_3 <- ggplot(data_box3, aes(x = factor(USDA_SoilOrder), y = value, fill = factor(USDA_SoilOrder))) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_jitter(width = 0.2, size = 1, alpha = 0.5) +
  facet_wrap(~variable, scales = "free_y") +
  labs(x = "USDA Soil Order", y = "Value", fill = "USDA Soil Order", title = "Comparison of ExNa, Pabsorption by USDA Soil Order") +
  theme_minimal()
print(p3_3)