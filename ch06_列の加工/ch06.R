# 6章 列の加工-----------------------------

## 6.1 関数と関数をつなごう-----------------------------

# 目玉焼きの作成手順の架空のスクリプト
YOU <- "あなた"
step1 <- フライパンを温める(YOU)
step2 <- 油を引く(step1)
step3 <- 卵を入れる(step2)
step4 <- 水を入れる(step3)
step5 <- ふたを閉める(step4)
DEKIAGARI <- 待つ_5分(step5)
DEKIAGARI

# 目玉焼きの作成手順の架空のスクリプト（中間変数を利用せず、複数行で記載する場合）
DEKIAGARI <-
  待つ_5分(
    ふたを閉める(
      水を入れる(
        卵を入れる(
          油を引く(
            フライパンを温める(
            YOU
            )
          )
        )
      )
    )
  )

# 目玉焼きの作成手順の架空のスクリプト（パイプ関数を利用する場合）
DEKIAGARI <- YOU %>%
  フライパンを温める() %>%
  油を引く() %>%
  卵を入れる() %>%
  水を入れる() %>%
  ふたを閉める() %>%
  待つ_5分()

# paste()で文字をつなげる
paste("犬が","わんわんとなく")


# パイプ関数はctrl+shift+mを押すことで挿入することができる
# （macOSではcommand+shift+m）
# パイプが送り込む先は「最初の引数」
"犬が" %>% paste("わんわんとなく")
# paste("犬が","わんわんとなく")と同じ処理


# 送り込む先の位置を変更したいときは「.」（ピリオド）で変更
"犬が" %>% paste("わんわんとなく", .)
# paste("わんわんとなく","犬が")と同じ処理

# ピリオドの位置を変更してみる
"犬が" %>% paste(., "わんわんとなく")


# 「.」は複数回利用してもOK
"わん" %>% paste("犬が",. ,.)
# paste("犬が","わん","わん")と同じ処理


# ¦>で、Rの基本機能としてのパイプ関数が利用できる
"犬が"¦> paste("わんわん")

## 6.2 列を追加しよう-----------------------------

#
library(tidyverse)

dat <- tibble(
  menu     = c("Aコース", "Bコース", "Cコース", "Dコース"),
  nedan    = c(900, 1600, 2100, 3500),
  ticket   = c(10, 15, 20, 25) 
)

dat

# dplyr::mutateで列を新たに追加できる
dat %>% 
  mutate(final_nedan = nedan * (100 - ticket)/100 )

# ただし、保存しないと作成した列は反映されない
dat

# 処理した結果を代入することで上書きできる
dat <- dat %>% mutate(final_nedan = nedan * (100-ticket)/100)
dat

# mutateを使わない場合の変数の作成
dat$final_nedan_kako <- dat$nedan * (100 - dat$ticket)/100

dat

# mutateは、長さ1のベクトルでもOK
dat %>% mutate(test = "長さ1")

# 長さが違うとエラー
dat %>% mutate(test = c("1","2"))

# 消費税10%を入れて、メニュー表に載せる文字のようなものを作成してみる
dat <- dat %>% 
  mutate(label = paste0(menu," ", nedan, "円 (税込み:", nedan*1.10,"円)"))

dat$label

## 6.3 列名を変更しよう-----------------------------

# データを作成
dat <- tibble(
  col1 = c(1:5),
  col2 = c(6:10)
)

dat

# rename()を利用して、col2をnewに変更
dat2 <- dat %>% 
  rename(new = col2)

dat2

# 複数同時に名前を変更することも可能
# col1をnew1、col2をnew2という名前へ
dat2 <- dat %>% 
  rename(
    new1 = col1,
    new2 = col2
  )

dat2

# baseで変数名を変更する場合
names(dat)[names(dat)=="col2"] <- "new"

dat

# baseで名前を変更する場合の詳細
# names(dat)で列名を文字列ベクトルとして取り出せる
colnam <- names(dat)
colnam

# colnamのnewという変数名の位置を返すロジカルベクトルを作成
colnam == "new"

# ベクトルにロジカルベクトルを[]で指定すると、その値を取り出せる
colnam[colnam=="new"]

#
names(dat)[names(dat)=="new"]

#
names(dat)[names(dat)=="new"] <- "newnew"
dat

#
new_column_name <- c("new1","new2")
dat2 <- dat %>% setNames(new_column_name)
dat2

## 6.4 列を選択しよう-----------------------------

# この節で利用するデータ
dat <- tibble(
  a1 = c( 1: 3), a2 = c( 4: 6), a3 = c( 7: 9),
  b1 = c(11:13), b2 = c(14:16), b3 = c(17:19),
  c1 = c(21:23), c2 = c(24:26), c3 = c(27:29),
  d1 = c(31:33), d2 = c(34:36), d3 = c(37:39)
)

dat

# a3列を取り出して新しい表を作る
dat2 <- dat %>% select(a3)
dat2

# 複数列を取り出す
dat3 <- dat %>% select(a1, a3, b2)
dat3

# :で並んでいる順番で列を取り出すことも可能
dat4 <- dat %>% select(c1:d2)
dat4

# !で除外
dat5 <- dat %>% select(!a1)
dat5

# !を複数列に適応するにはc()で囲む
dat6 <- dat %>% select(!c(a1,a2,b1,b2,c1,c2))
dat6

# everything()で全部指定
dat7 <- dat %>% select(everything())
dat7

# everything()はうまく利用すると列の並び替えに使える
dat8 <- dat %>% select(d3,d2,d1, everything())
dat8

# relocate()とselect(… , everything())での並び替えは同じ結果になる
dat9 <- dat %>% relocate(d3,d2,d1)
dat9

# starts_with()で特定の文字で始まる列を取得
dat10 <- dat %>% select(starts_with("c"))
dat10

#ends_with()で特定の文字で終わる列を取得
dat11 <- dat %>% select(ends_with("2"))
dat11

#　selectしながらrenameもできる
#（ここからは、表を代入して表示する書き方はしない）
dat %>% 
  select(new1 = a1, new2 = b1, new3 = c1, new4 = d1)

#
dat[c("a1","c3")]