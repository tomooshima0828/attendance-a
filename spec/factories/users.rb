FactoryBot.define do
  factory :user do
    name { "test_user1" }
    email { "test_email1@test.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
