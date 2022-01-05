# 7章 行の加工-------------------

本章では表の行方向の加工について解説していきます。

## 7.1 行を並び替えよう-------------------

# 表を作る
dat <- tibble(
　col1 = c(1,3,2,2,1,3),
  col2 = c(1,2,3,4,5,6) 
)

dat

# arrangeで行を昇順に並び替えられる
dat %>% arrange(col1)

# descを利用すると降順で並び替えられる
dat %>% arrange( desc(col1) )

# 表その2を作成
dat <- tibble(
  col1 = c(1,2,1,1,2,2),
  col2 = c(2,3,1,3,1,2)
)

# 複数列を指定して並び替える
dat %>% arrange(col1, col2)
dat %>% arrange(col2, col1)

# 昇順と降順を混ぜてもOK
dat %>% arrange(      col1 ,      col2 ) #1
dat %>% arrange( desc(col1),      col2 ) #2
dat %>% arrange(      col1 , desc(col2)) #3
dat %>% arrange( desc(col1), desc(col2)) #4

# 文字の並び替え
dat <- tibble(alpha = c("a","c","b","e","d"))
dat %>% arrange(dat)

# baseで並び替えるにはorder関数を利用
dat <- tibble(col1 = c(1,3,4,2,5), col2 = c(1,3,2,5,4))
dat[order(dat$col2), ]

## 7.2 ロジカル型を理解しよう-------------------

### 7.2.1 ロジカル型とは-------------------

# ロジカル型のTRUE
TRUE
T
typeof(TRUE)

# ロジカル型のFALSE
FALSE
F
typeof(FALSE)

# ロジカル型のTRUEは数字の1と同様に計算できる
T + T + T

# FALSEを足しても変化しない
T + T + T + F

# as.numericで数字に変換
as.numeric(T)
as.numeric(F)

# as.characterで文字に変換
as.character(TRUE)
as.character(FALSE)

# ロジカル型に変換するにはas.logical
as.logical(0)
as.logical(1)
as.logical("T")
as.logical("TRUE")
as.logical("F")
as.logical("FALSE")

# 数字は0のみFALSE、0以外は全部TRUE
as.logical(c(-0.1, 0, 0.5, 2))

# 文字列は変換できない場合はNAで欠損
as.logical("Dog")

### 7.2.2 ロジカル型で印をつけよう-------------------

# == 記号は左右の要素の値が等しいか等しくないかをロジカル型で返してくれる。
2 == 2

# 1から5までの数字ベクトル(1:5)をvecに代入
vec <- 1:5

# ==で、2の位置に印をつける
vec == 2

# ベクトル < 数字 と書いた場合
vec <- 1:5 #c(1,2,3,4,5)と同じ
vec <  3  

# 文字にも印をつけることができる
moji <- c("a","b","c","d","e")
moji == "c" 
moji != "c"

# %in%演算子
moji %in% c("b","d") 

### 7.2.3 印をつけたものを取り出そう-------------------

# ロジカル型のベクトルを利用してベクトルから要素を取り出す
vec <- 1:5 
vec[c(T,F,T,F,T)]

# 長さ5[長さ1]
vec[c(T)]

# 長さ5[長さ2]
vec[c(T,F)]
#   T F T F T F …
#   1 2 3 4 5

# 長さが1以外のときは、c()でベクトルにしよう。
vec[T,F,T]

### 7.2.4 ロジカル型のTRUE、FALSEを!でひっくり返そう-------------------

# !でTRUE、FALSEをひっくり返せる
!c(T,F,T)

# ベクトルを作成
vec <- c("a","b","c","d","e","f","e","a","g")
vec

# aとeのみを取り出す
vec[vec %in% c("a","e")]

# []の中の条件のロジカルベクトル
jyouken <- vec %in% c("a","e")
jyouken

# jyoukenが「TRUEでない」ものを取り出したい
vec[!jyouken]

# vec %in% c("a","e") でないものを取り出したい
vec[ !vec %in% c("a","e")]

## 7.3 行を絞り込もう-------------------

# 表の作成
dat <- tibble(
  item = c("a","b","c","d","e","f"),
  kosu = c(11,26,5,80,10,20)
)

dat

## kosuが25以上の行を絞り込む。
# 取り出したいベクトル
dat$kosu

# kosuが25以上という条件のロジカルベクトル
dat$kosu >= 25

# 表で行を抽出するには<hyou>[<ロジカルベクトル>, ]
dat[dat$kosu >= 25, ]

# dplyrで表の抽出
dat %>% filter(kosu >= 25)

# item列でbとcを含む行のみを抽出
dat %>% filter(item %in% c("b","c"))

# bを含まない行のみの抽出
dat %>% filter(item !=  c("b"))