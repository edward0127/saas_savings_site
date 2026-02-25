class CreateLandingPages < ActiveRecord::Migration[8.1]
  def change
    create_table :landing_pages do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :meta_description, null: false
      t.string :target_keyword
      t.string :hero_title, null: false
      t.text :hero_subtitle, null: false
      t.text :intro
      t.string :problem_title, null: false
      t.text :problem_points
      t.string :solution_title, null: false
      t.text :solution_points
      t.string :cta_title
      t.text :cta_body
      t.boolean :published, null: false, default: true

      t.timestamps
    end

    add_index :landing_pages, :slug, unique: true
    add_index :landing_pages, :published
  end
end
