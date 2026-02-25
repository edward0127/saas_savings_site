require "rails_helper"

RSpec.describe "LandingPages", type: :request do
  describe "GET /solutions/:slug" do
    it "renders published landing pages" do
      landing_page = LandingPage.create!(
        slug: "trade-job-management",
        title: "Trade Job Management App | Tudouke",
        meta_description: "Improve job workflows for trades with a custom app.",
        hero_title: "Trade job management app",
        hero_subtitle: "Built for field teams and office coordination.",
        problem_title: "Where teams get stuck",
        solution_title: "What Tudouke builds",
        published: true
      )

      get solution_path(slug: landing_page.slug)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Trade job management app")
    end

    it "returns not found for unpublished landing pages" do
      landing_page = LandingPage.create!(
        slug: "private-page",
        title: "Private Page",
        meta_description: "Private",
        hero_title: "Private",
        hero_subtitle: "Private",
        problem_title: "Problem",
        solution_title: "Solution",
        published: false
      )

      get solution_path(slug: landing_page.slug)

      expect(response).to have_http_status(:not_found)
    end
  end
end
