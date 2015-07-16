class CompaniesController < ApplicationController
  before_action :check_for_redirect, only: [:show]
  before_action :logged_in_company, only: [:edit, :update, :destroy, :activity]
  before_action :correct_company, only: [:edit, :update]
  before_action :can_view_profile, only: [:show]
  before_action :can_view_pages, only:  [:activity, :viewprofile]
  before_action :isadmin?, only: [:adminportal, :admincompanies, :adminjobs, :adminapplications]

  def new
    @company = Company.new
  end

  def show
    @company = Company.find(params[:id])
    if current_company?(@company)
      if @company.admin == true
        redirect_to adminportal_companies_path
      else

        if @company.completed == false
          @company.update_attribute(:completed, true)
        end

        #if @company.status == 2
          randomUsers = User.where(:status => 2).order("RANDOM()")
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
          #end
          #@apps = []
          #appsMatchUser = Applicant.where("company_id = ?", @company.id)
          #appsMatchUser.each do |f|
          #  if Time.now - f.updated_at < 7.days
          #    @apps << f
          #  end
          #end
        end

      end
    elsif current_user || current_company.admin == true
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


  def adminportal
    @Uincomplete = User.where(:completed => false).count
    @UApproved = User.where(:status => 2).count
    @UWait = User.where(:status => 1).count
    @UNew = User.where(:status => 0, :completed => true).count

    @Cincomplete = Company.where(:completed => false, :admin => false).count
    @Capproved = Company.where(:status => 2, :admin => false).count
    @Cwait = Company.where(:status => 1, :admin => false).count
    @Cnew = Company.where(:status => 0, :completed => true, :admin => false).count
  end

  def adminprofessionals
    if params[:delete] == "true"
      User.find_by(id: params[:user_id]).destroy
      #flash[:success] = "Professional Deleted"
    elsif params[:approve] == "true"
      User.find_by(id: params[:user_id]).update_attribute(:status, 2)
      #flash[:success] = "Professional Approved"
    elsif params[:waitlist] == "true"
      User.find_by(id: params[:user_id]).update_attribute(:status, 1)
      #flash[:success] = "Professional Approved"
    end
    @news = User.where(:status => 0, :completed => true).paginate(page: params[:news_page], per_page: 5)
    @waitlisteds = User.where(:status => 1).paginate(page: params[:waitlisteds_page], per_page: 5)
    @approveds = User.where(:status => 2).paginate(page: params[:approveds_page], per_page: 5)
    @notcompletes = User.where(:completed => false).paginate(page: params[:notcompletes_page], per_page: 5)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def admincompanies
    if params[:delete] == "true"
      Company.find_by(id: params[:user_id]).destroy
      #flash[:success] = "Professional Deleted"
    elsif params[:approve] == "true"
      Company.find_by(id: params[:user_id]).update_attribute(:status, 2)
      #flash[:success] = "Professional Approved"
    elsif params[:waitlist] == "true"
      Company.find_by(id: params[:user_id]).update_attribute(:status, 1)
      #flash[:success] = "Professional Approved"
    end

    @Cincompletes = Company.where(:completed => false, :admin => false).paginate(page: params[:notcompletes_page], per_page: 5)
    @Cnews = Company.where(:completed => true, :status => 0, :admin => false).paginate(page: params[:news_page], per_page: 5)
    @Cwaits = Company.where(:status => 1, :admin => false).paginate(page: params[:waitlisteds_page], per_page: 5)
    @Capproveds = Company.where(:status => 2, :admin => false).paginate(page: params[:approveds_page], per_page: 5)
  end

  def adminjobs
    if params[:delete] == "true"
      JobPosting.find_by(id: params[:job_id]).destroy
    end
    @jobs = JobPosting.all.order('created_at DESC').paginate(page: params[:jobs_page], per_page: 10) #This is temporary solution
  end

  def adminapplications
    @apps = Applicant.all.order('created_at DESC').paginate(page: params[:apps_page], per_page: 10) #This is temporary solution
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

    def isadmin?
      unless current_company && current_company.admin == true
        flash[:danger] = "You do not have permission to view this page."
        redirect_to root_url
      end
    end

end
