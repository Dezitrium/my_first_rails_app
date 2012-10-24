# module Fillers
  def fill_signup_page(user)
    fill_in "Name",         with: user.name
    fill_in "Email",        with: user.email
    fill_in "Password",     with: user.password
    fill_in "Confirmation", with: user.password_confirmation
  end

  def fill_signin_form(input = {} )
    data = { with: {email: '', pw: '' }}.merge input

    if data[:user]
      data[:with][:email] = data[:user].email
      data[:with][:pw]    = data[:user].password
    end

    fill_in "Email",      with: data[:with][:email]
    fill_in "Password",   with: data[:with][:pw]
  end  
# end