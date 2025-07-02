class Stadium < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, :location, :price, :capacity, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }

  def average_rating
    reviews.average(:rating) || 0
  end

  def available_at?(start_time, end_time)
    !bookings.where.not(status: "cancelled")
             .where("(start_date < ? AND end_date > ?) OR (start_date < ? AND end_date > ?) OR (start_date >= ? AND start_date < ?)",
                    end_time, start_time, start_time, end_time, start_time, end_time)
             .exists?
  end

  def total_bookings
    bookings.count
  end
end
