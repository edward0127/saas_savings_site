require "csv"

class Lead < ApplicationRecord
  EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP

  validates :name, presence: true, length: { maximum: 120 }
  validates :email, presence: true, format: { with: EMAIL_REGEX }, length: { maximum: 255 }
  validates :company, length: { maximum: 160 }, allow_blank: true
  validates :monthly_spend, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
  validates :source_page, length: { maximum: 255 }, allow_blank: true

  scope :recent_first, -> { order(created_at: :desc) }

  def self.to_csv
    columns = %w[id name email company current_tools monthly_spend message source_page created_at]

    CSV.generate(headers: true) do |csv|
      csv << columns

      recent_first.each do |lead|
        csv << columns.map { |column| lead.public_send(column) }
      end
    end
  end
end
