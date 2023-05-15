class UsersController < ApplicationController

  before_action :set_user
  before_action :require_signin, except:[:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.not_admins
  end

  def show
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thank you for registering"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account succesfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    #session[:user_id] = nil
    redirect_to root_url, status: :see_other, alert: "Account succesfully deleted!"
  end

  private

    def user_params
      params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
    end

    def require_correct_user
      redirect_to root_url, status: :see_other unless current_user?(@user)
    end

    def set_user
      @user = User.find_by!(username: params[:id])
    end


end
