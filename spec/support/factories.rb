FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" } 
    
    email do 
      prefix = name.split.join('.').downcase
      suffix = rand(10000).to_s
      domain = 'factory.com'
      "%s_%s@%s" % [prefix, suffix, domain]
    end

    password "123456789"
    password_confirmation { password }

    trait :changed do
      name "changed User"
    end

    trait :male do
      name "John Doe"
    end

    trait :wrong_password do
      password "1234567890"
    end
  end
end
