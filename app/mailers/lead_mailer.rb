class LeadMailer < ApplicationMailer
  def new_lead_notification
    @lead = params[:lead]
    app_setting = AppSetting.current
    mail_options = {
      to: app_setting.owner_notification_email,
      subject: "New Tudouke enquiry from #{@lead.name}"
    }
    smtp_settings = app_setting.smtp_settings
    mail_options[:delivery_method_options] = smtp_settings if smtp_settings.present?

    mail(mail_options)
  end
end
