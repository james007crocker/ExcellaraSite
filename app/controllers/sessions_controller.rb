class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #Log user in
      user_log_in user
      redirect_to user
    else
      company = Company.find_by(email: params[:session][:email].downcase)
      if company && company.authenticate(params[:session][:password])
        #log in company
        company_log_in company
        redirect_to company
      else
        flash.now[:danger] = "Invalid email/password combination"
        render 'new'
      end
    end
  end

  def destroy
    if current_user
      user_log_out
      redirect_to root_url
    elsif current_company
      company_log_out
      redirect_to root_url
    end
  end
end
