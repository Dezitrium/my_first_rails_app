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

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "blabla"
    user
  end

  factory :event do
    title "Event (once)"
    user
    start_at { DateTime.now.advance(days: 1).change(hour:14) }
    end_at { DateTime.now.advance(days: 1).change(hour:16) }

    trait :bday do
      title "Birthday (yearly, allday)"
      start_at { DateTime.tomorrow }
      end_at nil

      recurring_type "yearly"
    end

    trait :lecture do
      title "Lecture (weekly)"
      start_at { DateTime.now.advance(days: 1).change(hour:14) }
      end_at { DateTime.now.advance(months: 3).change(hour:16) }

      recurring_type "weekly"
    end

  end

end
