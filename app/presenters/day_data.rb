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


if $0 == __FILE__
  require 'date'
  require 'active_support/all'

  class Event < Struct.new(:start_at, :end_at)  
  end

  now = DateTime.now

  events = [Event.new(now.change(hour:6), now.change(hour:6, min:30)),
         Event.new(now.change(hour:11), now.change(hour:13)),
         Event.new(now.change(hour:9), now.change(hour:11)),
         Event.new(now.change(hour:10), now.change(hour:14)),
         Event.new(now.change(hour:15), now.change(hour:16)),
         Event.new(now.change(hour:8), now.change(hour:18))]

  data = DayData.new(events.sort_by { |evt| evt.start_at.hour })

  24.times { |i| puts "#{i}: #{data.get_events_for(hour:i) * ' | '}" }

  p data.span

  data.get_events_for(hour: 9).each_with_index do |event_data, col|
    unless event_data == :lasts
      if event_data            
        puts %(<td class="event-col-#{col+1}" 
                 rowspan="#{event_data[0]}">
                  link_edit_event(event_data[1]) {|e| e.title } 
        </td>)
      else
       puts "<td></td>"
      end
    end
  end
end
