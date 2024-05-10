# 建立專案

```sh
rails new booking
```

# Credential

```sh
EDITOR="code --wait" ./bin/rails credentials:edit
EDITOR="code --wait" ./bin/rails credentials:edit --environment production
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

## 忘記密碼
```sh
./bin/rails g migration AddPasswordResetFieldsToUsers password_reset_token:string password_reset_token_expire_at:datetime
./bin/rails g mailer UserMailer
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

# Docker 

使用 `github.com/elct9620/boxing` 自動產生 Dockerfile

```sh
./bin/bundle exec boxing generate
```

補上

```
RUN apk add --no-cache libpq-dev tzdata
```

build 的那個 image 也要加上 `libpq-dev`

部屬的時候如果是第一次就先 `migrate` 和 `seed`

```sh
docker exec -it <container ID> bundle exec rails db:migrate
docker exec -it <container ID> bundle exec rails db:seed
```

# docker push to gcloud

```sh
docker build -t booking --build-arg="GMAIL_SENDER=" --build-arg="GMAIL_PASSWORD=" .
```

```sh
docker save booking | bzip2 | ssh enfu_liao_work@34.81.223.120 docker load
```

# docker installation (for debian)

參考官網

```sh
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
docker compose
sudo groupadd docker
sudo usermod -aG docker $USER
```
