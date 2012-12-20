require 'helpers/recurring_types'

class Event < ActiveRecord::Base
  attr_accessible :end_at, :recurring_type, :start_at, :title

  # named_scope :by_month, lambda { |d| { conditions: { date: d.beginning_of_month..d.end_of_month } } }


  after_initialize { self.recurring_type ||= "once" }

  after_update :build_event_data
  before_save :build_event_data, on: [:create, :update]

  belongs_to :user
  has_many :event_data

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 160 }
  validates :start_at, presence: true
  validates :end_at, presence: true, date: { after: :start_at }, unless: :recurring_type == :once
  validates :recurring_type, presence: true, inclusion: { in: RecurringTypes.methods(false) }


  # def recurring_type    
  # end

  # def recurring_type=(val)
  # end

  private

    def build_event_data

      current_date = start_at.to_date
      end_date = end_at.to_date

      while current_date <= end_date
        event_data.create!(date: current_date)
        current_date = RecurringTypes.send(recurring_type, current_date)
      end
    end    
end
