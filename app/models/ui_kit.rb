class UiKit < ApplicationRecord
  belongs_to :user
  has_many :components, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  def context
    "You are an expert frontend designer that is a master of HTML and CSS. You are creating a new UI component with a user definined theme with the (ui_kit_id: #{id}) called #{name} with a description of #{description}"
  end
end
