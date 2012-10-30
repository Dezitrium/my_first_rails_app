namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_admins
    make_users
    make_microposts
    make_relationships
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
end

