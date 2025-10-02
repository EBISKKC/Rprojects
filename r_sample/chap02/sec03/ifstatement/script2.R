num <- 10

if(num < 0) {        # numは負の値であるか
  num <- num * -1    # -1を掛けて正の値にする
} else if(num > 0) { # numは正の値であるか
  num <- num * -1    # -1を掛けて負の値にする
}
