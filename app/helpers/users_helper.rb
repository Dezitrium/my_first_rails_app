module UsersHelper
  
  def avatar_for(user)
    user.name
  end

  # Gravatar (http://gravatar.com/) 
  DEFAULT_GRAVATAR_OPTIONS = {
      size: 52,
      class: 'gravatar'
  }

  def gravatar_url(user)
     gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
     "https://secure.gravatar.com/avatar/#{gravatar_id}"    
  end

  def gravatar_for user, options={}
    options = DEFAULT_GRAVATAR_OPTIONS.merge options
    options[:alt]  = avatar_for user
    options[:size] = "%{size}x%{size}" % options  # image_tag expects e.g. "48x48"    
    image_tag gravatar_url(user), options
  end

end
