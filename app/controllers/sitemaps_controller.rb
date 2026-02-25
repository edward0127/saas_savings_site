class SitemapsController < ApplicationController
  def show
    @paths = [
      root_path,
      how_it_works_path,
      what_we_replace_path,
      pricing_path,
      about_path,
      contact_path,
      privacy_path,
      terms_path
    ]

    expires_in 12.hours, public: true
  end
end
