class BookingReminderJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking && booking.status == "confirmed"

    # Envoyer un rappel SMS
    TwilioService.new.send_booking_reminder_sms(booking)

    # Envoyer un rappel par email
    BookingMailer.booking_reminder(booking).deliver_now
  end
end
