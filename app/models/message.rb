class Message < ApplicationRecord
  belongs_to :component

  validates :content, presence: true
  validates :role, presence: true
end
