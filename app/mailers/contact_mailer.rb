class ContactMailer < ActionMailer::Base
  default from: SydKik::FROM_EMAIL.freeze,
          return_path: "support@" + SydKik::DOMAIN_NAME.freeze

  def reset_password_instructions(record, token, _opts = {})
    @token = token
    @user = record

    mail(to: @user.email,
         subject: "Forgot Your Password?", brand: SydKik::DOMAIN_BRANDNAME)
  end

  def welcome_email(record, password = nil)
    @user = record
    @password = password

    mail(to: @user.email,
         subject: "Welcome to SydKik!", brand: SydKik::DOMAIN_BRANDNAME)
  end
end
