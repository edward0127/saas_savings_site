class LandingPage < ApplicationRecord
  SLUG_FORMAT = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

  validates :slug, presence: true, uniqueness: true, format: { with: SLUG_FORMAT }
  validates :title, :meta_description, :hero_title, :hero_subtitle, :problem_title, :solution_title, presence: true
  validates :meta_description, length: { maximum: 180 }

  before_validation :normalize_slug

  scope :published, -> { where(published: true) }
  scope :recent_first, -> { order(created_at: :desc) }

  def problem_points_list
    multiline_to_array(problem_points)
  end

  def solution_points_list
    multiline_to_array(solution_points)
  end

  def cta_title_text
    cta_title.presence || "Get My Free Project Plan"
  end

  def cta_body_text
    cta_body.presence || "Tell us your goals and current setup. We will reply with practical next steps."
  end

  def structured_data(base_url)
    [
      {
        "@context": "https://schema.org",
        "@type": "WebPage",
        name: title,
        description: meta_description,
        url: "#{base_url}/solutions/#{slug}",
        about: target_keyword.presence || title,
        isPartOf: {
          "@type": "WebSite",
          name: "Tudouke",
          url: base_url
        }
      }
    ]
  end

  private

  def normalize_slug
    self.slug = slug.to_s.parameterize
  end

  def multiline_to_array(value)
    value.to_s.split(/\r?\n/).map(&:strip).reject(&:blank?)
  end
end
