module UsersHelper
  def UserProfileIsComplete?
    if current_user.nil?
      return false
    end

    if current_user.years.blank? || current_user.profession.blank? || current_user.experience.blank?
      return false
    else
      return true
    end
  end
end
