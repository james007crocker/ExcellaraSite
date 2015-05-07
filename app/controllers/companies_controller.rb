class CompaniesController < ApplicationController
  before_action :logged_in_company, only: [:edit, :update, :destroy, :activity]
  before_action :correct_company, only: [:edit, :update]
  before_action :can_view_profile, only: [:show]

  def new
    @company = Company.new
  end

  def show
    @company = Company.find(params[:id])
    if current_company?(@company)
      @apps = []
      appsMatchUser = Applicant.where("company_id = ?", @company.id)
      appsMatchUser.each do |f|
        if Time.now - f.updated_at < 7.days
          @apps << f
        end
      end
    end
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      @company.send_activation_email
      flash[:success] = "An account activation email has been sent to you. Please follow the link in this email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update_attribute(:location, params[:company][:location])
      @company.update_attribute(:size, params[:company][:size])
      @company.update_attribute(:description, params[:company][:description])
      @company.update_attribute(:picture, params[:company][:picture])
      @company.update_attribute(:website, params[:company][:website])
      flash.now[:success] = "Profile Updated"
      redirect_to @company
    else
      render 'edit'
    end
  end

  def activity
    @company = current_company
    @apps = Applicant.where("company_id = ?", @company.id)
    @pending = @apps.where("userAccept = ? and compAccept = ?", "f", "t")
    @required  = @apps.where("userAccept = ? and compAccept = ?", "t", "f")
    @matched = @apps.where("userAccept = ? and compAccept = ?", "t", "t")
  end

  private

  def company_params
    params.require(:company).permit(:name, :email, :location, :website, :description, :size, :password, :password_confirmation)
  end

  def logged_in_company
    unless company_logged_in?
      store_location
      flash[:danger] = "Please Log In"
      redirect_to login_url
    end
  end

  def correct_company
    @company = Company.find(params[:id])
    unless current_company?(@company)
      flash[:danger] = "You do not have permission to view this profile."
      redirect_to(root_url)
    end
  end

  def can_view_profile
    if current_user.nil?
      @company = Company.find_by_id(params[:id])
      if (@company.nil? || (!current_company?(@company) && !@company.nil?))
        flash[:danger] = "You do not have permission to view this page."
        redirect_to(root_url)
      end
    end
  end
end
