# 12章 煩雑なデータをTidyに～縦データと横データの変換～--------------------------

## 12.1 縦と横のデータを理解しよう--------------------------

## 12.2 横のデータを縦のデータに変換しよう--------------------------

# データの作成
dat <- tribble(
  ~item, ~m_20s, ~m_30s, ~f_20s, ~f_30s,
  "バニラ", 1  , 2     , 3     , 4    ,
  "いちご", 5  , 6     , 7     , 8    ,
  "チョコ", 9  , 10    , 11    , 12
)

dat

# pivot_longer()で、item列以外の列を指定して縦持ちデータへ
dat %>% 
  pivot_longer(cols=!item, names_to="N",values_to="V")

## 12.3 縦のデータを横のデータに変換しよう

# データの作成
dat <- tibble(
  tenpo  = c(rep("A",4), rep("B",4),rep("C",4)),
  ki     = rep(c("Q1","Q2","Q3","Q4"),3),
  uriage = 1:12
)
dat

# pivot_wider()を利用してki列を「列データ」、uriage列をその値へ
dat %>% 
  pivot_wider(
    id_cols = tenpo, names_from = ki, values_from = uriage)

## 12.4 横から縦への変換の応用～列データを変換しながら複数の列に分割しよう〜--------------------------

# データの作成
dat <- tribble(
  ~item, ~m_20s, ~m_30s, ~f_20s, ~f_30s,
  "バニラ", 1  , 2     , 3     , 4    ,
  "いちご", 5  , 6     , 7     , 8    ,
  "チョコ", 9  , 10    , 11    , 12
)

# pivot_longer()で縦持ちにしたあと、
# separate()で性別列（sex）と年代列（age）を追加
dat %>% 
  pivot_longer(cols=!item, names_to="N",values_to="V") %>% 
  separate(N,c("sex","age"),sep="_")

# separate()を使わずにpivot_longer()だけで列データを処理する
dat %>% 
  pivot_longer(
    cols = !item,
    names_to = c("sex","age"),
    names_sep = "_",
    values_to = "V"
  )

## 12.5 縦から横への変換の応用～欠損しているデータを埋めよう～--------------------------

# データの作成（店舗CのQ1,Q2のデータない）
dat <- tibble(
  tenpo  = c(rep("A",4), rep("B",4),rep("C",2)),
  ki     = c(rep(c("Q1","Q2","Q3","Q4"),2),"Q3","Q4"),
  uriage = 1:10
)
dat

# pivot_wider()で横に広げると
dat %>% 
  pivot_wider(
    id_cols = tenpo, names_from = ki, values_from = uriage)

# vlues_fill = 0とすると、NAでなくて0で埋めることができる
dat %>% 
  pivot_wider(
    id_cols     = tenpo, 
    names_from  = ki, 
    values_from = uriage,
    values_fill = 0
  )

## 12.6 自由にデータを変換しよう--------------------------

# 図12-6のデータを作成
dat <- tribble(
  ~id, ~qx_1   , ~qx_2      , ~qx_3   ,
  1  , "バニラ", "イチゴ"   , NA      ,
  2  , "バニラ", "あずき"   , "抹茶"  ,
  3  , "イチゴ", "チョコ"   , "ミルク",
  4  , "みかん", NA         , NA      ,
  5  , "バニラ", "チョコ"   , "あずき"
)
dat

# まず、pivot_longer()で縦持ちデータに変換する
step1 <- dat %>% 
  pivot_longer(cols=starts_with("qx_"),
               names_to = "aji",
               values_to = "sentaku")
step1

# ここで、aji列は不用なので削除
# NAも不用なので削除

step2 <- step1 %>% 
  select(!aji) %>% 
  filter(!is.na(sentaku))

step2

# 横に広げたときに、値を1と表記するための
# 値列を作成してからpivot_wider()で横に広げる
# またNAとなる値は0で埋めておく
step3 <- step2 %>% 
  mutate(atai = 1) %>% 
  pivot_wider(id_cols = id, names_from=sentaku, values_from=atai,values_fill=0)

step3
