class UsersController < ApplicationController
    def create
        @user = User.new(user_hash)
        @user.save!

        redirect_to @user
    end

    def show
        @user = User.find(params[:id])
    end

    def index
        @users = User.all
    end

    private

    def user_hash
        params.require(:user).permit(:points, :skill_id)
    end
end
