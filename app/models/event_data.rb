class EventData < ActiveRecord::Base
  attr_accessible :date  

  belongs_to :event

  validates :date, presence: true
end
