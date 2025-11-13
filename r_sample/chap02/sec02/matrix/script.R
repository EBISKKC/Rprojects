vct1 <- c(1, 2, 3, 4, 5, 6)
vct2 <- c(10, 20, 30, 40, 50, 60)
vct3 <- c(100, 200, 300, 400, 500, 600)

mtx1 <- matrix(vct1)             # 行列を作成
mtx2 <- matrix(vct1, nrow=2)     # 2行の行列を作成
mtx3 <- matrix(vct1, ncol=2)     # 2列の行列を作成
mtx4 <- matrix(vct1, 2,2)        # 2(行)×2(列)の行列を作成
mtx5 <- matrix(vct1,
               nrow=2,           # 2行の行列
               byrow = TRUE)     # 値を行方向に並べる

mtx6 <- rbind(vct1, vct2, vct3)  # 3つのベクトルを行として連結する
colSums(mtx6)                    # 列の合計を求める
rowSums(mtx6)                    # 行の合計を求める
mtx7 <- cbind(vct1, vct2, vct3)  # 3つのベクトルを列として連結する
colSums(mtx7)                    # 列の合計を求める
rowSums(mtx7)                    # 行の合計を求める

mtx7[1,]   # 1行目を取り出す
mtx7[,1]   # 1列目を取り出す
mtx7[1,1]  # 1行目の1列目の値を取り出す
