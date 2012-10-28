class MicropostsController < ApplicationController
  before_filter :not_signed_in_users, only: [:create, :destroy]
  before_filter :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = 'Micropost created'
      redirect_to root_url
    else
      @feed_items = feed_items
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to root_url
  end

  private

    def correct_user
      @micropost = current_user.microposts.find(params[:id])
      rescue        
        redirect_to root_url  
    end

end