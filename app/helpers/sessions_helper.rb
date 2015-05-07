module SessionsHelper
  #User methods
  def user_log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        user_log_in user
        @current_user = user
      end
    end
  end

  def current_user_has_resume?
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
      return !(@current_user.resume.nil?)
    else
      return false
    end
  end

  def current_user?(user)
      user == current_user
  end

  def user_logged_in?
    !current_user.nil?
  end

  def user_log_out
    forget_user(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember_user(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget_user(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  #Company methods ------------------------------------------------------
  def company_log_in(company)
    session[:company_id] = company.id
  end

  def current_company
    if (company_id = session[:company_id])
      @current_company ||= Company.find_by(id: session[:company_id])
    elsif (company_id = cookies.signed[:company_id])
      company = Company.find_by(id: company_id)
      if company && company.authenticated?(cookies[:remember_token])
        company_log_in company
        @current_company = company
      end
    end
  end

  def current_company?(company)
    company == current_company
  end

  def company_logged_in?
    !current_company.nil?
  end

  def company_log_out
    forget_company(current_company)
    session.delete(:company_id)
    @current_company = nil
  end

  def remember_company(company)
    company.remember
    cookies.permanent.signed[:company_id] = company.id
    cookies.permanent[:remember_token] = company.remember_token
  end

  def forget_company(company)
    company.forget
    cookies.delete(:company_id)
    cookies.delete(:remember_token)
  end

  #Misc
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end


  #Display text without letters wrecked --------------------------

  def make_paragraph(text, number)
    if text.blank?
      return text
    end
    paragraph = ""
    textA = text.gsub(/\s+/m, ' ').strip.split(" ")
    i = 0
    j = 0
    while i < textA.size
      j += textA[i].size
      paragraph += " " + textA[i]
      if i + 1  < textA.size && j + textA[i + 1].size > number
        j = 0
        paragraph += "\n"
      end
      i += 1
    end
    return paragraph
  end

end
