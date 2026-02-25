class LandingPagesController < ApplicationController
  def show
    @landing_page = LandingPage.published.find_by!(slug: params[:slug])

    set_meta(
      title: @landing_page.title,
      description: @landing_page.meta_description,
      structured_data: @landing_page.structured_data(request.base_url)
    )
  end
end
