num <- "-10"

if(is.numeric(num) & num < 0){            # numは実数型かつ負の値であるか
    num <- num * -1                       # -1を掛けて正の値にする
  } else if (is.numeric(num) & num > 0) { # numは実数型かつ正の値であるか
    num <- num * -1                       # -1を掛けて負の値にする
  } else {                                # どの条件も成立しない場合 
    num <- as.numeric(num)                # numeric型に変換する
}


