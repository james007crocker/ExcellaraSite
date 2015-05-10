module CompaniesHelper
  def CompanyProfileIsComplete?
    if current_company.nil?
      return false
    end

    if current_company.website.blank? || current_company.location.blank? || current_company.size.blank? || current_company.description.blank?
      return false
    else
      return true
    end
  end
end
