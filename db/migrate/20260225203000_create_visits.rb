class CreateVisits < ActiveRecord::Migration[8.1]
  def change
    create_table :visits do |t|
      t.string :ip_address, null: false
      t.string :path, null: false
      t.string :http_method, null: false
      t.text :user_agent
      t.text :referer
      t.string :visitor_key, null: false
      t.boolean :bot, null: false, default: false
      t.datetime :occurred_at, null: false

      t.timestamps
    end

    add_index :visits, :occurred_at
    add_index :visits, :visitor_key
    add_index :visits, :path
    add_index :visits, :bot
    add_index :visits, %i[occurred_at visitor_key]
  end
end
