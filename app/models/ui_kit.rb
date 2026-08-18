class UiKit < ApplicationRecord
  belongs_to :user
  has_many :components, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
end
