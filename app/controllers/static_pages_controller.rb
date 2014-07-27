class StaticPagesController < ApplicationController
  def home
    @users = User.all
    @posts_latest = Post.latest 25
  end

  def analytics
  end

end
