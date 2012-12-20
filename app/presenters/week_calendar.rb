class WeekCalendar

  attr_accessor :month, :year

  def initialize(month, year) 
    self.month = month
    self.year = year
  end

  def weeks
    [Week.new,Week.new,Week.new,Week.new,Week.new,Week.new,Week.new]
  end

  def day_abbrvs
    #%w(Mon Die Mit Don Fre Sam Son)
    %w(Mon Tue Wed Thu Fri Sat Sun)
  end

  def day_names
    %w(Montag Dienstag Mittwoch Donnerstag Freitag Samstag Sonntag)
  end


  class Week
    def days
      [Date.today,Date.today,Date.today,Date.today,Date.today,Date.today,Date.today]
    end

    def events
      User.find(1).events
    end
  end
end
