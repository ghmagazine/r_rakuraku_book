# 10章 条件分岐による列の加工-----------------------

## 10.1 割引クーポンによってアイスクリームの値段を割引したい！-----------------------

#そのまま描くと分かりにくいが・・・
tribble(~a,~b,1,2,10,20)

#適切に改行すると、表の位置と同じ位置に値を関数の中で書ける。
tribble(
  ~a, ~b,
   1,  2,
  10, 20
)

# tribble関数を利用すると、「そのまま」入力できます
dat <- tribble(
  ~aji          , ~nedan, ~coupon, ~kosu,
  "バニラ"      ,    300, "あり" , 200  ,
  "バニラ"      ,    300, "なし" , 340  ,
  "ストロベリー",    350, "あり" , 320  ,
  "ストロベリー",    350, "なし" , 540  ,
  "チョコレート",    400, "あり" , 180  ,
  "チョコレート",    400, "なし" , 230  
)

dat

## 10.2 `if_else`関数の動作を理解しよう

#ロジカル、TRUEの場合、FALSEの場合のベクトルを作成
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

# NAがconditionに含まれている場合はデフォルトではNAが返る
if_else(c(T,F,NA), "□","■")

# missingを設定すると別のものに置き換えることができる
if_else(c(T,F,NA), "□","■", missing="--ないよ--")

# ただし、なぜかNAで置き換えようとするとエラーがでる。
if_else(c(T,F,NA), "□","■", NA)

# NAのtype
typeof(NA)

#特別なNA
typeof(NA_character_)
typeof(NA_real_)

#NAを設定したい場合
if_else(c(T,F,NA),"□","■",NA) #エラー
if_else(c(T,F,NA),"□","■",NA_character_) #OK

#missing以外にも設定できる
if_else(c(T,F,NA),1000,NA_real_,99999)

## 10.3 割引クーポンによってアイスクリームの値段を割引したい！（2）-----------------------

#10.1節で作成した表データdatを利用-----------------------

# if_elseとmutateを組み合わせて売上を計算する
dat %>% 
  mutate(
    t_or_f = coupon=="あり",
    uriage = if_else(condition = t_or_f,
                     true      = nedan * 0.9 * kosu,
                     false     = nedan * kosu)
  )

# if_elseとmutateを組み合わせて売上を計算する
dat %>% 
  mutate(uriage = if_else(coupon=="あり",
                          nedan * 0.9 * kosu,
                          nedan * kosu))

# クーポンの有無と味によって割引率が変わる売上を計算したい
dat %>% 
  mutate(
    waribiki = if_else(
      coupon == "なし",　1,
      if_else(aji=="バニラ",0.95,
              if_else(aji=="ストロベリー",0.90,
                      if_else(aji=="チョコレート",0.85,NA_real_))))
      
  )  %>% 
  mutate(
    uriage = nedan * kosu * waribiki
  )

# case_when関数で複数の条件で場合分けした結果を取得できる。
x <- c("cow","dog","pig","dog","cat")

case_when(
  x=="dog" ~ "ワン",
  x=="cat" ~ "ニャー",
  x=="cow" ~ "モー",
  TRUE     ~ "???"

case_when関数は、複数の、`<TRUE/FALSEとなる条件> ~ <結果>`という記述を入れた関数です。上の条件から順番に見ていき、一番最初にTRUEとなる条件の結果が帰ってきます。最後の条件を`TRUE`としておくと、すべての条件に該当しない場合に、必ず最後の結果となります。

この関数を利用して、アイスクリームの割引クーポンの処理を書いてみましょう。ここでも、まずmutate

# 割引クーポンの処理
dat %>% 
  mutate(
    waribiki = case_when(
      coupon == "なし"        ~1   ,
      aji    == "バニラ"      ~0.95,
      aji    == "ストロベリー"~0.90,
      aji    == "チョコレート"~0.85,
      TRUE                   ~NA_real_
    ),
    uriage = nedan * waribiki *kosu
  )
