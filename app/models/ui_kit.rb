class UiKit < ApplicationRecord
  belongs_to :user
  has_many :components, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
end
