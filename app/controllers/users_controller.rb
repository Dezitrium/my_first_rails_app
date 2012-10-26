class UsersController < ApplicationController
  before_filter :not_signed_in_users, only: [:edit, :update, :index, :destroy]
  before_filter :signed_in_users, only: [:new, :create]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else      
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])      
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page], per_page:15)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private 

    def not_signed_in_users
      return if signed_in?
      store_location
      redirect_to signin_url, notice:'Please sign in'       
    end

    def signed_in_users
      return unless signed_in?
      redirect_to root_url, notice:"Can't create more accounts"
    end

    def correct_user
      user = User.find(params[:id])
      redirect_to root_url, notice:"Can't edit other users" unless current_user?(user)
    end

    def admin_user
      if current_user.admin?
        user = User.find(request.path_parameters[:id])
        message = "Can't delete other admins" if user.admin?        
      else
        message = "Can't delete other users"
      end
      redirect_to root_url, notice: message if message
    end

end
