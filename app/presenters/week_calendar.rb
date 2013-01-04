class WeekCalendar

  def initialize(start_at, events)
    @duration = (start_at.beginning_of_week.to_date..start_at.end_of_week.to_date)
    
    event_data = events.group_by(&:date)

    @days = {}
    @duration.each do |date|
      @days[date] = event_data[date].blank? ? DayData.new :
      DayData.new(event_data[date].map(&:event).sort_by { |evt| evt.start_at.hour })
    end
  end

  def days
    @duration
  end

  def [] (val)
    @days[val]
  end

  private 

    class DayData
      def initialize(events = [])    
        @data = {}
        @max_col = 0
        events.each { |event| add_event(event) }
      end

      def add_event(event)
        start_hour = event.start_at.hour
        end_hour = event.end_at.min > 0 ? (event.end_at.hour + 1) : event.end_at.hour

        col = find_col(start_hour, end_hour)
        @max_col = col if col > @max_col

        insert(col, start_hour, end_hour, event)    
      end

      def get_events_for(opts = {}) 
        data = (@data[opts[:hour]] || [])[0..@max_col]
        data += Array.new(span-data.length) { nil } if data.length<span
        data
      end

      def span
        @max_col + 1
      end

      private

        def find_col(start_hour, end_hour)
          col = 0
          (start_hour...end_hour).each do |i|
            @data[i] ||= [nil]
            data = @data[i]
            current_col = data.index(nil) || (data.length + 1)
            col = current_col if current_col > col
          end
          col
        end

        def insert(col, start_hour, end_hour, event)
          lasts = end_hour-start_hour   
          @data[start_hour].insert(col, [lasts, event])
          (start_hour+1...end_hour).each do |i|
            @data[i].insert(col, :lasts)
          end   
        end
    end

end
