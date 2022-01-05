# 3章 Excelファイルのインポート-------------------------

## 3.1 インポートとは-----------------------------------

## 3.2 パスとは----------------------------------------

## 3.3 ワーキングディレクトリを確認・設定しよう----------

# r_rakuraku_book/ch03_エクセルファイルをとりこんでみよう/path にある`path.Rproj`をダブルクリックしてプロジェクトを開いてください

# ワーキングディレクトリを確認する
getwd() # 注意:この実行結果は皆さんのPCの状況次第で全然違う結果となります

# setwdでワーキングディレクトリを設定可能
setwd("./important/files")
getwd()

#
getwd()

#「..」で上の階層に戻れる。
setwd("../..")
getwd()

## 3.4 パスがなぜ重要なのか理解しよう------------------------------------

## 3.5 Excelファイルを実際に読み込もう------------------------------------

# sample.xlsxの読み込み
# プロジェクトを起動したばかリだとパッケージが
# 読み込まれていないので、ここで使えるようにする
library(readxl)

# readxl::read_excel()で読み込む。
# datという名前の変数に読み込んだデータを保存。
dat <- read_excel(path = "file/sample.xlsx")
dat

# 売上シートの内容を読み込む
# 1:
uriage <- read_excel(path="file/sample.xlsx",sheet="売上") 
# 2
uriage <- read_excel("file/sample.xlsx","売上") 

uriage

# 売上シートの内容を読み込む
# 3:
uriage <- read_excel(path="file/sample.xlsx",sheet=2)

uriage

# rangeでシート内の読み込む範囲を指定できる。
uriage_a <- read_excel("file/sample.xlsx",sheet="売上",range="A3:G9")
uriage_b <- read_excel("file/sample.xlsx",sheet="売上",range="I3:O9")
uriage_a

#
uriage_b

## 3.6 tibbleについて理解しよう---------------------------------------

## 3.7 読み込むファイルの型を推定しよう---------------------------------

# parse.xlsxファイルを読み込む
library(readxl)
dat <- read_excel(path="parse.xlsx",)

# 998-1,003行目を抜き出す
# この書き方については3.7.1項で解説
dat[c(998:1003),]

# 型を正しく推定させる
dat1 <- read_excel("parse.xlsx", guess_max = 1001)

dat1[c(998:1003),]

# 型を推定しない
dat2 <- read_excel("parse.xlsx", col_types = "text")

dat2[c(998:1003),]

### 3.7.1 表の一部を抜き出そう--------------------------

#
library(readxl)
dat <- read_excel("parse.xlsx")

# 3列目のみを切り出す
dat[,3]

# 1列目、3列目を切り出す
dat[,c(1,3)] 

# 1行目を切り出す
dat[1,]

# 1〜5行目を切り出す
dat[1:5,]

# 1〜5行目、995〜1,001行目を切り出す
dat[c(1:5, 995:1001),]

## 3.8 Excelファイル以外のデータを取り込もう-----------------------------------

### 3.8.1 テキスト形式のデータの取り込み--------------------------------

# readrパッケージがインストールされていなければ
# install.packages("readr")でインストール

# read_csv()でCSV形式のデータを読み込む
library(readr)
dat <- read_csv("data.csv")
dat

# localeの設定で文字化けを避けてデータを読み込む
dat <- read_csv("data.csv", locale = locale(encoding="shift-jis"))
dat

# col_typesで列ごとに型を指定
dat <- read_csv("data.csv", locale = locale(encoding="shift-jis"), col_types = "ccd")
dat

# cols()で.defaultを設定すると、すべての列に型を指定できる
dat <- read_csv(
  "data.csv", 
  locale = locale(encoding="shift-jis"), 
  col_types = cols(.default="c")
)
dat

### 3.8.2 統計ソフトのデータの読み込み-----------------------------------

# havensパッケージがインストールされていなければインストール
# install.packages("haven")
install.packages("haven")

library(haven)

# havenパッケージに含まれているサンプルデータのパスを取得
path_stata <- system.file("examples", "iris.dta", package = "haven")
path_spss <- system.file("examples", "iris.sav", package = "haven")
path_sas <- system.file("examples", "iris.sas7bdat", package = "haven")

#サンプルファイルを読み込む
dat_stata <- read_stata(path_stata)
dat_spss <- read_spss(path_spss)
dat_sas <- read_sas(path_sas)
