require "rails_helper"

RSpec.describe ClientIpResolver do
  FakeRequest = Struct.new(:headers, :remote_ip, :ip, keyword_init: true) do
    def get_header(name)
      headers[name]
    end
  end

  it "prefers CF-Connecting-IP when present" do
    request = FakeRequest.new(
      headers: { "HTTP_CF_CONNECTING_IP" => "203.0.113.10" },
      remote_ip: "172.17.0.1",
      ip: "172.17.0.1"
    )

    expect(described_class.call(request)).to eq("203.0.113.10")
  end

  it "selects the first public IP from X-Forwarded-For" do
    request = FakeRequest.new(
      headers: { "HTTP_X_FORWARDED_FOR" => "10.0.0.5, 8.8.8.8, 172.18.0.1" },
      remote_ip: "172.18.0.1",
      ip: "172.18.0.1"
    )

    expect(described_class.call(request)).to eq("8.8.8.8")
  end

  it "parses Forwarded header format" do
    request = FakeRequest.new(
      headers: { "HTTP_FORWARDED" => "for=198.51.100.23;proto=https;by=203.0.113.44" },
      remote_ip: "203.0.113.44",
      ip: "203.0.113.44"
    )

    expect(described_class.call(request)).to eq("198.51.100.23")
  end

  it "falls back to remote_ip when headers are missing" do
    request = FakeRequest.new(headers: {}, remote_ip: "203.0.113.60", ip: "203.0.113.60")

    expect(described_class.call(request)).to eq("203.0.113.60")
  end

  it "falls back to the first valid private address when only private IPs are present" do
    request = FakeRequest.new(
      headers: { "HTTP_X_FORWARDED_FOR" => "192.168.1.25, 172.18.0.1" },
      remote_ip: "172.18.0.1",
      ip: "172.18.0.1"
    )

    expect(described_class.call(request)).to eq("192.168.1.25")
  end
end
