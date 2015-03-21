class CompaniesController < ApplicationController
  before_action :logged_in_company, only: [:edit, :update]
  before_action :correct_company, only: [:edit, :update]

  def new
    @company = Company.new
  end

  def show
    @company = Company.find(params[:id])
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      @company.send_activation_email
      flash[:info] = "An account activation email has been sent to you."
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
      flash.now[:success] = "Profile Updated"
      redirect_to @company
    else
      render 'edit'
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :email, :location, :description, :size, :password, :password_confirmation)
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
end
