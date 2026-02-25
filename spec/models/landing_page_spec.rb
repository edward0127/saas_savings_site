require "rails_helper"

RSpec.describe LandingPage, type: :model do
  subject(:landing_page) do
    described_class.new(
      slug: "custom-workflow-app",
      title: "Custom Workflow App | Tudouke",
      meta_description: "Build a custom workflow app for your business.",
      hero_title: "Custom workflow apps",
      hero_subtitle: "Built for your exact process.",
      problem_title: "Common issues",
      solution_title: "How we help"
    )
  end

  it "is valid with required attributes" do
    expect(landing_page).to be_valid
  end

  it "normalizes slug format" do
    landing_page.slug = "Custom Workflow App"
    landing_page.valid?

    expect(landing_page.slug).to eq("custom-workflow-app")
  end

  it "requires a unique slug" do
    described_class.create!(
      slug: "custom-workflow-app",
      title: "Existing",
      meta_description: "Existing page description",
      hero_title: "Hero",
      hero_subtitle: "Subtitle",
      problem_title: "Problem",
      solution_title: "Solution"
    )

    expect(landing_page).not_to be_valid
    expect(landing_page.errors[:slug]).to be_present
  end
end
