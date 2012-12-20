# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  before_save { self.email.downcase! }
  before_save :create_remember_token

  has_many :microposts, dependent: :destroy
  has_many :events, dependent: :destroy
  
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships

  validates :name, presence: true, length: { maximum: 50 }
  
  validates :email, email_format: true,
                    presence: true,
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true


  def feed
    Micropost.from_users_followed_by(self)
  end

  def follow!(other)
    relationships.create!(followed_id: other.id)
  end

  def unfollow!(other)
    relationships.find_by_followed_id(other.id).destroy
  end

  def following?(other)
    relationships.find_by_followed_id(other.id)
  end

  def followed_by?(other)
    reverse_relationships.find_by_follower_id(other.id)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
