# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation_user
    UserMailer.account_activation
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

  def match_email
    @receiver = Company.first
    @sender = User.first
    @job = JobPosting.first
    @text = nil
    @sendresume = "1"
    UserMailer.match_email(@sender, @receiver, @job, @text, @sendresume)
  end

end
