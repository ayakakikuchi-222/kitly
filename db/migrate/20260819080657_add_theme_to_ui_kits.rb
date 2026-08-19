class AddThemeToUiKits < ActiveRecord::Migration[8.1]
  def change
    add_column :ui_kits, :theme, :string
  end
end
