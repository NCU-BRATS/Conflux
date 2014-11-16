已經大幅修改過 scaffold generator，讓 scaffold generator 生出來的東西整合了 ransack searching interface 還有 kaminari paginating interface。

可以直接使用 scaffold generator 加快開發速度，例如：
```bash
$ rails g scaffold post title content:text
$ rake db:migrate
```

即可創建一個基本的 Post resource 
