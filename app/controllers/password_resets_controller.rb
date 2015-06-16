class PasswordResetsController < ApplicationController
  before_action :get_receiver, only: [:edit, :update]
  before_action :valid_receiver, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: (params[:password_reset][:email].downcase).strip)
    if @user && @user.uid.nil?
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      @company = Company.find_by(email: params[:password_reset][:email.downcase])
      if @company
        @company.create_reset_digest
        @company.send_password_reset_email
        flash[:success] = "Email sent with password reset instructions"
        redirect_to root_url
      else
        flash.now[:danger] = "Email address not found"
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    else
      if @receiver.kind_of? User
        if @receiver.update_attributes(receiver_params)
          user_log_in @receiver
          flash[:success] = "Password has been reset."
          redirect_to @receiver
        else
          render 'edit'
        end
      elsif @receiver.kind_of? Company
        if @receiver.update_attributes(receiver_params)
          company_log_in @receiver
          flash[:success] = "Password has been reset."
          redirect_to @receiver
        else
          render 'edit'
        end
      end
    end
  end

  private

    def get_receiver
      receiver1 = User.find_by(email: params[:email])
      receiver2 = Company.find_by(email: params[:email])
      @receiver = receiver1.nil? ? receiver2 : receiver1
    end

    def valid_receiver
      unless @receiver && @receiver.activated? && @receiver.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    def receiver_params
      if @receiver.kind_of? User
        params.require(:user).permit(:password, :password_confirmation)
      else
        params.require(:company).permit(:password, :password_confirmation)
      end
    end

    def password_blank?
      if @receiver.kind_of? User
        params[:user][:password].blank?
      else
        params[:company][:password].blank?
      end
    end

    def check_expiration
      if @receiver.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
