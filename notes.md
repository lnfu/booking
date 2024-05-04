# 建立專案

```sh
rails new booking
```

# 安裝 tailwind css

```sh
./bin/bundle add tailwindcss-rails
./bin/rails tailwindcss:install
```

# Migrations

```sh
./bin/rails g model TimeSlot name:string:index start_at:time end_at:time
./bin/rails g model Room name:string:index password:string color:string
./bin/rails g model User name:string:index email:string nick:string password_digest:string role:integer email_verified_at:time
./bin/rails g model Reservation time_slot:references room:references user:references date:date 
```

# PostreSQL docker

```sh
psql -d database_name -U user_name -h localhost -W
./bin/rails db:migrate
./bin/rails db:seed
```

# Controllers

```sh
./bin/rails g controller TimeSlots
./bin/rails g controller Rooms
./bin/rails g controller Users
./bin/rails g controller Session
./bin/rails g controller Profile
./bin/rails g controller Reservations
./bin/rails g controller Boards
./bin/rails g controller Limits
./bin/rails g controller Rules
```

之後如果要把 rules 改成 announcement 就把以下相關檔案刪除:
```
      create  app/controllers/rules_controller.rb
      invoke  tailwindcss
      create    app/views/rules
      invoke  test_unit
      create    test/controllers/rules_controller_test.rb
      invoke  helper
      create    app/helpers/rules_helper.rb
      invoke    test_unit
```

# Settings

```sh
./bin/rails g settings:install
```