class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def show
    @company = Company.find(params[:id])
  end

  def create
    @company = Company.new(user_params)
    if @company.save
      company_log_in @company
      flash[:success] = "Welcome to Excellara!"
      redirect_to @company
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:company).permit(:name, :email, :location, :description, :size, :password, :password_confirmation)
  end
end
