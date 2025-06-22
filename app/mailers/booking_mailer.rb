class BookingMailer < ApplicationMailer
  default from: 'noreply@foothall.com'

  def booking_confirmation(booking)
    @booking = booking
    @user = booking.user
    @stadium = booking.stadium
    
    mail(
      to: @user.email,
      subject: 'Confirmation de votre réservation - FootHall'
    )
  end

  def booking_cancelled(booking)
    @booking = booking
    @user = booking.user
    @stadium = booking.stadium
    
    mail(
      to: @user.email,
      subject: 'Annulation de votre réservation - FootHall'
    )
  end

  def payment_confirmation(payment)
    @payment = payment
    @booking = payment.booking
    @user = @booking.user
    @stadium = @booking.stadium
    
    mail(
      to: @user.email,
      subject: 'Confirmation de paiement - FootHall'
    )
  end
end