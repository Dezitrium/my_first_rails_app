FactoryGirl.define do
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "123456789"
    password_confirmation "123456789"
  end
end