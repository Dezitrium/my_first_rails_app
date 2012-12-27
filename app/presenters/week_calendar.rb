class WeekCalendar

  def initialize(start_at, events)
    @duration = (start_at.beginning_of_week.to_date..start_at.end_of_week.to_date)
    create_days(events)    
  end

  def days
    @duration
  end

  def [] (val)
    @days[val]
  end

  private 

    class Day < Struct.new(:name, :abbrv, :data)
    end

    def create_days(events)    
      @days = {}
      event_data = events.group_by(&:date)

      @duration.each do |date|
        day = Day.new
        day.name  = date.strftime('%A')
        day.abbrv = date.strftime('%a')
        unless event_data[date].blank?
          day.data = DayData.new(event_data[date].map(&:event)
                                                 .sort_by { |evt| evt.start_at.hour })
        else
          day.data = DayData.new
        end
        @days[date] = day
      end
    end
end
