module CompaniesHelper
  def CompanyProfileIsComplete?
    if current_company.website.blank? || current_company.location.blank? || current_company.size.blank? || current_company.description.blank?
      return false
    end
    return true
  end
end
