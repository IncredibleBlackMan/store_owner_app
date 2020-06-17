FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.first_name }
    email { Faker::Internet.email }
    password_digest { 'MyString' }
  end
end
