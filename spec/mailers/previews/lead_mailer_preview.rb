# Preview all emails at http://localhost:3000/rails/mailers/lead_mailer
class LeadMailerPreview < ActionMailer::Preview
  def new_lead_notification
    lead = Lead.new(
      name: "Preview User",
      email: "preview@example.com",
      company: "Preview Co",
      current_tools: "Helpdesk, booking app",
      monthly_spend: 1200,
      message: "Can you replace our booking and approval flow?",
      source_page: "/contact"
    )

    LeadMailer.with(lead: lead).new_lead_notification
  end
end
