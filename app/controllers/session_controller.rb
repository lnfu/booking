require "net/http"

class SessionController < ApplicationController
  def new
  end

  def create
    case params[:login_method]
    when "password"
      user = User.find_by(name: params[:name])
      if !!user && user.authenticate(params[:password])
        p ("fdksal")
        p (user.id)
        create_session(user.id)
      end
    when "oauth"
      redirect_to(authorization_url, allow_other_host: true)
    end
  end

  def callback
    code = params[:code]
    access_token = get_access_token(code)
    user_data = get_user_data(access_token)
    login_or_create_user(user_data)
  end

  def destroy
    reset_session
    redirect_to login_path
    # TODO redirect_to root_path
  end

  private

  def authorization_url
    authorization_endpoint = "#{Rails.application.config.oauth_server}/o/authorize"
    client_id = Rails.application.credentials.oauth.client_id
    scope = Rails.application.config.oauth_scope
    "#{authorization_endpoint}?response_type=code&client_id=#{client_id}&scope=#{scope}"
  end

  def get_access_token(code)
    uri = URI("#{Rails.application.config.oauth_server}/o/token/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    access_request = Net::HTTP::Post.new(uri)
    access_request.set_form_data({
      "grant_type" => "authorization_code",
      "code" => code,
      "client_id" => Rails.application.credentials.oauth.client_id,
      "client_secret" => Rails.application.credentials.oauth.client_secret,
      "redirect_uri" => request.base_url + login_callback_path
    })
    response = http.request(access_request)
    JSON.parse(response.body)["access_token"]
  end

  def get_user_data(access_token)
    uri = URI("#{Rails.application.config.oauth_server}/api/#{Rails.application.config.oauth_scope}/")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{access_token}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    JSON.parse(response.body)
  end

  def login_or_create_user(user_data)
    name = user_data["username"]
    email = user_data["email"]

    user = User.find_or_initialize_by(name: name)
    if user.new_record?
      user.email = email
      user.nickname = name
      user.role = :guest
      user.password_digest = SecureRandom.hex(10)
      user.save
    end

    create_session(user.id)
  end

  def create_session(id)
    session[:user_id] = id
    redirect_to login_path
    # TODO redirect_to root_path
  end
end
