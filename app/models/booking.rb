class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :stadium
  has_one :payment, dependent: :destroy

  validates :start_date, :end_date, presence: true
  validates :status, inclusion: { in: %w[pending confirmed cancelled completed] }
  validate :end_date_after_start_date
  validate :no_overlapping_bookings, on: :create

  before_validation :set_default_status, on: :create
  after_update :schedule_reminder_if_confirmed

  scope :upcoming, -> { where("start_date > ?", Time.current) }
  scope :past, -> { where("end_date < ?", Time.current) }
  scope :current, -> { where("start_date <= ? AND end_date >= ?", Time.current, Time.current) }

  def duration_in_hours
    ((end_date - start_date) / 1.hour).round
  end

  def total_price
    duration_in_hours * stadium.price
  end

  def schedule_reminder
    # Programmer un rappel 24h avant la réservation
    reminder_time = start_date - 1.day
    return if reminder_time < Time.current

    BookingReminderJob.set(wait_until: reminder_time).perform_later(id)
  end

  private

  def schedule_reminder_if_confirmed
    if saved_change_to_status? && status == "confirmed"
      schedule_reminder
    end
  end

  def set_default_status
    self.status ||= "pending"
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date <= start_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def no_overlapping_bookings
    return if start_date.blank? || end_date.blank?

    overlapping_bookings = stadium.bookings
                                 .where.not(id: id)
                                 .where.not(status: "cancelled")
                                 .where("(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?) OR (start_date >= ? AND end_date <= ?)",
                                        end_date, start_date, start_date, start_date, start_date, end_date)

    if overlapping_bookings.exists?
      errors.add(:base, "The stadium is already booked during this time period")
    end
  end
end
