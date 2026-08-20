class Message < ApplicationRecord
  belongs_to :component, optional: true
  belongs_to :ui_kit, optional: true

  validates :content, presence: true
  # validates :role, presence: true
end
