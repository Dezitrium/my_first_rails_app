module EventsHelper

  def day_abbrvs
    #%w(Mon Die Mit Don Fre Sam Son)
    %w(Mon Tue Wed Thu Fri Sat Sun)
  end

  def hour_column
    'Uhrzeit'
  end

  def day_names
    %w(Montag Dienstag Mittwoch Donnerstag Freitag Samstag Sonntag)
  end

  def link_week(date, html_opts = {})
    link_to raw(yield(date)), {cweek: date.cweek, year: date.year}, html_opts
  end

  def link_month(date, html_opts = {})
    link_to raw(yield(date)), {month: date.month, year: date.year}, html_opts
  end

  def link_show_event(event, html_opts = {})   
    link_to raw(yield(event)), {controller: :events, action: :show, id: event.id}, html_opts
  end

  def format_week_range(date)
    return '' unless date.respond_to?(:beginning_of_week) && 
                     date.respond_to?(:end_of_week)                     
    from_date = date.beginning_of_week
    to_date   = date.end_of_week
    
    from_year = from_date.year
    to_year = to_date.year
    show_year = from_year != to_year

    result = '(' 
    result << (show_year ? format_date(from_date) : format_short_date(from_date)) 
    result << ' - '
    result << format_date(to_date) 
    result << ')'
    result
  end

  def format_week(date)
    date.respond_to?(:cweek) ? ('CW ' + date.cweek.to_s) : ""    
  end

  def format_month(date)
    date.respond_to?(:strftime) ? date.strftime('%B %Y') : ""
  end

  def format_short_date(date)
    date.respond_to?(:strftime) ? date.strftime('%d %b') : ""
  end

  def format_date(date)
    date.respond_to?(:strftime) ? date.strftime('%d %b %Y') : ""
  end

  def format_datetime(time)
    time.respond_to?(:strftime) ? time.strftime('%e %b %Y %I:%m%p') : ""
  end

  def format_time(time)
    time.respond_to?(:strftime) ? time.strftime('%I:%M %p') : ""
  end  

  def select_year_options(date)
    from_date = date.advance(years: -5)
    to_date = date.advance(years: 5)
    options_for_select((from_date.year...to_date.year).to_a, date.end_of_week.year)
  end
end
