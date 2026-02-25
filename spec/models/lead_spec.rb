require "rails_helper"

RSpec.describe Lead, type: :model do
  subject(:lead) do
    described_class.new(
      name: "Alex Rivera",
      email: "alex@example.com",
      company: "Rivera Ops",
      monthly_spend: 900
    )
  end

  it "is valid with required attributes" do
    expect(lead).to be_valid
  end

  it "requires a name" do
    lead.name = nil

    expect(lead).not_to be_valid
    expect(lead.errors[:name]).to be_present
  end

  it "requires an email" do
    lead.email = nil

    expect(lead).not_to be_valid
    expect(lead.errors[:email]).to be_present
  end

  it "rejects invalid email formats" do
    lead.email = "invalid-email"

    expect(lead).not_to be_valid
    expect(lead.errors[:email]).to be_present
  end

  it "rejects negative monthly spend" do
    lead.monthly_spend = -1

    expect(lead).not_to be_valid
    expect(lead.errors[:monthly_spend]).to be_present
  end
end
