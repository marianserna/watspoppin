FactoryBot.define do
  factory :service do
    user
    provider "facebook"
    uid "123456"
    access_token "token"
    access_token_secret "secret"
    refresh_token "refresh"
    expires_at "2017-11-22 23:03:02"
    auth "MyText"
  end
end
