class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def signup
  end

  def send_message
    @name = params[:name];
    @email = params[:email];
    @message = params[:message];
    UserMailer.message_email(@name, @email, @message).deliver_later
    flash[:success] = "Thank you for your message - we will get back to you shortly"
    redirect_to root_path
  end

end
