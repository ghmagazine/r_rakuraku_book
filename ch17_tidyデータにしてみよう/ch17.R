# 17章 tidyデータにしてみよう

## 17.1 例1:出勤時刻に関するデータをTidyにしてみる

# kintai.xlsxのsheet1を読み込む
library(tidyverse)
library(lubridate)
library(readxl)

dat <- read_excel("kintai.xlsx",sheet = "sheet1")

dat

# fillで欠損を埋める
dat2 <- dat %>% 
  fill(nen, tuki, tenpo, staff_id)
dat2

# pivot_longerで列データを列にする
dat3 <- dat2 %>% 
  pivot_longer(cols = matches("\\d+"), names_to = "niti", values_to="time")
dat3

# mak_dateで日付を作成してselectで必要な列に絞り込む
dat4 <- dat3 %>% 
  mutate(hiduke = make_date(nen,tuki,niti)) %>% 
  select(hiduke, tenpo, staff_id, kintai, time)
dat4

# pivot_widerでkintai列を広げる
dat4 %>% 
  pivot_wider(id_cols=c(hiduke,tenpo,staff_id),
              names_from=kintai,
              values_from=time)

# pivot_widerの警告を検証するためのデータ
testdata <- tibble(
  id   = c(1,1,1,1,2,2,3,3),
  name = c(rep(c("s","e"),4)),
  val  = 1:8,
)

testdata

# 横に広げる
test1 <- testdata %>% 
  pivot_wider(id_cols=id, names_from=name,values_from=val)

test1

# リストコラムを作ってみる
obj_a <- tibble(a=1,b=1)
obj_b <- tibble(a=1:3,b=1:3,c=1:3)
obj_c <- c(1:3)

tibble(list_col = list(obj_a,obj_b,obj_c))

# values_fn=lengthとしてみる
testdata %>% 
  pivot_wider(id_cols=id, names_from=name,values_from=val,values_fn=length)

# pivot_widerでkintai列を広げた場合の重複箇所を調べる
dat4 %>% 
  pivot_wider(id_cols=c(hiduke,tenpo,staff_id),
              names_from=kintai,
              values_from=time,
              values_fn=length) %>% 
  filter(start > 1)

# dat4でhiduke列が欠損しているところを探す
dat4 %>% filter(is.na(hiduke))

# hidukeが欠損している場合のtimeの組み合わせを確認する
dat4 %>% filter(is.na(hiduke)) %>% count(hiduke, time)

# hidukeの欠損を処理してから横に広げる
dat5 <- dat4 %>%
  filter(!is.na(hiduke)) %>% 
  pivot_wider(id_cols=c(hiduke,tenpo,staff_id),
              names_from=kintai,
              values_from=time)

dat5

# startとend列の組み合わせを調べる
dat5 %>% count(start,end) %>% filter(is.na(start) | is.na(end))

# tidyにできたデータ
res <- dat5 %>% 
  filter(!is.na(start))
res

# kintai.xlsxをtidyデータにする
# データのインポート
dat <- read_excel("kintai.xlsx",sheet = "sheet1")

# tidyデータへの加工
dat %>% 
  fill(nen, tuki, tenpo, staff_id)%>% 
  pivot_longer(cols = matches("\\d+"), names_to = "niti", values_to="time") %>% 
  mutate(hiduke = make_date(nen,tuki,niti)) %>% 
  select(hiduke, tenpo, staff_id, kintai, time) %>% 
  filter(!is.na(hiduke)) %>% 
  pivot_wider(id_cols=c(hiduke,tenpo,staff_id),
              names_from=kintai,
              values_from=time) %>% 
  filter(!is.na(start))

## 17.2 例2:人気ランキングと価格の表をtidyにしてみる

# ranking.xlsxを読み込む
dat <- read_excel("ranking.xlsx")

dat

# 価格のデータだけ抜き出す
kakaku_data <- dat %>% 
  select(starts_with("今月"),`価格`) %>% 
  setNames(c("aji","kakaku"))

# 価格データを除外する
dat2 <- dat %>% 
  select(!`価格`)

dat2

# 縦持ちデータに変換する
dat3 <- dat2 %>% 
  rename(ranking = `ランキング`) %>% 
  pivot_longer(
    cols      = !ranking, 
    names_to  = "when", 
    values_to ="aji"
  )

dat3

# when列を「2021年12月1日などの日付型に変換」する
dat4 <- dat3 %>% 
  mutate(month_diff = if_else(
    str_detect(when,"今月"), 
    "0",
    str_extract(when,"\\d+(?=ヵ月)")
  )) %>% 
  mutate(month_diff = as.numeric(month_diff))

dat4

# month_diff列を利用して、目的の日付の列を作成する
kongetu <- make_date(2021,12,1)

dat5 <- dat4 %>% 
  mutate(hiduke = kongetu %m-% months(month_diff))

dat5

# 中間変数を削除して、並び順を整えれば完成
dat5 %>% 
  select(hiduke, ranking, aji) %>% 
  arrange(desc(hiduke), ranking)

# まとめ
# 読み込み
dat <- read_excel("ranking.xlsx")

# 価格データ
kakaku_data <- dat %>% 
  select(starts_with("今月"),`価格`) %>% 
  setNames(c("aji","kakaku"))

# ランキングデータ
ranking_data <- dat %>% 
  select(!`価格`) %>% 
  rename(ranking = `ランキング`) %>% 
  pivot_longer(
    cols      = !ranking, 
    names_to  = "when", 
    values_to ="aji"
  ) %>% 
  mutate(month_diff = if_else(
    str_detect(when,"今月"), 
    "0",
    str_extract(when,"\\d+(?=ヵ月)")
  )) %>% 
  mutate(month_diff = as.numeric(month_diff)) %>% 
  mutate(hiduke = make_date(2021,12,1) %m-% months(month_diff)) %>% 
  select(hiduke, ranking, aji) %>% 
  arrange(desc(hiduke), ranking)

kakaku_data

ranking_data

## 17.3 例3:販売個数データをTidyにしてみる

### 17.3.1 ファイル1つ分を処理してみる

# 読み込むファイル名を指定
file_name <- "hanbaikosu/2021年度A店舗.xlsx"

# ファイルを読み込む
dat <- readxl::read_excel(file_name)
dat

# 列データを縦に変換
dat2 <- dat %>% 
  pivot_longer(cols = !`味`, 
               names_to = c("sex","age"),
               names_sep = ":")

dat2               

# 年度列と店舗列をファイル名から作成
nendo <- str_extract(file_name,"\\d{4}(?=年度)")
tenpo <- str_extract(file_name,"(?<=年度).+(?=店舗)")

dat3 <- dat2 %>% 
  mutate(nendo = nendo, tenpo = tenpo) %>% 
  select(nendo, tenpo, everything())

# あるいは、並び替えるだけであれば、reloacate関数も利用できる
dat3 <- dat2 %>% 
  mutate(nendo = nendo, tenpo = tenpo) %>% 
  relocate(nendo, tenpo)

dat3

# 最後に、味列の列名を英語表記に
dat4 <- dat3 %>% 
  rename(aji = `味`)

dat4

# 読み込むファイル名を指定
file_name <- "hanbaikosu/2021年度A店舗.xlsx"

# 年度列と店舗列をファイル名から作成
nendo <- str_extract(file_name,"\\d{4}(?=年度)")
tenpo <- str_extract(file_name,"(?<=年度).+(?=店舗)")

# ファイルを読み込んでtidyにする
dat <- readxl::read_excel(file_name) %>% 
  pivot_longer(cols = !`味`, 
               names_to = c("sex","age"),
               names_sep = ":") %>% 
  mutate(nendo = nendo, tenpo = tenpo) %>% 
  select(nendo, tenpo, aji = `味`, everything())

### 17.3.2 関数作成の基本

# 三角形の面積を求める関数を作成する
menseki_sankaku <- function(teihen,takasa){
  menseki <- (teihen * takasa)/2
  return(menseki)
}

menseki_sankaku(3,4)

### 17.3.3 ファイルを処理する関数を作成してみる


tidy_hanbaikosu <- function(file_name){
  "17.3.1 の処理"
  return("処理の結果")
}

# Excelファイルをtidyにする関数を作成
library(tidyverse)
library(readxl)

tidy_hanbaikosu <- function(file_name){
  # 読み込むファイル名を指定
  # file_name <- "hanbaikosu/2021年度A店舗.xlsx"

  # 年度列と店舗列をファイル名から作成
  nendo <- str_extract(file_name,"\d{4}(?=年度)")
  tenpo <- str_extract(file_name,"(?<=年度).+(?=店舗)")
  
  # ファイルを読み込んでtidyにする
  dat <- read_excel(file_name) %>% 
    pivot_longer(cols = !`味`, 
                 names_to = c("sex","age"),
                 names_sep = ":") %>% 
    mutate(nendo = nendo, tenpo = tenpo) %>% 
    select(nendo, tenpo, aji = `味`, everything())
  
  return(dat)
}

#作成した関数を適応してみる
dat1 <- tidy_hanbaikosu("hanbaikosu/2021年度A店舗.xlsx")
dat2 <- tidy_hanbaikosu("hanbaikosu/2021年度B店舗.xlsx")
dat3 <- tidy_hanbaikosu("hanbaikosu/2021年度C店舗.xlsx")
dat4 <- tidy_hanbaikosu("hanbaikosu/2021年度D店舗.xlsx")
dat5 <- tidy_hanbaikosu("hanbaikosu/2021年度E店舗.xlsx")

# 5つのデータを結合する
kansei <- bind_rows(dat1,dat2,dat3,dat4,dat5)
kansei

# 集計例
kansei %>% group_by(age) %>% summarise(kosu_total = sum(value))
