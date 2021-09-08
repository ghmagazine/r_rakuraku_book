# 16章 日付・時刻データの取り扱いと集計

## 16.1 日付・時刻型とは

# lubridateで日付・時刻型/データを取り扱える
library(lubridate)

# as_dateで数字を日付型に変換
as_date(0)

# classを確認
class(as_date(0))

# 1970年1月1日を起点として数字で日付を表す
as_date(-5)
as_date(5)
as_date(10000)

# 文字型にすると、その日付
as.character(as_date(0))

# 数字型にすると、起点からの日数
as.numeric(as_date(0))

# 文字型を日付に変換できる
as_date("2021-1-10")
as_date("2022/2/11")
as_date("2023年3月12日")

# 日付時刻型データを作るにはas_datetime
as_datetime(0)
as_datetime(1)
as_datetime(1 + 24*60*60)

# 文字で日付時刻型データを作成することも可能
val <- as_datetime("2021-3-3 15:30:12")
val

# 数字に戻す
as.numeric(val)

## 16.2 文字型や数字型を日付・時間型に変換してみる

### 16.2.1 文字の日付、時刻型への変換の応用

# as_dateがうまくいかないケース
as_date("4月3日(2021年)")

# lubridateの他の関数を利用して変換してみる
mdy("4月3日(2021年)")

# lubridateの他の関数を利用して変換してみる
mdy_hms("4月3日(2021年) 13:21:10")
mdy_hm("4月3日(2021年) 13:21")
mdy_h("4月3日(2021年) 13時")

# 表を作成する
dat <- tibble(vec1 = c("4/3(2021)","10/23(2021)","11/13(2021)"),
              vec2 = c("4/3(2021) 12:21","10/23(2021) 13:32","11/13(2021) 9:02") )
        
# 表の中で日付、日付時刻型の列を作成する
dat %>% 
  mutate(hiduke = mdy(vec1),
         hiduke_jikoku = mdy_hm(vec2))

### 16.2.2 数字の日付、時刻型への変換の応用

# 数字から日付型を作成してみる
make_date(year = 2021, month = 12, day = 25)

# 数字から日付時刻型を作成してみる
make_datetime(year = 2021, month = 12, day = 25, hour = 13, min = 12, sec = 12)

# 数字で時刻や日付が保存されている表を作成する
dat <- tibble(
  nen = c(2011,2012,2013), tuki = c(11,12,10), hi   = c(24,25,23),
  ji  = c(9,10,8)        , hun  = c(32,45,51), byou = c(0,1,2)
)

# make_date, make_datetime関数を利用して日付型・日付時刻型を作成する
dat %>% 
  mutate(
    hiduke        = make_date    (nen,tuki,hi            ),
    hiduke_jikoku = make_datetime(nen,tuki,hi,ji,hun,byou)
  )

## 16.3 タイムゾーン

# 日付時刻型を作成
as_datetime("2021-12-25 9:00:00")

# 日本時間（JTS）の日付時刻型の値を作成する
val_japan <- as_datetime("2021-12-25 9:00:00", tz="Japan")
val_japan

# あるいはAsia/TokyoでもOK
val_japan <- as_datetime("2021-12-25 9:00:00", tz="Asia/Tokyo")
val_japan

# タイムゾーンを変更する(時間も変換)
with_tz(val_japan, "Pacific/Honolulu")

# タイムゾーンを変更する(時間は固定)
force_tz(val_japan, "Pacific/Honolulu")

## 16.4 日付・時刻の計算をやってみよう

### 16.4.1 引き算での計算

# 日付型の値を2つ作る
d1 <- make_date(2021,5,10)
d2 <- make_date(2021,5,1)

# 引き算してみる
d1 - d2

# 引き算以外の四則演算を試してみる
d1 + d2
d1 * d2
d1 / d2

# 時刻を作成
t1 <- as_datetime(0) #原点
t2 <- as_datetime(2) #1秒後
t3 <- as_datetime(65) #1分5秒後
t4 <- as_datetime(3605) # 1時間5秒後
t5 <- as_datetime((3600*24)+5) #24時間と5秒後
t6 <- as_datetime(366*((3600*24))+5) # 366日と5秒後

# 引き算した結果を保存
min21 <- t2-t1
min31 <- t3-t1
min41 <- t4-t1
min51 <- t5-t1
min61 <- t6-t1

# それぞれ実行して確認（;で区切ると複数行を1行にまとめて記載できる）
min21; min31; min41; min51; min61

# 比較してみる
min21 > min41 # FALSEで正解
as.numeric(min21) > as.numeric(min41) 

# ベクトルに入れれば、「差」は秒で統一される。
c(min21,min31,min41) %>% as.numeric()

### 16.4.2 物理的な時間の経過を`Duration`で表してみる

# 引き算で時間差を作成してみる
minus <- as_datetime(1000) - as_datetime(0)
minus

# as.durationで引き算の時間差をdurationに変更する
dur <- as.duration(minus)
dur

# classを確認する
class(minus)
class(dur)

# as.numericで変換する
as.numeric(minus)
as.numeric(dur)

# 日付型の引き算結果をdurationにしてみる
dur2 <- as.duration(make_date(2021,10,30) - make_date(2021,10,25))
dur2

# as.numericで確認する
as.numeric(dur2)

# いろいろな時間経過を求めてみる
d1 <- make_datetime(2021,10,1,13,0,0)
d1

# 1年後
d1 + dyears(1)

# 1ヵ月後（*注!）
d1 + dmonths(1)

# 1日後
d1 + ddays(1)

# 1時間後
d1 + dhours(1)

# 1分後
d1 + dminutes(1)

# 1秒後
d1 + dseconds(1)

# dmonths(1)の秒数:
dmonths(1)

# 365.25日の12分割した場合の秒数:
(365.25 * 24 * 60 * 60)/12

### 16.4.3 カレンダー上の時間の経過を`period`で表してみる

# 日付時刻を作る
d2 <- make_datetime(2021,1,10,13,0,0)
d2

# 1年後
d2 + years(1)

# 1ヵ月後
d2 + months(1)

# 1日後
d2 + days(1)

# 1時間後
d2 + hours(1)

# 1分後
d2 + minutes(1)

# 1秒後
d2 + seconds(1)

# クラスを確認する
class(months(1))

# 2020年2月29日（うるう年）の1年後の日付
make_date(2020,2,29) + years(1)

# 2021年1月29日の1ヵ月後の日付
make_date(2021,1,29) + months(1)

# 2021年1月31日の月の値に1から12を足してみる（値+ベクトル）
make_date(2021,1,31) + months(1:12)

# 2021年1月31日の月の値に1から12を%m+%で足してみる
make_date(2021,1,31) %m+% months(1:12)

# 2021年1月31日の月の値に1から12を引いてみる（値ーベクトル）
make_date(2021,1,31) - months(1:12)

# 2021年1月31日の月の値に1から12を%m-%で引いてみる
make_date(2021,1,31) %m-% months(1:12)

### 16.4.4 「時間の帯」同士の重なりの有無を`Interval`で調べよう

# 時刻の帯、その1を作成する
t1_1 <- make_datetime(2021,1,1,12,0,0)
t1_2 <- make_datetime(2021,1,1,13,0,0)
obi1 <- interval(t1_1, t1_2)

# 帯その2を作成する
obi2 <- interval(ymd_h("2021-1-1  9"),
                 ymd_h("2021-1-1 10"))

# 帯その3を作成する、%--%という書き方でもOK
obi3 <- ymd_hm("2021-1-1 11:45") %--% ymd_hm("2021-1-1 12:30")

obi1
obi2
obi3

# int_overlapsでIntervaleオブジェクト同士が重複しているかを確認する
int_overlaps(obi1, obi2)
int_overlaps(obi1, obi3)

# int_lengthでIntervalオブジェクトの長さを調べられる
int_length(obi1)
int_length(obi3)

# 時刻を作成
point_time <- ymd_hms("2021-1-1 12:15:00")

# obi1-oibi3の中にpoint_timeが含まれるかを調べる
point_time %within% obi1
point_time %within% obi2
point_time %within% obi3

## 16.5 時間の集計をやってみよう

# データの作成
april1 <- ymd_h("2021-4-1 9")
hyou <- tibble(
  person = "A",
  start = april1 + days(c(0,1,2,3,4,7,8,9,10,13)),
  end   = start + minutes(60*c(5   , 5.5, 6, 5.5 , 7, 
                          7.25, 6.5, 7, 3.25, 5.3)))


hyou

# まず値で計算方法を確認してみる
tend <- ymd_hm("2021-4-1 17:00")
tstart <- ymd_hm("2021-4-1 13:30")

# Durationを利用する場合
as.numeric(as.duration(tend-tstart))/3600

# Intervalを利用する場合
int_length(tstart %--% tend)/3600

# 1日あたりの給与額を計算する
hyou %>% 
  mutate(work_hour = int_length(start %--% end)/3600) %>% 
  mutate(pay_per_day = 1020 * work_hour) %>% 
  select(end,work_hour, pay_per_day)

# 月の給与額を計算する
hyou %>% 
  mutate(work_hour = int_length(start %--% end)/3600) %>% 
  mutate(pay_per_day = 1020 * work_hour) %>% 
  select(end,work_hour, pay_per_day) %>% 
  summarise(pay = sum(pay_per_day))

