class UiKit < ApplicationRecord
  belongs_to :user
  has_many :components

  validates :name, presence: true
  validates :description, presence: true
end
