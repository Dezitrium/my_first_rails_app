namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_admins
    make_users
    make_microposts
    make_relationships
    make_events
  end

  private 
    def make_admins      
      admin = User.create!(name: "Example User",
                   email: "example@railstutorial.org",
                   password: "123456789",
                   password_confirmation: "123456789")
      admin.toggle!(:admin)
    end

    def make_users
      4.times do |n|
        name  = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password  = "password"
        User.create!(name: name,
                     email: email,
                     password: password,
                     password_confirmation: password)
      end

      95.times do |n|
        name  = Faker::Name.name
        email = "#{name.split.join('.').downcase}_#{rand(10000)}@railstutorial.org"
        password  = "password"
        User.create!(name: name,
                     email: email,
                     password: password,
                     password_confirmation: password)
      end
    end

    def make_microposts
      users = User.all(limit: 6)
      50.times do
        content = Faker::Lorem.sentence(5)
        users.each { |user| user.microposts.create!(content: content) }
      end
    end

    def make_relationships
      users = User.all(limit: 50)
      user  = users.first

      followed_users = users[2..50]
      followers = users[3..40]

      followed_users.each { |followed| user.follow! followed }
      followers.each      { |follower| follower.follow! user }
    end

    def make_events      
      users = User.all(limit: 6)

      now = DateTime.now
      users.each do |user| 
        user.events.create!(title: 'Party', 
          start_at: now.change(day:26, month:12, hour:18), 
          end_at: now.change(day:26, month:12, hour:22), 
          recurring_type: :once)

        user.events.create!(title: 'Kaffepause', 
          start_at: now.change(hour:12), 
          end_at: now.advance(months: 3).change(hour:12, min:30),
          recurring_type: :daily)

        user.events.create!(title: 'Vorlesung 1', 
          start_at: now.advance(days: 1).change(hour:14), 
          end_at: now.advance(months: 3).change(hour:16),
          recurring_type: :weekly)

        user.events.create!(title: 'Vorlesung 2', 
          start_at: now.advance(days: 2).change(hour:10), 
          end_at: now.advance(months: 3).change(hour:13),
          recurring_type: :weekly)

        user.events.create!(title: 'Birthday', 
          start_at: now.change(day:6, month:11).beginning_of_day, 
          end_at: now.change(year:2025, day:6, month:11).end_of_day, 
          recurring_type: :yearly)

        user.events.create!(title: 'Work', 
          start_at: now.change(hour:9), 
          end_at: now.advance(years: 3).change(hour:15), 
          recurring_type: :workdays)    
      end
    end
end

