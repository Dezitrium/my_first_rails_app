include ApplicationHelper

def sign_in(user)
  fill_signin_form user
  click_button 'Sign in' 
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end