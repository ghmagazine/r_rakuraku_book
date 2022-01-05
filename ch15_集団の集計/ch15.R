# 15章 集団の集計---------------------------

## 15.1 表を1つの変数で分割して集計しよう---------------------------

#表を作成する
dat <- tibble(
  vanilla = c("あり","あり","あり","あり","あり",
              "なし","なし","なし","なし","なし"),
  age     = c(38,32,41,25,30,10,11,14,25,30),
  sex     = c("男","男","男","女","男",
              "男","男","男","女","女")
)

# group_by()で分割してみる
dat %>% group_by(vanilla)

# group_by()なしで、summarise()してみる
dat %>% summarise(age = mean(age))

# group_by()して、summarise()してみる
dat %>% group_by(vanilla) %>% summarise(age = mean(age))

## 15.2 表を2つの変数で分割して集計しよう---------------------------

#データは前節のものを利用
dat %>% group_by(sex, vanilla)

# group_by()で2変数指定した場合のsummarise()
dat %>% 
  group_by(sex, vanilla) %>% 
  summarise(mean_age=mean(age))

#男性、女性の割合を計算してみる。
dat %>% 
  group_by(sex, vanilla) %>% 
  summarise(mean_age=mean(age)) %>% 
  ungroup()

## 15.3 表が何行か調べよう---------------------------

# データは引き続き15.1節のものを利用
dat %>% mutate(n = n())

# summarise()を実行
dat %>% summarise(n=n())

# n()は分割された表でも動作する
dat %>% 
  group_by(sex) %>% 
  mutate(n = n())

#グループ分けしてsummarise()
dat %>% 
  group_by(sex) %>% 
  summarise(n = n())

## 15.4 行の前後の値で比較しよう---------------------------

# ベクトル
vec <- 1:10
vec

# lag()は後ろにずらす。「遅れる」イメージ
lag(vec)

# lead()は前にずらす。「先にすすむ」イメージ
lead(vec)

# データの作成。
dat <- tibble(tenpo = "A", month = 1:12, 
              uriage = round(runif(12,100,2000)))
              # uriage列は、round関数で整数に四捨五入
dat

# 先月の売上列(sengetu)と、「先月の売上-今月の売上列（sa）」を作成
dat %>% 
  mutate(
    sengetu = lag(uriage),
    sa = uriage - lag(uriage)
  )


## 15.5 売上データの店舗別・月別変化を調べよう---------------------------

#データの作成(1000行4列)
# rpois()はポワソン分布に従うランダムな数字を生成する関数（本書では解説していない）
set.seed(12345)
dat <- tibble(
  tenpo = sample(LETTERS[1:10], 1000, TRUE),
  aji   = sample(c("バニラ","いちご","チョコ"), 1000, TRUE),
  tuki  = sample(1:12,1000,TRUE),
  kosu  = rpois(1000,1)+1
)

# 味についてのマスタデータを作成
aji_master <- tibble(
  aji = c("バニラ","いちご","チョコ"),
  nedan = c(600, 650, 700)
)

# 店舗ごとにそれぞれのアイスが売れた個数を集計する
dat2 <- dat %>% 
  group_by(tenpo,aji) %>% 
  summarise(total_kosu = sum(kosu))
dat2

#それぞれの味の値段をくっつけて売上を計算する
dat3 <- dat2 %>% 
  left_join(aji_master, by="aji") %>% 
  mutate(aji_uriage = total_kosu * nedan)
dat3

#さらに店舗ごとに売上を集計する
dat3 %>% 
  summarise(uriage = sum(aji_uriage))

#店舗ごとではなく、アイスクリームの味ごとの売上を集計してみる
dat %>% 
  group_by(aji) %>% 
  summarise(n_kosu = sum(kosu)) %>% 
  left_join(aji_master,by="aji") %>% 
  mutate(uriage = n_kosu * nedan)

#店舗で総売上の平均値からの差を計算して成績優秀な店舗順に並び替える
dat %>% 
  group_by(tenpo,aji) %>% 
  summarise(n_kosu = sum(kosu)) %>% 
  left_join(aji_master,by="aji") %>% 
  mutate(uriage = n_kosu * nedan) %>% 
  summarise(total_uriage = sum(uriage)) %>% 
  mutate(mean_uriage = mean(total_uriage),
         diff = total_uriage - mean_uriage) %>% 
  arrange(desc(diff))

# 全体の売上の変化を計算して、全体でどの月が売上が最も増えるかを集計してみる
dat %>% 
  left_join(aji_master, by="aji") %>% 
  mutate(uriage_ko = kosu*nedan) %>% 
  group_by(tuki) %>% 
  summarise(uriage = sum(uriage_ko)) %>% 
  mutate(sa = uriage - lag(uriage)) %>% 
  arrange(desc(sa))
