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
```
