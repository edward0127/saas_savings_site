require "rails_helper"

RSpec.describe Visit, type: :model do
  subject(:visit) do
    described_class.new(
      ip_address: "203.0.113.1",
      path: "/contact",
      http_method: "GET",
      visitor_key: "abc123",
      occurred_at: Time.current
    )
  end

  it "is valid with required attributes" do
    expect(visit).to be_valid
  end

  it "requires a path" do
    visit.path = nil

    expect(visit).not_to be_valid
    expect(visit.errors[:path]).to be_present
  end

  it "filters by date" do
    today_visit = described_class.create!(ip_address: "203.0.113.2", path: "/", http_method: "GET", visitor_key: "v1", occurred_at: Time.current)
    described_class.create!(ip_address: "203.0.113.3", path: "/", http_method: "GET", visitor_key: "v2", occurred_at: 2.days.ago)

    expect(described_class.for_date(Date.current)).to include(today_visit)
    expect(described_class.for_date(Date.current).count).to eq(1)
  end
end
