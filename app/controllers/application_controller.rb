class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def feed_items
      signed_in? ? current_user.feed.paginate(page: params[:page], per_page: 10) : []
  end 
end
