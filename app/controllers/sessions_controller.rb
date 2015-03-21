class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #Log user in
      if user.activated?
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
          redirect_back_or company
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
end
