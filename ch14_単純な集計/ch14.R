# 14章 単純な集計---------------------------

## 14.1 平均・最小・最大を集計しよう---------------------------

#数字ベクトルを作成する
vec <- c(5,3,4,5,6,3,5,3,2,4)

#平均値をもとめる
mean(vec)

#最小値を求める
min(vec)

#最大値を求める
max(vec)

# 表データを作成する
dat <- tibble(vec = c(5,3,4,5,6,3,5,3,2,4))

# 集計結果をmutate()に入れてみる。
dat %>% 
  mutate(
    heikin  = mean(vec),
    minimum = min(vec),
    maximum = max(vec)
  )

## 14.2 表を集計しよう---------------------------

# 表データを作成する
dat <- tibble(vec = c(5,3,4,5,6,3,5,3,2,4))

dat %>% 
  summarise(
    heikin  = mean(vec),
    minimum = min(vec),
    maximum = max(vec)
  )

## 14.3 文字型（因子型）を集計しよう---------------------------

# 文字ベクトルを作成
vec <- c("女","女","男","女","男","女","女","男","女","女")

#「男」の数を集計
vec == "男"

# sum()を利用
sum(vec=="男")

#「女」の数を集計
sum(vec=="女")

# ベクトルの長さ（件数）を集計
length(vec)

# 「男」の割合を計算する
sum(vec=="男")/length(vec)

# 「女」の割合を計算する
sum(vec=="女")/length(vec)

# 割合を%で表示する
scales::percent(sum(vec=="男")/length(vec))

# データを作成する
dat <- tibble(vec = c("女","女","男","女","男",
                      "女","女","男","女","女"))

# 割合をsummariseを利用して計算する
dat %>% 
  summarise(
    n_dansei = sum(vec=="男"),
    n_jyosei = sum(vec=="女"),
    w_dansei = n_dansei/length(vec),
    w_jyosei = n_jyosei/length(vec),
    p_dansei = scales::percent(w_dansei),
    p_jyosei = scales::percent(w_jyosei)
  )

# count関数
dat %>% count(vec)

# 割合まで計算してみる
dat %>% 
  count(vec) %>% 
  mutate(total=sum(n), 
         wariai=n/total, 
         percent=scales::percent(wariai))