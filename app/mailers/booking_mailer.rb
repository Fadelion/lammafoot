class BookingMailer < ApplicationMailer
  def confirmation_email(booking)
    @booking = booking
    @user = booking.user
    @stadium = booking.stadium
    
    mail(
      to: @user.email,
      subject: "Confirmation de réservation - #{@stadium.name}"
    )
  end
  
  def cancellation_email(booking)
    @booking = booking
    @user = booking.user
    @stadium = booking.stadium
    
    mail(
      to: @user.email,
      subject: "Annulation de réservation - #{@stadium.name}"
    )
  end

  def payment_confirmation(payment)
    @payment = payment
    @booking = payment.booking
    @user = payment.user
    @stadium = @booking.stadium
    
    mail(
      to: @user.email,
      subject: "Confirmation de paiement - #{@stadium.name}"
    )
  end

  def booking_reminder(booking)
    @booking = booking
    @user = booking.user
    @stadium = booking.stadium
    
    mail(
      to: @user.email,
      subject: "Rappel de réservation - #{@stadium.name}"
    )
  end
end