require "rails_helper"

RSpec.describe "Admin::Visits", type: :request do
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

  it "requires HTTP basic auth" do
    get admin_visits_path

    expect(response).to have_http_status(:unauthorized)
  end

  it "shows traffic metrics for authenticated admin" do
    Visit.create!(
      ip_address: "203.0.113.10",
      path: "/",
      http_method: "GET",
      visitor_key: "visitor-1",
      bot: false,
      occurred_at: Time.current
    )

    get admin_visits_path, headers: auth_header

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Traffic Overview")
    expect(response.body).to include("203.0.113.10")
  end
end
