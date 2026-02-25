class SitemapsController < ApplicationController
  def show
    @paths = [
      root_path,
      how_it_works_path,
      what_we_replace_path,
      faq_path,
      pricing_path,
      about_path,
      contact_path,
      privacy_path,
      terms_path
    ]
    @paths.concat(landing_page_paths)

    expires_in 12.hours, public: true
  end

  private

  def landing_page_paths
    return [] unless ActiveRecord::Base.connection.data_source_exists?("landing_pages")

    LandingPage.published.pluck(:slug).map { |slug| solution_path(slug:) }
  rescue StandardError
    []
  end
end
