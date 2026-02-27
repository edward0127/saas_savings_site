require "ipaddr"

class ClientIpResolver
  CGNAT_RANGE = IPAddr.new("100.64.0.0/10")
  EMPTY_IPV4 = IPAddr.new("0.0.0.0")
  EMPTY_IPV6 = IPAddr.new("::")
  HEADER_PRIORITY = [
    "HTTP_CF_CONNECTING_IP",
    "HTTP_TRUE_CLIENT_IP",
    "HTTP_X_REAL_IP",
    "HTTP_X_FORWARDED_FOR",
    "HTTP_FORWARDED"
  ].freeze

  class << self
    def call(request)
      new(request).call
    end
  end

  def initialize(request)
    @request = request
  end

  def call
    normalized = raw_candidates.filter_map { |candidate| normalize_ip(candidate) }.uniq
    return "" if normalized.empty?

    normalized.find { |ip| public_ip?(ip) } || normalized.first
  end

  private

  attr_reader :request

  def raw_candidates
    header_values = HEADER_PRIORITY.flat_map { |header| parse_header_value(request.get_header(header)) }
    header_values + [ request.remote_ip, request.ip ]
  end

  def parse_header_value(value)
    return [] if value.blank?

    value.to_s.split(",").flat_map { |token| parse_forwarded_token(token) }
  end

  def parse_forwarded_token(token)
    stripped = token.to_s.strip
    return [] if stripped.blank?
    return [ stripped ] unless stripped.include?("for=")

    stripped.split(";").filter_map do |part|
      key, raw_value = part.split("=", 2)
      next unless key.to_s.strip.casecmp("for").zero?

      raw_value.to_s.strip.delete_prefix("\"").delete_suffix("\"")
    end
  end

  def normalize_ip(candidate)
    value = candidate.to_s.strip
    return nil if value.blank? || value.casecmp("unknown").zero?

    host =
      if value.start_with?("[") && value.include?("]")
        value[/\A\[([^\]]+)\](?::\d+)?\z/, 1]
      elsif value.match?(/\A\d{1,3}(?:\.\d{1,3}){3}:\d+\z/)
        value.split(":", 2).first
      else
        value
      end

    IPAddr.new(host).to_s
  rescue IPAddr::InvalidAddressError
    nil
  end

  def public_ip?(ip)
    addr = IPAddr.new(ip)
    return false if addr.private? || addr.loopback? || addr.link_local?
    return false if cgnat?(addr) || unspecified?(addr)

    true
  end

  def cgnat?(addr)
    addr.ipv4? && CGNAT_RANGE.include?(addr)
  end

  def unspecified?(addr)
    addr == EMPTY_IPV4 || addr == EMPTY_IPV6
  end
end
