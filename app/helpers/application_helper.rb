module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    base_title + " | #{page_title}" unless page_title.empty? 
  end   

end
