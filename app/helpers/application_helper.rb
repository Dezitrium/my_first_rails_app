module ApplicationHelper

  def base_title
    'Ruby on Rails Tutorial Sample App'
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    title = base_title

    Array(page_title).each do |var|
      title << (' | ' + var) unless var.empty?      
    end

    title
  end 

  def vertical_text(text)
    sanitize(raw(text.gsub(/./) { |s| "<em>" + s + "</em>"}))
  end

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 60)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end

end
