class Stadium < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, :location, :price, :capacity, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }

  def average_rating
    reviews.average(:rating) || 0
  end
end
