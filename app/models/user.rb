class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :role, inclusion: { in: %w[admin user] }, allow_nil: true

  before_create :set_default_role

  def admin?
    role == "admin"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def set_default_role
    self.role ||= "user"
  end
end
