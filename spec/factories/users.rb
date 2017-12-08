FactoryBot.define do
  factory :user do
    name "John Smith"
    email "test@testing.com"
    created_at DateTime.parse("2017-12-01 15:53:36.279905")
    updated_at DateTime.parse("2017-12-01 15:53:36.279905")
    encrypted_password "adfafdasdf5658s798d7f98s7df"
  end
end
