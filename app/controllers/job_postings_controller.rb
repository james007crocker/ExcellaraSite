class JobPostingsController < ApplicationController

  def create
    @jobpostings = current_company.job_postings.build(job_posting_params)
    if @jobpostings.save
      flash[:success] = "Created new job posting"
      redirect_to job_postings_path
    else
      render 'new'
    end
  end

  def destroy
    if current_company
      current_company.job_postings.find_by(id: params[:id]).destroy
      flash[:success] = "Job Posting Removed"
      redirect_to job_postings_path
    else
      redirect_to root_url
    end
  end

  def new
    @jobpostings = JobPosting.new
  end

  def index
    @company = current_company
    @jobpostings = @company.job_postings.paginate(page: params[:page], per_page: 3)
  end

  def joblist
    @job_postings = JobPosting.paginate(page: params[:page], per_page: 10)
  end

  def show
    if !current_company.nil?
      @jobposting = current_company.job_postings.find_by(id: params[:id])
    else
      @jobposting = JobPosting.find_by(id: params[:id])
    end
  end

  private

    def job_posting_params
      params.require(:job_posting).permit(:title, :location, :description)
    end

end
