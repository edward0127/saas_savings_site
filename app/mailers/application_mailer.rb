class ApplicationMailer < ActionMailer::Base
  default from: -> { default_from_address }
  layout "mailer"

  private

  def default_from_address
    return ENV.fetch("MAIL_FROM_EMAIL", "no-reply@example.com") unless AppSetting.table_exists?

    AppSetting.current.mail_from_email
  end
end
