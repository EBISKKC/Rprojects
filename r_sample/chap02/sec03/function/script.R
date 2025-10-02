# 処理だけを行う関数
show1 <- function() {
  print("Hello!")
}

show1()

# 引数を受け取る関数
show2 <- function(word1, word2) {
  print(word1)
  print(word2)
}

show2("Rの世界へ", "ようこそ！")

# 引数を受け取って戻り値を返す関数
taxin <- function(val) {
  tax_in <- val * 1.08
  return(tax_in)
}

tax_in <- taxin(100)

