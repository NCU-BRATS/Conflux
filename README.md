# 系統需求

* postgresql > 9.4 for jsonb support
* elasticsearch 1.6
* elasticsearch plugin - Smart Chinese Analysis

# 啟動

為了啟動，我們需要設定 postgresql, elasticsearch, private_pub 這三個服務。

## 設定 Postgresql

首先先將 .env.example 複製成 .env，再設定 DATABASE_USERNAME 與 DATABASE_PASSWORD，例如：
```bash
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
```

如果你設定都正確的話，你應該可以使用這個 rake task 來創建資料庫：
```bash
$ rake db:create
```
*如果這個指令失敗的話，那你也可以手動創建資料庫。*

再來用請先跑過 migration，讓它創建資料表
```bash
$ rake db:migrate
```

## 設定 elasticsearch

首先先到 elasticsearch 官網下載 zip 並解壓縮出 elasticsearch 資料夾。並安裝對應版本的 smartcn plugin。

smartcn plugin 對應的版本請閱 https://github.com/elastic/elasticsearch-analysis-smartcn

```bash
$ cd elasticsearch-1.6.0
$ ./bin/plugin install elasticsearch/elasticsearch-analysis-smartcn/2.6.0 # this version is only for elasticsearch 1.6 !
```

為了 Debug 與監控 elasticsearch 狀態，可以再安裝 Marvel plugin。
```bash
$ ./bin/plugin -i elasticsearch/marvel/latest
```

接下來使用以下指令即可運行 elasticsearch：
```bash
$ ./bin/elasticsearch
```

若有安裝 Marvel Plugin，我們可以造訪 http://localhost:9200/_plugin/marvel/ 來觀看狀態。另外 http://localhost:9200/_plugin/marvel/sense/ 提供了一個 developer console 可以方便的對 elasticsearch 發送 request。

我們使用 chewy gem 作為 elasticsearch wrapper，設定檔在於 config/chewy.yml。
```yml
development:
  host: 'localhost:9200'
```

確定設定無誤後，使用 chewy rake task 來建立 Conflux 使用的 elasticsearch index。
```bash
$ cd conflux
$ rake chewy:reset:all
```

日後若有需要 reindex，也使用 chewy 提供的 rake task，這樣才有 zero downtime。
其他 rake task 請見 https://github.com/toptal/chewy/blob/master/lib/tasks/chewy.rake

## 設定 Private_Pub

我們使用了 private_pub gem 使用 Faye 提供 websocket 功能。其設定檔在於 config/private_pub.yml。
```yml
development:
  server: "http://localhost:9292/faye"
  secret_token: "secret"
test:
  server: "http://localhost:9292/faye"
  secret_token: "secret"
production:
  server: "http://example.com/faye"
  secret_token: "6724b127a8454d9e3dd32645d921201c0a04940fd6e4fbf1889fb2c335429dbb"
  signature_expiration: 3600 # one hour

```

啟動 private_pub
```
$ rackup private_pub.ru -s thin -E production
```

## 啟動 rails server

postgresql, elasticsearch, sync 都設定好了之後就可以使用以下指令開啟 rails server：
```bash
$ rails s
```

然後訪問 http://localhost:3000 即可。
