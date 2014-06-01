class StaticPagesController < ApplicationController
  def home
    @users = User.all
    @crushes = Crush.all
  end

  def about
  end

end
