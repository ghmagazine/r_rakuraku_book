# 13章 マスターデータと戦おう---------------------------

## 13.1 リレーシヨナルデータベースとは---------------------------

## 13.2 複数の表を結合させよう---------------------------

# データを作成する
hanbai <- tibble(
  date       = c("2021-4-1","2021-4-1","2021-4-2","2021-4-3"),
  kokyaku_id = c(1,2,3,1),
  item_id    = c("aa","ab","aa","ad"),
  kosu       = c(1,2,1,3)
)

kokyaku_master <- tibble(
  kokyaku_id = c(1,2,3,4),
  sex        = c("女","女","男","女"),
  age        = c(20,30,20,20)
)

item_master <- tibble(
  item_id   = c("aa","ab","ac","ad"),
  name      = c("バニラ","チョコ","イチゴ","あずき"),
  price     = c(600,690,650,700)
)

# 販売データと顧客マスタを結合する
hanbai %>% 
  left_join(kokyaku_master, by=c("kokyaku_id"))

# 商品マスタも結合する
hanbai %>% 
  left_join(kokyaku_master, by="kokyaku_id") %>% 
  left_join(item_master, by="item_id")

## 13.3 名前が違う列同士を結合しよう---------------------------

# データを作成する
hyou1 <- tibble(id1 = c(1,3,2,3,2),val1 = LETTERS[1:5])
hyou2 <- tibble(id2 = 1:5, val2 = c("あ","い","う","え","お"))

# 列名が違うデータを結合する
hyou1 %>% left_join(hyou2, by=c("id1"="id2"))

# データを作成する
hyou1 <- tibble(
  id   = c(1,3,2,3,2),
  id2  = c(1,1,1,2,2),
  val1 = LETTERS[1:5]
)

hyou1

hyou2 <- tibble(
  id  = c(1,2,2,3,3),
  ida = c(1,1,2,1,2),
  val2 = c("あ","い","う","え","お")
)

hyou2

# 複数の列名で結合する
hyou1 %>% left_join(hyou2,by=c("id","id2"="ida"))

## 13.4 いろいろな結合方法を知ろう---------------------------

# データを作成する
hyou1 <- tibble(id = c(1,3,2,3,2),val1 = LETTERS[1:5])
hyou2 <- tibble(id = 1:5, val2 = c("あ","い","う","え","お"))

# right_join()
right_join(hyou1,hyou2,by="id")

# 表をつくる
hyou1 <- tibble(id=3:6, val1=LETTERS[1:4])
hyou2 <- tibble(id=1:4, val2=c("あ","い","う","え"))

# inner_join()
inner_join(hyou1,hyou2, by="id")

# full_join()
full_join(hyou1, hyou2, by="id")

## 13.5 表を結合してデータを抽出しよう---------------------------

# 表を作成
kokyaku <- tibble(
  id = LETTERS[1:9],
  age = c(20,20,30,20,30,40,50,40,20),
  sex = c(0,0,1,1,0,0,0,1,0)
)

kokyaku

# ゴールド会員のデータを作成
gold_member <- tibble(
  id = c("A","C","D","E"),
  hiduke = c("2019-4-1","2019-11-3","2019-12-25","2020-4-3")
)

gold_member

# kokyakuデータからgold_memberに含まれるデータを抽出
kokyaku %>% semi_join(gold_member,by="id")

# gold_memberに含まれるデータを除外
kokyaku %>% anti_join(gold_member,by="id")
