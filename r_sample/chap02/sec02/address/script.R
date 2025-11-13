# 顧客id
id   <- c(1:3)
# 名前
name <- list("秀和太郎",
             "築地花子",
             "宗田解析")
# 住所
add  <- list("中央区築地100-1",
             "中央区築地本町200",
             "中央区日本橋99")

# リストを作成
add_book <- list("顧客リスト", id, name, add)

list1 <- add_book[[1]] # リストの第1要素を取得
list2 <- add_book[[2]] # リストの第2要素を取得
list3 <- add_book[[3]] # リストの第3要素を取得
list4 <- add_book[[4]] # リストの第4要素を取得

cst1_id   <- add_book[[2]][[1]] # 一人目のid
cst1_name <- add_book[[3]][[1]] # 一人目の名前
cst1_add  <- add_book[[4]][[1]] # 一人目の住所

var1  <- add_book[c(1,2)]       # リストの第1、第2要素をリストとして取得
var2　<- unlist(add_book[3])    # リストをベクトルに変換して取得


add_book[[3]][[1]] <-"築地太郎" # リスト第3要素→サブリスト第1要素を変更
add_book[[3]][[1]] <- NULL      # リスト第3要素→サブリスト第1要素を削除
add_book[[3]]      <- NULL      # リストの第3要素を削除

