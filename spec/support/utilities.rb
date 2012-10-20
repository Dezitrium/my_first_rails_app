# Returns the full title on a per-page basis.
def full_title(page_title)
	title = 'Ruby on Rails Tutorial Sample App'

	Array(page_title).each do |var|
	  title << (' | ' + var) unless var.empty?      
	end

	title
end   
