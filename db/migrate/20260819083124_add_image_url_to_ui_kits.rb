class AddImageUrlToUiKits < ActiveRecord::Migration[8.1]
  def change
    add_column :ui_kits, :image_url, :string
  end
end
