class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :ui_kits, dependent: :destroy
  has_many :components, through: :ui_kits

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true

  after_create :create_example_kit

  private

  def create_example_kit
    ui_kits.create(
      name: "Corporate (example)",
      description: "This is what a Kitly kit looks like — make your first one!",
      image_url: "placeholder.png"
    )
  end
end
