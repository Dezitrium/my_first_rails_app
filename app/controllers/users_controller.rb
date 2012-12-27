class UsersController < ApplicationController
  before_filter :not_signed_in_users, only: [:edit, :update, :index, :destroy, :following, :followers]
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
    @users = []
    # @paginated_users = paginate_users(@users) # TODO: decide to use pagination
    @microposts = paginate_microposts(@user.microposts)
    @active_tab = :microposts

    @title = @user.name
  end

  def index
    @users = User.paginate(page: params[:page], per_page:15)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @user = User.find(params[:id])
    @users = @user.followed_users
    #@paginated_users = paginate_users(@users) # TODO: decide to use pagination
    @microposts = paginate_microposts(@user.microposts)

    @sub_h3 = 'Following'
    @title = "#{@user.name} - #{@sub_h3}"
    @active_tab = :microposts

    render 'show'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    #@paginated_users = paginate_users(@users) # TODO: decide to use pagination
    @microposts = paginate_microposts(@user.microposts)

    @sub_h3 = 'Followers'
    @title = "#{@user.name} - #{@sub_h3}"
    @active_tab = :microposts

    render 'show'
  end

  private     

    def signed_in_users
      return unless signed_in?
      redirect_to root_url, notice: "Can't create more accounts"
    end

    def correct_user
      user = User.find(params[:id])
      redirect_to root_url, notice: "Can't edit other users" unless current_user?(user)
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

    # def paginate_users(users)
    #   users && users.any? ? users.paginate(page: params[:follows_page], per_page: 5) : []
    # end

end
