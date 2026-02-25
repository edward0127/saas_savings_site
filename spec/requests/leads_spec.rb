require "rails_helper"

RSpec.describe "Leads", type: :request do
  describe "POST /leads" do
    it "creates a lead successfully" do
      expect do
        post(
          leads_path,
          params: {
            lead: {
              name: "Taylor Johnson",
              email: "taylor@example.com",
              company: "Northwind",
              current_tools: "Notion, Airtable",
              monthly_spend: 1500,
              message: "Need a replacement plan.",
              source_page: "/contact"
            }
          },
          as: :turbo_stream
        )
      end.to change(Lead, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns validation errors for invalid input" do
      expect do
        post(
          leads_path,
          params: {
            lead: {
              name: "",
              email: "",
              source_page: "/contact"
            }
          },
          as: :turbo_stream
        )
      end.not_to change(Lead, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
