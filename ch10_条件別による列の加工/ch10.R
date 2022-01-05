# 10章 条件別による列の加工-----------------------

## 10.1 割引クーポンを使ってアイスクリームの値段を計算しよう①-------

# そのまま書くと分かりにくいが・・・
tribble(~a,~b,1,2,10,20)

# 適切に改行すると、表の位置と同じ位置に値を関数の中で書ける。
tribble(
  ~a, ~b,
   1,  2,
  10, 20
)

# tribble()を利用すると、「そのまま」入力できます
dat <- tribble(
  ~aji    , ~nedan, ~coupon, ~kosu,
  "バニラ",    300, "あり" , 200  ,
  "バニラ",    300, "なし" , 340  ,
  "いちご",    350, "あり" , 320  ,
  "いちご",    350, "なし" , 540  ,
  "チョコ",    400, "あり" , 180  ,
  "チョコ",    400, "なし" , 230  
)

dat

## 10.2 別の列の値に応じて列を加工する方法を確認しよう-------

#ロジカル型がTRUEの場合、FALSEの場合のベクトルを作成
logvec <- c(T,F,T,F,F)
t_vec <- c("□T1","□T2","□T3","□T4","□T5")
f_vec <- c("■F1","■F2","■F3","■F4","■F5")
  #*■、□は「しかく」と入力して変換すると変換できます

if_else(condition = logvec, true = t_vec, false = f_vec)

# true引数とfalse引数の値は単一の要素でもOK
if_else(logvec,"□TRUEだよ","■FALSEだよ")

#数字でもOK
if_else(logvec,1000,-1)

#true引数、false引数に違う型をまぜるとNG
if_else(logvec,"もじ",1)

# NAがcondition引数に含まれている場合はデフォルトではNAが返る
if_else(c(T,F,NA), "□","■")

# missing引数を設定すると別のものに置き換えることができる
if_else(c(T,F,NA), "□","■", missing="--ないよ--")

# ただし、なぜかNAで置き換えようとするとエラーがでる
if_else(c(T,F,NA), "□","■", NA)

#
typeof(NA)

#特別なNA
typeof(NA_character_)
typeof(NA_real_)

#NAを設定したい場合
if_else(c(T,F,NA),"□","■",NA) #エラー
if_else(c(T,F,NA),"□","■",NA_character_) #OK

#missing以外にも設定できる
if_else(c(T,F,NA),1000,NA_real_,99999)

## 10.3 割引クーポンを使ってアイスクリームの値段を計算しよう②------

# 10.1節で作成した表データdatを利用
# if_else()とmutate()を組み合わせて売上を計算する
dat %>% 
  mutate(
    t_or_f = coupon=="あり",
    uriage = if_else(condition = t_or_f,
                     true      = nedan * 0.9 * kosu,
                     false     = nedan * kosu)
  )

# if_else()とmutate()を組み合わせて売上を計算する
dat %>% 
  mutate(uriage = if_else(coupon=="あり",
                          nedan * 0.9 * kosu,
                          nedan * kosu))

## 10.4 もっと複雑な条件に応じて列を加工しよう----------

# クーポンの有無と味によって割引率が変わる売上を計算したい
dat %>% 
  mutate(
    waribiki = if_else(
      coupon == "なし",　1,
      if_else(aji=="バニラ",0.95,
              if_else(aji=="いちご",0.90,
                      if_else(aji=="チョコ",0.85,NA_real_))))
      
  )  %>% 
  mutate(
    uriage = nedan * kosu * waribiki
  )

# case_when()で複数の条件で場合分けした結果を取得できる
x <- c("cow","dog","pig","dog","cat")

case_when(
  x=="dog" ~ "ワン",
  x=="cat" ~ "ニャー",
  x=="cow" ~ "モー",
  TRUE     ~ "???"

# 割引クーポンの処理
dat %>% 
  mutate(
    waribiki = case_when(
      coupon == "なし"   ~ 1   ,
      aji    == "バニラ" ~ 0.95,
      aji    == "いちご" ~0.90 ,
      aji    == "チョコ" ~ 0.85,
      TRUE               ~ NA_real_
    ),
    uriage = nedan * waribiki *kosu
  )
