# 第一次使用

第一次使用須先設定資料庫連線的設定檔，我們開發統一使用 postgresql，請先確定你有安裝 postgresql

首先先將 config/database.yml.example 複製成 config/database.yml，再設定 host, username 與 password，例如：
```yml
# config/database.yml
default: &default
  adapter: postgresql
  encoding: utf8
  host: localhost
  username: rueian
  password: ''
```

如果你設定都正確的話，你應該可以使用這個 rake task 來創建資料庫：

```bash
$ rake db:create
```

如果這個指令失敗的話，那你也可以手動創建資料庫。

# 起始環境

第一次使用請先跑過 migration，讓它創建 User 資料表
```bash
$ rake db:migrate
```

目前環境已經整合 Devise 登入系統，也已經大幅修改過 scaffold generator，讓 scaffold generator 生出來的東西整合了 ransack searching interface 還有 kaminari paginating interface。

我們可以直接使用 scaffold generator 加快開發速度，例如：
```bash
$ rails g scaffold post title content:text
$ rake db:migrate
```

用 scaffold 創建完一個新的 resource 後，有幾件事情記得要手動去做：

1. 到 config/locales/app.zh-TW.yml 補上 resource 還有其欄位的中文翻譯
2. 到 db/seeds.rb 裡面加入測試用的 seed data

例如：
```yml
# config/locales/app.zh-TW.yml
zh-TW:
  activerecord:
    models:
      post: '文章'
    attributes:
      post:
        title: '標題'
        content: '內文'
```

```rb
# db/seeds.rb
if Rails.env.development?

  # 在這個 block 裡面加入 seed 指令, 隨機資料參見 https://github.com/stympy/faker
  Post.create title: Faker::Lorem.sentences, content: Faker::Lorem.paragraph

end
```

# Dev Rake Task
由 Rails 101.pdf 裡面提供了好用的 rebuild rake tasks
```bash
$ rake dev:rebuild
```
使用即可將資料庫砍掉重建並跑 migration 與 seed
