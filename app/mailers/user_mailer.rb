class UserMailer < ApplicationMailer
  def verify_user
    @user = params[:user]
    @url = verification_url(confirmation_token: @user.confirmation_token)
    mail(to: @user.email, subject: 'Please verify your account')
  end

  def account_verification(subject)
    @user = params[:user]
    @subject = subject
    mail(to: @user.email, subject: @subject)
  end
end
