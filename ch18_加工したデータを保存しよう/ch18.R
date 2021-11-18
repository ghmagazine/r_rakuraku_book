# 18章 データを保存しよう-----------------------------

## 18.1 データの保存が必要な状況-----------------------------

# 次の節以降で利用するオブジェクト
library(tidyverse)
hyou1 <- tibble(v1=c(1,1,1),v2="a")
hyou2 <- tibble(v1=c(2,2,2),v2="b")
atai1 <- 1
atai2 <- 2

## 18.2 表データをファイルとして保存する-----------------------------

## 18.2.1 CSVファイルで保存してみる-----------------------------

# csv形式で保存してみる
write_csv(hyou1,"しーえすぶいで保存.csv")

## 18.2.2 Excelファイルで保存してみる

# openxlsxのインストール
install.packages("openxlsx")

# openxlsxでExcelファイルを保存してみる
library(openxlsx)

newbook <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb=newbook, sheetName = "作ったシート")
openxlsx::writeData(wb=newbook, sheet="作ったシート", x = hyou2)
openxlsx::saveWorkbook(wb=newbook, file="hyou2のエクセル.xlsx", overwrite=TRUE)

# Excelファイルで保存する
write.xlsx(x=hyou1, path="関数から保存したエクセル.xlsx", overwrite=TRUE)

## 18.3 rds形式での保存-----------------------------

# rds形式で保存する
write_rds(hyou1, file="rds形式で保存.rds")

# rds形式を読み込む
yonda <- read_rds("rds形式で保存.rds")
yonda

# listオブジェクトで複数のオブジェクトをまとめてRdsで保存
kore_wo_hozon <- list(h1 = hyou1, h2 = hyou2, v1=atai1,v2=atai2)
write_rds(kore_wo_hozon, "リストを保存.rds")

# rdsファイルを読み込む
yonda <- read_rds("リストを保存.rds")

yonda$h1
yonda$h2
yonda$v1
yonda$v2

# 少し容量が大きいデータを作成して保存
dat <- tibble(x=1:100000,
              y=rep(c("バニラアイスクリーム","チョコレートアイスクリーム"),50000))
write_rds(dat,"非圧縮.rds") #3.3MB
write_rds(dat,"圧縮.rds", compress = "gz") #217kb


## 18.4 `.RData`形式での保存-----------------------------
