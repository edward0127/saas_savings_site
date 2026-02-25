class Visit < ApplicationRecord
  validates :ip_address, presence: true, length: { maximum: 45 }
  validates :path, presence: true, length: { maximum: 255 }
  validates :http_method, presence: true, length: { maximum: 10 }
  validates :visitor_key, presence: true, length: { maximum: 64 }
  validates :occurred_at, presence: true

  scope :recent_first, -> { order(occurred_at: :desc) }
  scope :for_date, lambda { |date|
    where(occurred_at: date.beginning_of_day..date.end_of_day)
  }
  scope :humans, -> { where(bot: false) }

  def self.daily_counts(days:, bot: nil)
    window_start = days.to_i.days.ago.beginning_of_day
    relation = where(occurred_at: window_start..Time.current)
    relation = relation.where(bot: bot) unless bot.nil?

    relation.group(Arel.sql("DATE(occurred_at)"))
            .order(Arel.sql("DATE(occurred_at) DESC"))
            .count
  end
end
