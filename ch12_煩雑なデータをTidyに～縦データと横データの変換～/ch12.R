# 12章 ヨコとタテのデータへの変換--------------------------

## 12.1 longとwideなデータ--------------------------

## 12.2 pivot_longerの基本的な使い方--------------------------

# データの作成
dat <- tribble(
  ~item, ~m_20s, ~m_30s, ~f_20s, ~f_30s,
  "バニラ", 1  , 2     , 3     , 4    ,
  "いちご", 5  , 6     , 7     , 8    ,
  "チョコ", 9  , 10    , 11    , 12
)

dat

# pivot_longer関数で、item列以外の列を指定して縦持ちへ
dat %>% 
  pivot_longer(cols=!item, names_to="N",values_to="V")

## 12.3 pivot_widerの基本的な使い方

# データの作成
dat <- tibble(
  tenpo  = c(rep("A",4), rep("B",4),rep("C",4)),
  ki     = rep(c("Q1","Q2","Q3","Q4"),3),
  uriage = 1:12
)
dat

# pivot_wider関数を利用してki列を「列データ」、uriage列をその値へ
dat %>% 
  pivot_wider(
    id_cols = tenpo, names_from = ki, values_from = uriage)

## 12.4 `pivot_longer`の応用:複数列に列データを分割してみよう--------------------------

# データの作成
dat <- tribble(
  ~item, ~m_20s, ~m_30s, ~f_20s, ~f_30s,
  "バニラ", 1  , 2     , 3     , 4    ,
  "いちご", 5  , 6     , 7     , 8    ,
  "チョコ", 9  , 10    , 11    , 12
)

# pivot_longer関数で縦持ちにしたあと、
# separateで性別（sex）と年代列（age）を追加
dat %>% 
  pivot_longer(cols=!item, names_to="N",values_to="V") %>% 
  separate(N,c("sex","age"),sep="_")

# separateを使わずにpivot_longerだけで列データを処理する
dat %>% 
  pivot_longer(
    cols = !item,
    names_to = c("sex","age"),
    names_sep = "_",
    values_to = "V"
  )

## 12.5 `pivot_wider`の応用:「ない値」を埋めてみよう--------------------------

# データの作成（店舗CのQ1,Q2のデータない）
dat <- tibble(
  tenpo  = c(rep("A",4), rep("B",4),rep("C",2)),
  ki     = c(rep(c("Q1","Q2","Q3","Q4"),2),"Q3","Q4"),
  uriage = 1:10
)
dat

# pivot_wider関数で横に広げると
dat %>% 
  pivot_wider(
    id_cols = tenpo, names_from = ki, values_from = uriage)

# vlues_fill=0とすると、NAでなくて0で埋めることができる
dat %>% 
  pivot_wider(
    id_cols     = tenpo, 
    names_from  = ki, 
    values_from = uriage,
    values_fill = 0
  )

## 12.6 `pivot_xxx`関数を組み合わせて自由にデータを変換してみよう--------------------------

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

# まず、pivot_longerで縦持ちデータに変換する
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

# 横に広げたときに、値を1と表記するための値列を作成してからpivot_widerで横に広げる
# またNAとなる値は0で埋めておく
step3 <- step2 %>% 
  mutate(atai = 1) %>% 
  pivot_wider(id_cols = id, names_from=sentaku, values_from=atai,values_fill=0)

step3
