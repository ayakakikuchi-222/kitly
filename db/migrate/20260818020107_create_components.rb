class CreateComponents < ActiveRecord::Migration[8.1]
  def change
    create_table :components do |t|
      t.string :category
      t.text :html_code
      t.text :css_code
      t.references :ui_kit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
