require "digest"

class ApplicationController < ActionController::Base
  BOT_USER_AGENT_REGEX = /(bot|crawl|spider|slurp|bingpreview|facebookexternalhit|curl|wget|lighthouse|headless)/i

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :meta_title, :meta_description, :meta_image, :meta_robots, :canonical_url, :structured_data_items, :analytics_script_src

  before_action :set_default_meta
  after_action :track_visit

  private

  def set_default_meta
    @meta_title = "Tudouke | Fast, Affordable AI-Assisted Websites and Apps"
    @meta_description = "Tudouke helps non-technical businesses and individuals launch websites and apps faster with AI-assisted delivery and quality review."
    @meta_image = "#{request.base_url}/icon.png"
    @meta_robots = "index,follow,max-image-preview:large,max-snippet:-1,max-video-preview:-1"
    @canonical_url = "#{request.base_url}#{request.path}"
    @structured_data = base_structured_data
  end

  def set_meta(title:, description:, image: nil, robots: nil, canonical: nil, structured_data: nil)
    @meta_title = title
    @meta_description = description
    @meta_image = image if image.present?
    @meta_robots = robots if robots.present?
    @canonical_url = canonical if canonical.present?
    @structured_data = base_structured_data + Array(structured_data) if structured_data.present?
  end

  def meta_title
    @meta_title
  end

  def meta_description
    @meta_description
  end

  def meta_image
    @meta_image
  end

  def meta_robots
    @meta_robots
  end

  def canonical_url
    @canonical_url
  end

  def structured_data_items
    @structured_data
  end

  def analytics_script_src
    ENV["ANALYTICS_SCRIPT_SRC"].presence
  end

  def track_visit
    return unless trackable_visit_request?

    user_agent = request.user_agent.to_s
    ip_address = ClientIpResolver.call(request).presence || request.remote_ip.to_s

    Visit.create(
      ip_address: ip_address.first(45),
      path: request.path.to_s.first(255),
      http_method: request.request_method.to_s.first(10),
      user_agent: user_agent.first(2000),
      referer: request.referer.to_s.first(2000),
      visitor_key: Digest::SHA256.hexdigest("#{ip_address}|#{user_agent}"),
      bot: user_agent.match?(BOT_USER_AGENT_REGEX),
      occurred_at: Time.current
    )
  rescue StandardError => e
    Rails.logger.error("Visit tracking failed: #{e.class} #{e.message}")
  end

  def trackable_visit_request?
    return false unless request.get?
    return false unless request.format.html?
    return false if controller_path.start_with?("admin/")
    return false if request.path == "/up"
    return false if request.path.start_with?("/rails/active_storage")
    return false unless Visit.table_exists?

    true
  rescue StandardError
    false
  end

  def base_structured_data
    [
      {
        "@context": "https://schema.org",
        "@type": "Organization",
        name: "Tudouke",
        url: request.base_url,
        logo: "#{request.base_url}/icon.png",
        description: "AI-assisted website and app delivery focused on fast turnaround, stability, and competitive pricing."
      },
      {
        "@context": "https://schema.org",
        "@type": "WebSite",
        name: "Tudouke",
        url: request.base_url,
        inLanguage: "en",
        publisher: {
          "@type": "Organization",
          name: "Tudouke"
        }
      }
    ]
  end
end
