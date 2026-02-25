module Admin
  class VisitsController < BaseController
    def index
      @days_window = allowed_window(params[:days])
      @selected_date = parse_date(params[:date]) || Date.current

      @daily_totals = Visit.daily_counts(days: @days_window)
      @daily_human_totals = Visit.daily_counts(days: @days_window, bot: false)

      visits_for_day = Visit.for_date(@selected_date)
      @total_hits = visits_for_day.count
      @human_hits = visits_for_day.humans.count
      @bot_hits = @total_hits - @human_hits
      @unique_visitors = visits_for_day.humans.select(:visitor_key).distinct.count

      @visitor_rows = visits_for_day.humans
                                  .select("visitor_key, ip_address, user_agent, COUNT(*) AS hits, MIN(occurred_at) AS first_seen_at, MAX(occurred_at) AS last_seen_at")
                                  .group(:visitor_key, :ip_address, :user_agent)
                                  .order(Arel.sql("hits DESC, last_seen_at DESC"))
                                  .limit(300)

      @top_paths = visits_for_day.humans
                                .group(:path)
                                .order(Arel.sql("COUNT(*) DESC"))
                                .limit(20)
                                .count
    end

    private

    def parse_date(value)
      return nil if value.blank?

      Date.iso8601(value)
    rescue ArgumentError
      nil
    end

    def allowed_window(value)
      candidate = value.to_i
      [ 7, 14, 30, 60, 90 ].include?(candidate) ? candidate : 30
    end
  end
end
