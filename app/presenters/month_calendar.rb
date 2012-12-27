class MonthCalendar

  def initialize(start_at, events) 
    @dates = events.group_by { |m| m.date.beginning_of_week }
    end_at = start_at.end_of_month.end_of_week
    @durations = (start_at.to_date..end_at.to_date).step(7).map(&:beginning_of_week) + [end_at+1]
  end

  def weeks
    Enumerator.new do |yielder| 
      (0...@durations.length-1).each do |i|
        week = Week.new
        week.days = (@durations[i]...@durations[i+1])
        week.events_for_date = lambda { |date, opts = {}| get_events(date, opts) }
        yielder.yield week   
      end 
    end
  end 

  private

  class Week < Struct.new(:days, :events_for_date)
  end

  def get_events(date, in_opts = {})    
    dates = @dates[date.beginning_of_week]
    return [] if dates.blank?

    opts = { limit: dates.count }.merge in_opts
    
    Enumerator.new do |yielder|          
      limit = opts[:limit]
      while limit>0 && !dates.empty? && dates.first.date == date         
        yielder.yield dates.shift.event
        limit -= 1
        if limit==0
          @dates[date.beginning_of_week] = dates.drop_while { |m| m.date == date }
        end
      end
    end
  end
end
