# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'test_user1' }
    email { 'test_email1@test.com' }
    password { 'password' }
  end
end
