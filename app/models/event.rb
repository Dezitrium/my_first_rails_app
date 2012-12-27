require 'helpers/recurring_types'

class Event < ActiveRecord::Base
  attr_accessible :end_at, :recurring_type, :start_at, :title

  after_initialize { self.recurring_type ||= "once" }

  after_save :generate_event_data, on: [:create, :update]

  belongs_to :user
  has_many :event_data, :class_name => "EventData", 
      inverse_of: :event,
      dependent: :destroy

  RECURRING_TYPES = RecurringTypes.methods(false)

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 160 }
  validates :start_at, presence: true
  validates :end_at, presence: true, date: { after: :start_at }, unless: Proc.new { |a| a.recurring_type == :once }
  validates :recurring_type, presence: true, inclusion: { in: RECURRING_TYPES }


  def recurring_type
    read_attribute(:recurring_type).to_sym  
  end

  def recurring_type=(val)
    write_attribute :recurring_type, val.to_s  
  end

  def self.dates_by_user(user_id)
    EventData.includes(:event).where("events.user_id = #{user_id}")
  end

  private

    def generate_event_data
      destroy_event_data
      build_event_data
    end

    def destroy_event_data
      self.event_data.each(&:destroy)
    end 

    def build_event_data
      current_date = start_at.dup

      while current_date && current_date <= end_at
        self.event_data.create!(date: current_date)
        current_date = RecurringTypes.send(recurring_type, current_date)
      end
    end    
end
