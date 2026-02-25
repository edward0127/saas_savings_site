require "digest"

module Admin
  class BaseController < ApplicationController
    before_action :authenticate!

    private

    def authenticate!
      expected_user = ENV["ADMIN_USER"].presence
      expected_password = ENV["ADMIN_PASS"].presence

      if expected_user.blank? || expected_password.blank?
        if Rails.env.production?
          Rails.logger.error("Missing ADMIN_USER or ADMIN_PASS for admin authentication")
          head :unauthorized
          return
        end

        expected_user ||= "admin"
        expected_password ||= "change-me"
      end

      authenticate_or_request_with_http_basic("Admin") do |username, password|
        secure_compare(username, expected_user) && secure_compare(password, expected_password)
      end
    end

    def secure_compare(left, right)
      ActiveSupport::SecurityUtils.secure_compare(
        Digest::SHA256.hexdigest(left.to_s),
        Digest::SHA256.hexdigest(right.to_s)
      )
    end
  end
end
