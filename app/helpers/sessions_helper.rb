module SessionsHelper
  #User methods
  def user_log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_logged_in?
    !current_user.nil?
  end

  def user_log_out
    session.delete(:user_id)
    @current_user = nil
  end

  #Company methods
  def company_log_in(company)
    session[:company_id] = company.id
  end

  def current_company
    @current_company ||= Company.find_by(id: session[:user_id])
  end

  def company_logged_in?
    !current_company.nil?
  end

  def company_log_out
    session.delete(:company_id)
    @current_company = nil
  end
end
