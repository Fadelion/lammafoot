class TwilioService
  def initialize
    @client = Twilio::REST::Client.new
    @from_number = Rails.application.credentials.dig(:twilio, :phone_number) || ENV["TWILIO_PHONE_NUMBER"]
  end

  def send_sms(to:, message:)
    return false unless @from_number

    begin
      @client.messages.create(
        from: @from_number,
        to: to,
        body: message
      )
      true
    rescue Twilio::REST::RestError => e
      Rails.logger.error "Twilio SMS Error: #{e.message}"
      false
    end
  end

  def send_booking_confirmation_sms(booking)
    return false unless booking.user.phone_number.present?

    message = "Bonjour #{booking.user.first_name}, votre réservation pour #{booking.stadium.name} le #{booking.start_date.strftime('%d/%m/%Y à %H:%M')} est confirmée. Merci de votre confiance !"

    send_sms(to: booking.user.phone_number, message: message)
  end

  def send_booking_reminder_sms(booking)
    return false unless booking.user.phone_number.present?

    message = "Rappel: Votre match au #{booking.stadium.name} est prévu demain à #{booking.start_date.strftime('%H:%M')}. À bientôt !"

    send_sms(to: booking.user.phone_number, message: message)
  end
end
