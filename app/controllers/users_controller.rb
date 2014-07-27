class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  def show

    set_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
