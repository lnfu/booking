# 建立專案

```sh
rails new booking
```

# 安裝 tailwind css

```sh
./bin/bundle add tailwindcss-rails
./bin/rails tailwindcss:install
```

# Model: timeslot

```sh
./bin/rails g model TimeSlot name:string:index start_at:time end_at:time
```



