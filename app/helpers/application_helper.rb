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

end
