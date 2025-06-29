class Review < ApplicationRecord
  belongs_to :user
  belongs_to :stadium

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true
  validates :user_id, uniqueness: { scope: :stadium_id, message: "has already reviewed this stadium" }

  validate :user_has_booked_stadium

  private

  def user_has_booked_stadium
    unless user.bookings.where(stadium_id: stadium_id, status: "completed").exists?
      errors.add(:base, "You can only review stadiums you have booked and used")
    end
  end
end
