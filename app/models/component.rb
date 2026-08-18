class Component < ApplicationRecord
  belongs_to :ui_kit
  has_many :messages

  validates :category, presence: true
  validates :html_code, presence: true
  validates :css_code, presence: true
end
