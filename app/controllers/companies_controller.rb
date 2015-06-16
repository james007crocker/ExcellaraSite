class CompaniesController < ApplicationController
  before_action :check_for_redirect, only: [:show]
  before_action :logged_in_company, only: [:edit, :update, :destroy, :activity]
  before_action :correct_company, only: [:edit, :update]
  before_action :can_view_profile, only: [:show]
  before_action :can_view_pages, only:  [:activity, :viewprofile]
  def new
    @company = Company.new
  end

  def show
    @company = Company.find(params[:id])
    if current_company?(@company)
      randomUsers = User.order("RANDOM()")
      @user1 = randomUsers.first
      @user2 = randomUsers.second
      @user3 = randomUsers.third

      if @company.totalalerts == 0
        @company.job_postings.each do |job|
          if job.matchcount > 0
            job.update_attribute(:matchcount, 0)
          end
          if job.offercount > 0
            job.update_attribute(:offercount, 0)
          end
        end
      end
      #@apps = []
      #appsMatchUser = Applicant.where("company_id = ?", @company.id)
      #appsMatchUser.each do |f|
      #  if Time.now - f.updated_at < 7.days
      #    @apps << f
      #  end
      #end
    elsif current_user
      @jobs = JobPosting.where(:company_id => @company.id)
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
    if @company.update(company_update_params)
      #update_attribute(:location, params[:company][:location])
      #@company.update_attribute(:size, params[:company][:size])
      #@company.update_attribute(:description, params[:company][:description])
      #@company.update_attribute(:picture, params[:company][:picture])
      #@company.update_attribute(:website, params[:company][:website])
      flash.now[:success] = "Profile Updated"
      redirect_to @company
    else
      render 'edit'
    end
  end

  def activity
    @company = current_company
    @company.update_attribute(:totalalerts, 0)
  end

  def viewprofile
    @company = Company.find(params[:id])
    @jobs = JobPosting.where(:company_id => @company.id)
    unless current_company?(@company)
      flash.now[:danger] = "You do not have permission to view this page"
      redirect_to root_url
    end
  end

  private

    def company_params
      params.require(:company).permit(:name, :email, :location, :province, :website, :description, :size, :password, :password_confirmation)
    end

    def company_update_params
      params.require(:company).permit(:location, :province, :website, :description, :size, :picture)
    end

    def check_for_redirect
      unless user_logged_in? || company_logged_in?
        store_location
        flash[:danger] = "Please Log In"
        redirect_to login_url
      end
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
      if !current_company.nil?
        if CompanyProfileIsComplete?
          #fine
        else
          flash[:danger] = "Please complete your profile before proceeding"
          redirect_to edit_company_path(current_company)
        end
      elsif !current_user.nil?
        if UserProfileIsComplete?
          #fine
        end
      else
        flash[:danger] = "You do not have permission to view this page."
        redirect_to(root_url)
      end
    end

    def can_view_pages
      unless CompanyProfileIsComplete?
        flash[:danger] = "Please complete your profile before proceeding"
        redirect_to edit_company_path(current_company)
      end
    end

end
