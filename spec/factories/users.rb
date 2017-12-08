FactoryBot.define do
  factory :user do
    name "User"
    email "user@email.com"
    password "password"
    password_confirmation "password"
  end
end
