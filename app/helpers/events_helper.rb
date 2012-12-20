module EventsHelper

  def standard_date(date)
    date.respond_to?(:strftime) ? date.strftime('%d %b %Y') : ""
  end

  def standard_time(time)
    time.respond_to?(:strftime) ? time.strftime('%I:%M %p') : ""
  end

end
