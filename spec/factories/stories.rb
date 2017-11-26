FactoryBot.define do
  factory :story do
    user_id nil
    content "Soy un tweet"
    source "Twitter"
    latitude 43.6532
    longitude -79.3832
  end
end
