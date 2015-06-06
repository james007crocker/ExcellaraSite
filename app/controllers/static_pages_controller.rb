class StaticPagesController < ApplicationController
  def home
    loggedInHeadToHomePage
  end

  def help
    loggedInHeadToHomePage
  end

  def about
    loggedInHeadToHomePage
  end

  def contact
    loggedInHeadToHomePage
  end

  def signup
    loggedInHeadToHomePage
  end

  def how_it_works

  end

  def work

  end

  def volunteer

  end

  def send_message
    @name = params[:name];
    @email = params[:email];
    @message = params[:message];
    UserMailer.message_email(@name, @email, @message).deliver_later
    flash[:success] = "Thank you for your message - we will get back to you shortly"
    redirect_to root_path
  end

  private

    def loggedInHeadToHomePage
      if company_logged_in?
        redirect_to current_company
      elsif user_logged_in?
        redirect_to current_user
      end
    end
end
