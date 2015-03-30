class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(receiver)
    @receiver = receiver

    mail to: receiver.email, subject: "Excellara Account Activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(receiver)
    @receiver = receiver

    mail to: receiver.email, subject: "Excellara Password Reset"
  end

  def match_email(sender, receiver, job, text)
    @receiver = receiver
    @sender = sender
    @job = job
    @text = text
    if @receiver.kind_of? User
      subject_string = "Excellara Match: " + @job.title + " at " + @sender.name
    else
      subject_string = "Excellara Match: " + @receiver.name + " for " + @job.title
    end
    mail to: receiver.email, subject: subject_string
  end
end
