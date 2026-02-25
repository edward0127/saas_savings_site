module Admin
  class LandingPagesController < BaseController
    before_action :set_landing_page, only: %i[edit update destroy]

    def index
      @landing_pages = LandingPage.recent_first
    end

    def new
      @landing_page = LandingPage.new(
        published: true,
        problem_title: "Common workflow problems",
        solution_title: "How Tudouke solves it",
        cta_title: "Get My Free Project Plan"
      )
    end

    def create
      @landing_page = LandingPage.new(landing_page_params)

      if @landing_page.save
        redirect_to admin_landing_pages_path, notice: "Landing page created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
    end

    def update
      if @landing_page.update(landing_page_params)
        redirect_to admin_landing_pages_path, notice: "Landing page updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @landing_page.destroy
      redirect_to admin_landing_pages_path, notice: "Landing page deleted."
    end

    private

    def set_landing_page
      @landing_page = LandingPage.find(params[:id])
    end

    def landing_page_params
      params.require(:landing_page).permit(
        :slug,
        :title,
        :meta_description,
        :target_keyword,
        :hero_title,
        :hero_subtitle,
        :intro,
        :problem_title,
        :problem_points,
        :solution_title,
        :solution_points,
        :cta_title,
        :cta_body,
        :published
      )
    end
  end
end
