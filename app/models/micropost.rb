# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  default_scope order: 'microposts.created_at DESC'

  MAXIMUM_MICROPOST_LENGTH = 160

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: MAXIMUM_MICROPOST_LENGTH }


  def self.from_users_followed_by(user)
    followed_user_ids = user.followed_user_ids
    where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  end
end
