module SessionsHelper

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user=(user)
    @current_user = user
  end


  def sign_in(user)
    # expires: 20.years.from_now.utc
    cookies.permanent[:remember_token] = user.remember_token 
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
    delete_location
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    current_user == user
  end

  # friendly forwarding
  def store_location
    session[:redirect_back_to] = request.url
  end

  def redirect_back_or(default)
    redirect_to(session[:redirect_back_to] || default)
    delete_location
  end

  def delete_location
    session.delete(:redirect_back_to)
  end

end
