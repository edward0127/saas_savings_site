class AppSetting < ApplicationRecord
  ENV_KEYS = {
    owner_email: "OWNER_EMAIL",
    mail_from_email: "MAIL_FROM_EMAIL",
    smtp_address: "SMTP_ADDRESS",
    smtp_port: "SMTP_PORT",
    smtp_domain: "SMTP_DOMAIN",
    smtp_username: "SMTP_USERNAME",
    smtp_password: "SMTP_PASSWORD",
    smtp_authentication: "SMTP_AUTHENTICATION",
    smtp_enable_starttls: "SMTP_ENABLE_STARTTLS"
  }.freeze

  DEFAULTS = {
    owner_email: "owner@example.com",
    mail_from_email: "no-reply@example.com",
    smtp_address: "",
    smtp_port: 587,
    smtp_domain: "",
    smtp_username: "",
    smtp_password: "",
    smtp_authentication: "plain",
    smtp_enable_starttls: true
  }.freeze

  validates :owner_email, :mail_from_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :smtp_port, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :smtp_authentication, inclusion: { in: %w[plain login cram_md5] }, allow_blank: true
  validate :smtp_configuration_is_complete

  before_validation :apply_defaults

  def self.current
    first || create!(default_attributes)
  end

  def self.default_attributes
    {
      owner_email: env_or_default(:owner_email),
      mail_from_email: env_or_default(:mail_from_email),
      smtp_address: env_or_default(:smtp_address),
      smtp_port: env_or_default(:smtp_port).to_i,
      smtp_domain: env_or_default(:smtp_domain),
      smtp_username: env_or_default(:smtp_username),
      smtp_password: env_or_default(:smtp_password),
      smtp_authentication: env_or_default(:smtp_authentication),
      smtp_enable_starttls: ActiveModel::Type::Boolean.new.cast(env_or_default(:smtp_enable_starttls))
    }
  end

  def owner_notification_email
    owner_email.presence || self.class.default_attributes[:owner_email]
  end

  def smtp_settings
    return {} unless smtp_configured?

    {
      address: smtp_address,
      port: smtp_port.to_i,
      domain: smtp_domain.presence || smtp_address,
      user_name: smtp_username,
      password: smtp_password,
      authentication: (smtp_authentication.presence || "plain").to_sym,
      enable_starttls_auto: smtp_enable_starttls?
    }
  end

  def smtp_configured?
    smtp_address.present? && smtp_port.present? && smtp_username.present? && smtp_password.present?
  end

  private

  def apply_defaults
    self.smtp_enable_starttls = true if smtp_enable_starttls.nil?
    attrs = self.class.default_attributes

    self.owner_email = attrs[:owner_email] if owner_email.blank?
    self.mail_from_email = attrs[:mail_from_email] if mail_from_email.blank?
    self.smtp_authentication = attrs[:smtp_authentication] if smtp_authentication.blank?
    self.smtp_port = attrs[:smtp_port] if smtp_port.blank?
  end

  def smtp_configuration_is_complete
    return unless smtp_fields_present?

    required = {
      smtp_address: "SMTP address",
      smtp_port: "SMTP port",
      smtp_domain: "SMTP domain",
      smtp_username: "SMTP username",
      smtp_password: "SMTP password"
    }

    required.each do |field, label|
      errors.add(field, "#{label} is required when SMTP is configured") if public_send(field).blank?
    end
  end

  def smtp_fields_present?
    smtp_address.present? || smtp_username.present? || smtp_password.present? || smtp_domain.present?
  end

  def self.env_or_default(key)
    ENV.fetch(ENV_KEYS.fetch(key), DEFAULTS.fetch(key))
  end
  private_class_method :env_or_default
end
