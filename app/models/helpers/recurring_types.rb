module RecurringTypes
  def self.once(date)

  end

  def self.daily(date)
    date.advance(days:1)
  end

  def self.weekly(date)
    date.advance(days:7)
  end

  def self.yearly(date)
    date.advance(years:1)
  end

  def self.workdays(date)
    result = date
    begin 
      result = result.advance(days:1)
    end while [0,6].include? result.wday        
    result
  end
end