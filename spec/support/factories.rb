FactoryGirl.define do
  factory :user do
    name     "Max Musterman"
    email    { "user_#{rand(10000)}@factory.com" }
    password "123456789"
    password_confirmation "123456789"
  end
end