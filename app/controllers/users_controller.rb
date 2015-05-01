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
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.find(params[:id])
    if current_user?(@user)
      @apps = Applicant.where("user_id = ?", @user.id)
    elsif current_company
      @job_array = []
      @app_array = []
      comp_jobs = current_company.job_postings
      comp_jobs.each do |comp_job|
          add = 1
          job_apps = comp_job.applicants
          job_apps.each do |job_app|
            if job_app.user_id == @user.id
              add = 0
            end
          end
          if add == 1
            @job_array << comp_job
          else
            @app_array << comp_job.applicants.find_by(user_id: @user.id)
          end
      end
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "An account activation email has been sent to you. Please follow the link in this email to activate your account."
      redirect_to root_url
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
      @user.update_attribute(:picture, params[:user][:picture])
      flash.now[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :location, :experience, :accomplishment, :password, :password_confirmation, :picture)
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
        flash[:danger] = "You do not have permission to view this page."
        redirect_to(root_url)
      end
    end

    def can_view_profile
      if current_company.nil?
        @user = User.find_by_id(params[:id])
        if (@user.nil? || (!current_user?(@user) && !@user.nil?))
          flash[:danger] = "You do not have permission to view this page."
          redirect_to(root_url)
        end
      end
    end
end

