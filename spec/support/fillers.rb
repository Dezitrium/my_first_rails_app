# module Fillers
  def fill_signup_form(user)
    return unless user
    fill_in "Name",         with: user.name
    fill_in "Email",        with: user.email
    fill_in "Password",     with: user.password
    fill_in "Confirmation", with: user.password_confirmation
  end

  def fill_signin_form(user)    
    return unless user
    fill_in "Email",      with: user.email    unless user.email.blank?
    fill_in "Password",   with: user.password unless user.password.blank?
  end  
# end