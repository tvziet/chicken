# Note: This controller is used to verify the user account
# Because the user account is verified by the user clicking on the link sent to their email,
# we can not pass the headers to the request to determine version of the API to use.
# This is why we have to create a separate controller to handle the verification of the user account.
class UserVerificationsController < ApplicationController
  def verify_user
    user = User.find_by(confirmation_token: params[:confirmation_token])

    user&.update(is_verified: true, confirmation_token: nil)

    subject = if user.is_verified
      I18n.t('controllers.user_verifications.verify_user.success')
    else
      I18n.t('conntrollers.user_verifications.verify_user.failure')
    end
    UserMailer.with(user: user).account_verification(subject).deliver_later
  end
end
