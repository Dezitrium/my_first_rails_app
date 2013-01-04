class EventData < ActiveRecord::Base
  attr_accessible :date

  default_scope order: 'event_data.date ASC'

  belongs_to :event, inverse_of: :event_data

  validates :date, presence: true

  def self.from_date(date)
    where( ["date >= ?", date] )
  end

  def self.for_day(date)
    where( date: date.beginning_of_day..date.end_of_day+1 )
  end

  def self.by_week(date)
    where( date: date.beginning_of_week..date.end_of_week+1 )
  end

  def self.by_month(date)
  	where( date: date.beginning_of_month..date.end_of_month+1 )
  end

end
