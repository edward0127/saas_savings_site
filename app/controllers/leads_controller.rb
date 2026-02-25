class LeadsController < ApplicationController
  RATE_LIMIT_SECONDS = 20
  HONEYPOT_FIELD = :website

  def create
    @lead = Lead.new(filtered_lead_params)
    @lead.source_page = normalized_source_page

    if honeypot_triggered?
      render_success(status: :ok)
      return
    end

    if rate_limited?
      @lead.errors.add(:base, "Please wait a few seconds before sending another request.")
      render_form_errors(status: :too_many_requests)
      return
    end

    if @lead.save
      session[:last_lead_submission_at] = Time.current.to_i
      send_lead_notification(@lead)
      render_success(status: :created)
    else
      render_form_errors(status: :unprocessable_content)
    end
  end

  private

  def lead_params
    params.fetch(:lead, ActionController::Parameters.new).permit(
      :name,
      :email,
      :company,
      :current_tools,
      :monthly_spend,
      :message,
      :source_page
    )
  end

  def filtered_lead_params
    lead_params.except(:source_page)
  end

  def normalized_source_page
    lead_params[:source_page].to_s.first(255)
  end

  def honeypot_triggered?
    params[HONEYPOT_FIELD].present?
  end

  def rate_limited?
    last_submission = session[:last_lead_submission_at]
    last_submission.present? && Time.current.to_i - last_submission.to_i < RATE_LIMIT_SECONDS
  end

  def send_lead_notification(lead)
    return if AppSetting.current.owner_notification_email.blank?

    LeadMailer.with(lead: lead).new_lead_notification.deliver_now
  rescue StandardError => e
    Rails.logger.error("Lead notification failed: #{e.class} #{e.message}")
  end

  def render_success(status:)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("lead_form", partial: "leads/success"), status: status
      end
      format.html do
        redirect_to "#{contact_path}#audit-form", notice: "Thanks, your request has been received."
      end
    end
  end

  def render_form_errors(status:)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("lead_form", partial: "leads/form", locals: { lead: @lead }), status: status
      end
      format.html do
        set_meta(
          title: "Contact | Talk to Tudouke",
          description: "Tell us what you need and we will send a clear project plan in plain language."
        )
        render "pages/contact", status: status
      end
    end
  end
end
