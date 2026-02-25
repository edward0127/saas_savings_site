class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :company
      t.text :current_tools
      t.integer :monthly_spend
      t.text :message
      t.string :source_page

      t.timestamps
    end

    add_index :leads, :created_at
    add_index :leads, :email
  end
end
