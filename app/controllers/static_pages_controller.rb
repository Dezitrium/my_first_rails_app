class StaticPagesController < ApplicationController
  include MicropostsHelper

  def home
    return unless signed_in?
    @micropost = current_user.microposts.build
    @feed_items = feed_items
  end

  def help
  end

  def about
  end

  def contact
  end

end
