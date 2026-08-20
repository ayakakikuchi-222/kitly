class AddUiKitRefToMessagesAndMakeComponentOptional < ActiveRecord::Migration[8.1]
  def change
    add_reference :messages, :ui_kit, foreign_key: true
    change_column_null :messages, :component_id, true
  end
end
