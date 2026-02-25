module Admin
  class LeadsController < BaseController
    before_action :set_lead, only: :show

    def index
      @leads = Lead.recent_first
    end

    def show
    end

    def export
      send_data(
        Lead.to_csv,
        filename: "leads-#{Time.current.strftime("%Y%m%d-%H%M%S")}.csv",
        type: "text/csv; charset=utf-8"
      )
    end

    private

    def set_lead
      @lead = Lead.find(params[:id])
    end
  end
end
