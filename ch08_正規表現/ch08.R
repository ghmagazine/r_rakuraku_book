# 8章 正規表現-----------------------

本章では正規表現について学びます。

## 8.1 正規表現のイメージ-----------------------

# 「整えられた」都道府県の列
dat <- tibble(
  `都道府県` = c("北　　海　　道","神　奈　川　県","東　　京　　都","大　　阪　　府","鹿　児　島　県")
)

# 全角スペースを置き換えてみる
dat %>% 
  mutate(pref = str_remove_all(`都道府県`,"　"))

#住所データ（架空）
vec <- c(
  "〒123-4567 架空県大木井市大木井町11-23-450",
  "〒123-4568 架空県中市中町3-21-451",
  "〒123-4569 架空県小市小町100-10-452"
)

# 町名だけを抜き出す
str_extract(vec,"(?<=市).+(?=町)")

# 11-23-450の表記を、11丁目23番450という記載に変更する
str_replace(vec,"(?<=町)(\\d+)-(\\d+)-(\\d+)$"," \\1丁目\\2番\\3")

## 8.2 いらない文字を削除する、`str_remove`---------------------

# ベクトルの作成
vec <- c("北　　海　　道",
         "神　奈　川　県",
         "東　　京　　都",
         "大　　阪　　府",
         "鹿　児　島　県",
         "　京　都　府　")
vec

# str_remove(strin, pattern)でpatternを除外
str_remove(vec,"　")

# str_remove_all(string, pattern)で全部のpatternを除外
str_remove_all(vec, "　")

# 都・道・府・県を除外する？
vec %>% str_remove_all("　") %>% str_remove("[都道府県]")

# $で、文字の最後を指定して都道府県を除外する
vec %>% str_remove_all("　") %>% str_remove("[都道府県]$")

# ^: 先頭
str_view("This is a pen. It's price is $1.20.", "^")

# $: 末端
str_view("This is a pen. It's price is $1.20.", "$")

# \d: 数字
str_view("This is a pen. It's price is $1.20.", "\\d")
str_view_all("This is a pen. It's price is $1.20.", "\\d")

# \s: スペース（半角）
str_view("This is a pen. It's price is $1.20.", "\\s")
str_view_all("This is a pen. It's price is $1.20.", "\\s")

# .: 「なんでも抽出」
str_view("This is a pen. It's price is $1.20.", ".")
str_view_all("This is a pen. It's price is $1.20.", ".")

# +: 直前の文字が「1回以上連続する」
str_view("A AA AAA AAAA AAAAA", "A+")
str_view_all("A AA AAA AAAA AAAAA", "A+")

# {m,}:直前の文字が「m回以上連続する」
str_view("A AA AAA AAAA AAAAA", "A{2,}")
str_view_all("A AA AAA AAAA AAAAA", "A{2,}")

# {m,n}:直前の文字が「m回から最高n回連続する」
str_view("A AA AAA AAAA AAAAA AAAAAA", "A{2,3}")
str_view_all("A AA AAA AAAA AAAAA AAAAAA", "A{2,3}")

# a|b:正規表現aか正規表現bを抽出する
str_view("apple / book / absolute / bad / idea ","\\sa|e\\s")
str_view_all("apple / book / absolute / bad / idea ","\\sa|e\\s")

# [abc]:文字a,b,cのいずれかの1文字
str_view("abcdefg,abesdbc","[abc]+")
str_view_all("abcdefg,abesdbc","[abc]+")

## 8.2 正規表現でロジカルな判定`str_detect`-----------------------------

# 表を作成
dat <- tibble(
  vec = c(
    "cake(food): 520",
    "fruit(food):895",
    "tea(drink): 620",
    "coffee(drink):800",
    "water(drink): 200",
    "banana juice(drink): 1200"
  )
)

dat

# filterとstr_detectを組み合わせて抽出
dat %>% 
  filter(str_detect(vec,"\\d00$"))

# drinkという表記がある行のみを抜き出す
dat %>% filter(str_detect(vec,"drink"))

# cで始まるメニューがある行のみを抜き出す
dat %>% filter(str_detect(vec,"^c"))

# メニューがeで終わっている行を抜き出す
dat %>% filter(str_detect(vec,"e\\("))

# \\で\が文字として入力できる。正規表現で\は\\\\
str_view("kore -> \\",　"\\\\")

# \"で""の中に"を入れられる。
str_view('""','"')

## 8.3 正規表現で抽出`str_extract`--------------------------------

# 住所データ（架空）
vec <- c(
  "〒123-4567 架空県大木井市大木井町11-23-450",
  "〒123-4568 架空県中市中町3-21-451",
  "〒123-4569 架空県小市小町100-10-452"
)

# 町名だけを抜き出す
str_extract(vec,"(?<=市).+(?=町)")

# 町名だけを抜き出す正規表現："(?<=市).+(?=町)"
str_extract(vec,".+")

# 「市という文字に続いて」という正規表現
str_extract(vec,"(?<=市).+")

# 「町という文字が後に続く」という正規表現
str_extract(vec,".+(?=町)")

# 「市という文字に続いて」間になんでも「町という文字が後に続く」
# 正規表現
str_extract(vec,"(?<=市).+(?=町)")

#()の中身を取り出す。
dat %>% 
  mutate(toridasi = str_extract(vec,"(?<=\\().+(?=\\))"))

# 8.1節の例のベクトル
vec

# 例のベクトルの11-23-450の表記を、11丁目23番450という記載に変更する
str_replace(vec,"(?<=町)(\\d+)-(\\d+)-(\\d+)$"," \\1丁目\\2番\\3")

# 数字の前に￥記号を入れる。
dat %>% 
  mutate(vec2 = str_replace(vec,"(^.+( |:))(\\d+)","\\1￥\\3"))

## 8.5 正規表現のまとめ---------------------------------------
