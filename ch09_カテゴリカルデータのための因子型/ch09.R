# 9章 カテゴリカルデータのための因子型

## 9.1 アンケートのデータを集計しよう----------------------------

## 9.2 架空のアンケートデータを作成しよう-------------------------------

## 9.2.1 ランダムな数字を生成しよう-----------------------------

# nでランダムに作成する数字の個数、
# minとmaxで数字が出現する範囲を指定する
runif(n = 20, min = 0, max = 100)

# set.seed()を同時に実行することで、ランダムな結果を固定できる
set.seed(12345)
runif(5,0,10)

set.seed(12345)
runif(5,0,10)

## 9.2.2 くじ引きをやってみよう-----------------------------

# tidyverseを使えるようにする。
library(tidyverse)

# set.seedで「ランダムさ」を固定できる。
set.seed(12345)

# sample()のprob引数の動作を確認してみる。
# prob引数を設定しないで、ジャンケンを300回やった場合
no_prob <- sample(
  x = c("グー","チョキ","パー"),
  size = 300,
  replace = TRUE
)

# グーが50%、チョキが30%、パーが20%の場合
with_prob <- sample(
  x=c("グー","チョキ","パー"),
  size=300,
  replace=TRUE,
  prob = c(0.5, 0.3, 0.2)
)

# それぞれのsample関数の結果を確認（最初の10回ずつ）
no_prob[1:10]
with_prob[1:10]

# table()で文字ベクトルのそれぞれの要素の出現回数を調べる。
table(no_prob)
table(with_prob)

# replace = FALSEとした場合のsample()の動作
try1 <- sample(x=c(1:10),size=10,replace=FALSE)
try2 <- sample(x=c(1:10),size=10,replace=FALSE)
try3 <- sample(x=c(1:10),size=10,replace=FALSE)

table(try1)
table(try2)
table(try3)

## 9.2.3 ランダムな表データを作成しよう----------------------------------

# 架空のアンケート調査の結果を作成
set.seed(12345)
dat <- tibble(
  q1 = sample(c("バニラ","チョコ","いちご"), 10, TRUE),
  q2 = sample(c("-19","20-39","40-59","60-"), 10, TRUE),
  q3 = sample(1:3, 10, TRUE)
)

dat

## 9.3 因子型とは---------------------------------

# q1でバニラと答えた人がいない場合のデータ
no_van <- dat %>% filter(q1 != "バニラ")

# 集計
dat$q1 %>% table()
no_van$q1 %>% table()

# ベクトルを作る
vec <- c("バニラ","チョコ","いちご","バニラ","チョコ")

# as.factor()で因子型を作成
fvec <- as.factor(vec)
fvec

# 因子型ベクトル
fvec

# 因子型を文字型に変換
as.character(fvec)

# 因子型を数字型に変換
as.numeric(fvec)

# バニラ、チョコ、いちごが入るはずだが、
# 「いちご」が含まれていないベクトル
vec <- c("バニラ","チョコ","バニラ","チョコ","チョコ")

# as.factorで因子型を作成（いちごは含まれない）
as_fvec <- as.factor(vec)
as_fvec

# factorで因子型を作成（levelsでいちごを含めて作成）
f_fvec <- factor(vec, levels=c("バニラ","チョコ","いちご"))
f_fvec

# tableで集計してみる
table(as_fvec)
table(f_fvec)

# アンケートで男が1、女が2のつもりのベクトル
vec <- c(1,1,2,2,1,2,1)

# 因子型にlabelsを利用しないで変換
no_label <- factor(vec,levels=c(1,2))
no_label

# 因子型にlabelsを利用して変換
with_label <- factor(vec,levels=c(1,2),labels=c("男","女"))
with_label

# labels引数を利用して集計
table(no_label)
table(with_label)

## 9.4 因子型の列を作成しよう

# 架空のアンケートデータの作成（9.2.3の再掲）
set.seed(12345)
dat <- tibble(
  q1 = sample(c("バニラ","チョコ","いちご"), 10, TRUE),
  q2 = sample(c("-19","20-39","40-59","60-"), 10, TRUE),
  q3 = sample(1:3, 10, TRUE)
)

dat

# データのq1-q3列を因子型に変更する
dat <- dat %>% 

mutate(
  q1f = as.factor(q1),
  q2f = factor(x      = q2, 
               levels = c("-19","20-39","40-59","60-"),
               labels = c("-19歳","20-39歳","40-59歳","60歳-")),
  q3f = factor(x = q3,
               levels = c(1:3),
               labels = c("不満","普通","満足"))
  
)

# 変換した列を抜き出して確認
dat %>% select(ends_with("f"))

## 9.5 変数を利用した因子型の設定

# 変数で因子型のレベルやラベルを指定することも可能
# データを作成
dat2 <- tibble(
  q = sample(
    x = c("-5","6-10","11-15","16-20","21-25","26-30","31-35",
      "36-40","41-45","46-50","51-55","56-60", "61-"),
    size = 100,
    replace = TRUE
))

# levels引数を作成
# distinct()で列を「重複なし」にできる
dat_levels <- dat2 %>% distinct(q)
dat_levels

# arrange()で並べ替える
dat_levels <- dat_levels %>% 
  arrange(q)
dat_levels

# dat[c(行番号),]で行番号を並び替えることができる
dat_levels[c(1,12,2:11,13),]

# str_extractで最初の数字を抜き出して数字データをarrange()する作戦
dat_levels2 <- dat_levels %>% 
  mutate(init_num = str_extract(q,"\\d+(?=-)|(?<=-)5$"),
         init_num = as.numeric(init_num)) %>%
  arrange(init_num)

dat_levels2

#
vec_level <- dat_levels2 %>% pull(q)
vec_level

# dat2からq列をもとに、順番を整えたlevels引数に利用できるベクトルとして抜き出す
vec_level <- dat2 %>% 
  distinct(q) %>% 
  arrange(q) %>% 
  mutate(init_num = as.numeric(str_extract(q,"\\d+(?=-)|(?<=-)5$"))) %>% 
  arrange(init_num) %>% 
  pull(q)
vec_level

# tidyverseではない書き方の例(書籍未収録)
dat2$q |> 
  unique() |> 
  (\(x) x[order(x)])() |>
  (\(x) x[order(as.numeric(str_extract(x,"\\d+(?=-)|(?<=-)5$")))])()

# ラベルを設定するための文字ベクトルをvec_levelから作成する
vec_label <- vec_level %>% 
  str_replace("(-\\d+$)","\\1歳") %>% 
  str_replace("(-$)","歳\\1")

vec_label

# 因子型に変更する
dat2 <- dat2 %>% 
  mutate(q_fac = factor(x = q, levels = vec_level, labels = vec_label))

# 表の列を数えるにはcountを利用する
dat2 %>% count(q_fac)
