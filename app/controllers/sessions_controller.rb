class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].strip.downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end    
  end

  def destroy
    sign_out
    flash[:success] = 'Bye bye'
    redirect_to root_path
  end  
end
