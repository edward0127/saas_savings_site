require "rails_helper"

RSpec.describe "Admin::Leads", type: :request do
  around do |example|
    previous_user = ENV["ADMIN_USER"]
    previous_pass = ENV["ADMIN_PASS"]
    ENV["ADMIN_USER"] = "admin"
    ENV["ADMIN_PASS"] = "secret123"
    example.run
  ensure
    ENV["ADMIN_USER"] = previous_user
    ENV["ADMIN_PASS"] = previous_pass
  end

  let(:auth_header) do
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials("admin", "secret123")
    { "HTTP_AUTHORIZATION" => credentials }
  end

  describe "authentication" do
    it "requires HTTP basic auth" do
      get admin_leads_path

      expect(response).to have_http_status(:unauthorized)
    end

    it "allows access with valid credentials" do
      get admin_leads_path, headers: auth_header

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/leads/export.csv" do
    it "returns CSV export with lead data" do
      Lead.create!(name: "Sam", email: "sam@example.com", source_page: "/contact")

      get export_admin_leads_path(format: :csv), headers: auth_header

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")
      expect(response.body).to include("sam@example.com")
      expect(response.body).to include("name,email")
    end
  end
end
