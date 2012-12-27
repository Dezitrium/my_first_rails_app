class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  private

    def feed_items
      signed_in? ? current_user.feed.paginate(page: params[:page], per_page: 20) : []
    end

    def paginate_microposts(posts)
      posts.paginate(page: params[:microposts_page], per_page: 20)
    end
end
