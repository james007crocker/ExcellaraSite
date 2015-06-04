module JobPostingsHelper
  def getjob
    if !current_company.nil?
      @jobposting = current_company.job_postings.find_by(id: params[:id])
    else
      @jobposting = JobPosting.find_by(id: params[:id])
    end
  end

  def state(job_posting)
    applicant = job_posting.applicants.find_by(user_id: current_user.id)
    if applicant.nil?
      return "Apply"
    elsif applicant.userAccept && applicant.compAccept
      return "Match"
    elsif applicant.userreject
      return "Declined"
    else
      return "Pending"
    end
  end

  def increment_view_count(job)
    if job.views.nil?
      return 1
    else
      return job.views + 1
    end
  end

  def getCities
    return ["Abbotsford",
            "Barrie",
            "Brampton",
            "Burlington",
            "Burnaby", "Calgary",
            "Cambridge",
            "Cape Breton",
            "Chatham-Kent",
            "Coquitlam",
            "Edmonton",
            "Gatineau",
            "Guelph",
            "Halifax",
            "Hamilton",
            "Kingston",
            "Kitchener",
            "Laval",
            "Levis",
            "London",
            "Longueuil",
            "Markham",
            "Mississauga",
            "Montreal",
            "Oakville",
            "Ontario",
            "Oshawa",
            "Ottawa",
            "Quebec City",
            "Regina",
            "Richmond",
            "Richmond Hill",
            "Saguenay",
            "Saskatoon",
            "Sherbrooke",
            "St. Catharines",
            "Sudbury",
            "Surrey",
            "Thunder Bay",
            "Toronto",
            "Trois-Rivieres",
            "Vancouver",
            "Vaughan",
            "Windsor",
            "Winnipeg"]
  end

  def getProvinces
    return ["AB",
    "BC",
    "MB",
    "NB",
    "NL",
    "NT",
    "NS",
    "NU",
    "ON",
    "PE",
    "QC",
    "SK",
    "YT"]
  end

  def getType
    return ["Law",
      "Finance",
      "Healthcare",
      "Other"]
  end

end

