class AddGeneratingToUiKits < ActiveRecord::Migration[8.1]
  def change
    # true while the AI is still creating a new kit's first components
    add_column :ui_kits, :generating, :boolean, default: false, null: false
  end
end
