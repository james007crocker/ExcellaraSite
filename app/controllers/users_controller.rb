class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :can_view_profile, only: [:show, :index]

  def new
    @user = User.new
  end

  def destroy
    if current_user.admin?
      User.find(params[:id]).destroy
      flash[:success] = "User Deleted"
      redirect_to users_url
    else
      redirect_to root_url
    end

  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      user_log_in @user
      flash[:success] = "Welcome to Excellara!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attribute(:location, params[:user][:location])
      @user.update_attribute(:accomplishment, params[:user][:accomplishment])
      @user.update_attribute(:experience, params[:user][:experience])
      flash.now[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :location, :experience, :accomplishment, :password, :password_confirmation)
    end

    def logged_in_user
      unless user_logged_in?
        store_location
        flash[:danger] = "Please Log In"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You do not have permission to view this profile."
        redirect_to(root_url)
      end
    end

    def can_view_profile
      if current_company.nil?
        @user = User.find_by_id(params[:id])
        if (@user.nil? || (!current_user?(@user) && !@user.nil?))
          flash[:danger] = "You do not have permission to view this profile."
          redirect_to(root_url)
        end
      end
    end
end

