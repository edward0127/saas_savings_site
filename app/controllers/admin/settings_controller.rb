module Admin
  class SettingsController < BaseController
    def edit
      @app_setting = AppSetting.current
    end

    def update
      @app_setting = AppSetting.current
      attributes = app_setting_params
      attributes = attributes.except(:smtp_password) if attributes[:smtp_password].blank?

      if @app_setting.update(attributes)
        redirect_to edit_admin_settings_path, notice: "Settings updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def app_setting_params
      params.require(:app_setting).permit(
        :owner_email,
        :mail_from_email,
        :smtp_address,
        :smtp_port,
        :smtp_domain,
        :smtp_username,
        :smtp_password,
        :smtp_authentication,
        :smtp_enable_starttls
      )
    end
  end
end
