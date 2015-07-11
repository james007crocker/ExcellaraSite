class SessionsController < ApplicationController

  def new
  end

  def create
    if env["omniauth.auth"].nil?
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        #Log user in
        if user.activated? && user.uid.nil?
          user_log_in user
          params[:session][:remember_me] == '1' ? remember_user(user) : forget_user(user)
          redirect_back_or user
        else
          message = "Account not activated. "
          message += "Check your email for activation link."
          flash[:warning] = message
          redirect_to root_url
        end
      else
        company = Company.find_by(email: params[:session][:email].downcase)
        if company && company.authenticate(params[:session][:password])
          #log in company
          if company.activated?
            company_log_in company
            params[:session][:remember_me] == '1' ? remember_company(company) : forget_company(company)
            if company.admin == true
              redirect_to adminportal_companies_path
            else
              redirect_back_or company
            end
          else
            message = "Account not activated. "
            message += "Check your email for activation link."
            flash[:warning] = message
            redirect_to root_url
          end
        else
          flash.now[:danger] = "Invalid email/password combination"
          render 'new'
        end
      end
    else

      user = User.find_by(email: env["omniauth.auth"]["info"]["email"])
      if user && user.uid.nil?
        flash[:warning]  = "An account has already been created for this email"
        redirect_to root_path
      elsif user && !user.uid.nil?
        #log in user
        user_log_in user
        redirect_back_or user
      elsif Company.find_by(email: env["omniauth.auth"]["info"]["email"])
        flash[:warning]  = "An account has already been created for this email"
        redirect_to root_path
      else
        #No account created yet
        user = User.from_omniauth(env["omniauth.auth"])
        user_log_in user
        redirect_to edit_user_path(user)
      end
    end
  end

  def destroy
    if current_user
      user_log_out if user_logged_in?
      redirect_to root_url
    elsif current_company
      company_log_out if company_logged_in?
      redirect_to root_url
    end
  end

  private
    def can_view_pages
      if current_company
        unless CompanyProfileIsComplete?
          flash[:danger] = "Please complete your profile before proceeding"
          redirect_to edit_company_path(current_company)
        end
      elsif current_user
        unless UserProfileIsComplete?
          flash[:danger] = "Please complete your profile before proceeding"
          redirect_to edit_user_path(current_user)
        end
      end
    end

end
