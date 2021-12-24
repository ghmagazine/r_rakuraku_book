# 3章 エクセルファイルを取り込んでみよう-------------------------

## 3.1 ファイルの取り込みの位置づけ-------------------------

## 3.2 「パス」の概念について理解しよう-------------------------

## 3.3 ワーキングディレクトリの場所を確認、設定してみよう。-----------------------------------

# r_rakuraku_book/ch03_エクセルファイルをとりこんでみよう/path にある`path.Rproj`をダブルクリックしてプロジェクトを開いてください

# getwd():ワーキングディレクトリを確認する。
getwd()　# 注意:この実行結果は皆さんのPCの状況次第で全然違う結果となります

# getwd():ワーキングディレクトリを確認する。
getwd() # 注意:この実行結果は皆さんのPCの状況次第で全然違う結果となります

# setwdでワーキングディレクトリを設定可能です。
setwd("./important/files")
getwd()

#
getwd()

#「..」で上の階層に戻れる。
setwd("../..")
getwd()

## 3.4 「パス」を理解するのがなぜ大切なのか---------------------------------

## 3.5 エクセルファイルを読み込んでみよう------------------------------------

# この節では、配布データの`r_rakuraku_book/ch03_エクセルファイルをとりこんでみよう/readexcel`にある
# `path.Rproj`からRStudioを立ち上げた状態で解説を行います。このプロジェクトには`file/sample.xlsx`というファイルがあるだけです。

# sample.xlsxの読み込み。
# プロジェクトを起動したばかリだとパッケージが
# 読み込まれていないので、ここで使えるようにする。
library(readxl)

# readxl::read_excel()で読み込む。
# datという名前の変数に読み込んだデータを保存。
dat <- read_excel(path = "file/sample.xlsx")
dat

#売上シートの内容を読み込む
#1:
uriage <- read_excel(path="file/sample.xlsx",sheet="売上") 
#2
uriage <- read_excel("file/sample.xlsx","売上") 

uriage

#売上シートの内容を読み込む
#3:
uriage <- read_excel(path="file/sample.xlsx",sheet=2)

uriage

#rangeでシート内の読み込む範囲を指定できる。
uriage_a <- read_excel("file/sample.xlsx",sheet="売上",range="A3:G9")
uriage_b <- read_excel("file/sample.xlsx",sheet="売上",range="I3:O9")
uriage_a

#
uriage_b

## 3.6 tibbleを使ってもっと便利に確実に---------------------------------------

## 3.7 読み込み時の型の推定---------------------------------

# 配布データの`r_rakuraku_book\ch03_エクセルファイルをとりこんでみよう\parse`にある`parse.Rproj`からRStudioを立ち上げた状態で解説を行います

# parse.xlsxファイルを読み込む
library(readxl)
dat <- read_excel(path="parse.xlsx",)

# 998-1003行目を抜き出します。
# この書き方については本章「補足1」で解説しています。
dat[c(998:1003),]

# 型を正しく推定させる
dat1 <- read_excel("parse.xlsx", guess_max = 1001)

dat1[c(998:1003),]

# 型を推定しない
dat2 <- read_excel("parse.xlsx", col_types = "text")

dat2[c(998:1003),]

### 3.7.補足1 表の一部を抜き出すには？

#
library(readxl)
dat <- read_excel("parse.xlsx")

# 3列目のみを切り出す
dat[,3] # 同じ:　dat1[3] 

# 1列目、3列目を切り出す
dat[,c(1,3)] # 同じ: dat1[c(1,3)]

# 1行目を切り出す
dat[1,]

# 1-5行目を切り出す
dat[1:5,]

# 1-5行目、995-1001行目を切り出す
dat[c(1:5, 995:1001),]

## 3.8 エクセルファイル以外のデータを取り込んでみよう-----------------------------------

# この節のスクリプトが読み込むファイルは`r_rakuraku_book\ch03_エクセルファイルをとりこんでみよう/other_data.Rproj`にあるファイルを利用します。

### 3.8.1 テキスト形式のデータの取り込み--------------------------------

# readrパッケージがインストールされていなければ
install.packages("readr")
#でインストール

# read_csv関数でcsv形式のデータを読み込めます
library(readr)
dat <- read_csv("data.csv")
dat

# localeの設定で、文字化けを避けてデータを読み込めます。
dat <- read_csv("data.csv", locale = locale(encoding="shift-jis"))
dat

# col_typesで列毎に型を指定することができます。
dat <- read_csv("data.csv", locale = locale(encoding="shift-jis"), col_types = "ccd")
dat

# cols関数で.defaultを設定すると、全ての列に型を指定することができます
dat <- read_csv(
  "data.csv", 
  locale = locale(encoding="shift-jis"), 
  col_types = cols(.default="c")
)
dat

### 3.8.2 統計ソフトのデータの読み込み-----------------------------------

# havensパッケージがインストールされていなければインストール
install.packages("haven")

library(haven)

# havenパッケージに含まれているサンプルデータのパスを取得
path_stata <- system.file("examples", "iris.dta", package = "haven")
path_spss <- system.file("examples", "iris.sav", package = "haven")
path_sas <- system.file("examples", "iris.sas7bdat", package = "haven")

#サンプルのiris.dtaファイルを読み込む
dat_stata <- read_stata(path_stata)
dat_spss <- read_spss(path_spss)
dat_sas <- read_sas(path_sas)

### 3.8.3 その他のデータソース--------------------------------------------
