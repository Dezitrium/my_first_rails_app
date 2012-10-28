class MicropostsController < ApplicationController
  before_filter :not_signed_in_users, only: [:create, :destroy]

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
  end

end