class CreateAppSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :app_settings do |t|
      t.string :owner_email, null: false
      t.string :mail_from_email, null: false
      t.string :smtp_address
      t.integer :smtp_port
      t.string :smtp_domain
      t.string :smtp_username
      t.string :smtp_password
      t.string :smtp_authentication
      t.boolean :smtp_enable_starttls, null: false, default: true

      t.timestamps
    end
  end
end
