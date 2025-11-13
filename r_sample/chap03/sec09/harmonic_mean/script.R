speed <- c(110, 90)             # 行きと帰りの速度
hm = length(speed)/sum(1/speed) # 2÷((1÷110)+(1÷90))の計算
cat("平均速度", hm, "km")       # 出力