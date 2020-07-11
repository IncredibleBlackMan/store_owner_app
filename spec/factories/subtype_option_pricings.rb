FactoryBot.define do
  factory :subtype_option_pricing do
    subtype_options { 'MyString' }
    quantity { 1 }
    price { '9.99' }
  end
end
