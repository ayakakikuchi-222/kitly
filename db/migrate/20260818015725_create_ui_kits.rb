class CreateUiKits < ActiveRecord::Migration[8.1]
  def change
    create_table :ui_kits do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
