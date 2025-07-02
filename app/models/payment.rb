class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :booking

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
  validates :payment_method, presence: true
  validates :status, inclusion: { in: %w[pending completed failed refunded] }

  before_validation :set_default_status, on: :create

  def completed?
    status == "completed"
  end

  private

  def set_default_status
    self.status ||= "pending"
    self.payment_date ||= Time.current
  end
end
