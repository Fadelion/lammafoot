class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking
  before_action :authorize_payment_owner
  before_action :set_payment, only: [ :show ]

  def new
    @payment = @booking.payment || Payment.new(booking: @booking, user: current_user, amount: @booking.total_price)
    @stripe_publishable_key = Rails.application.config.stripe[:publishable_key]
  end

  def create
    if params[:payment_method] == "stripe"
      create_stripe_checkout
    else
      create_traditional_payment
    end
  end

  def stripe_success
    session_id = params[:session_id]
    return redirect_to new_booking_payment_path(@booking), alert: "Session ID manquant." if session_id.blank?

    begin
      stripe_service = StripeService.new
      session = stripe_service.retrieve_session(session_id)

      if session.payment_status == "paid"
        process_successful_payment(session_id)
      else
        redirect_to new_booking_payment_path(@booking), alert: "Le paiement n'a pas été complété."
      end
    rescue => e
      Rails.logger.error "Stripe success error: #{e.message}"
      redirect_to new_booking_payment_path(@booking), alert: "Erreur de paiement Stripe."
    end
  end

  def stripe_cancel
    redirect_to new_booking_payment_path(@booking), alert: "Paiement annulé."
  end

  def show
  end

  private

  def create_stripe_checkout
    begin
      stripe_service = StripeService.new
      session = stripe_service.create_checkout_session(@booking)
      Rails.logger.info "Stripe session created: #{session.id}"
      
      redirect_to session.url, allow_other_host: true
    rescue => e
      Rails.logger.error "Stripe checkout error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      redirect_to new_booking_payment_path(@booking), alert: "Erreur: #{e.message}"
    end
  end

  def process_successful_payment(session_id)
    @payment = @booking.payment || Payment.new(booking: @booking, user: current_user)
    @payment.assign_attributes(
      amount: @booking.total_price,
      payment_method: "stripe",
      status: "completed",
      payment_date: Time.current,
      stripe_session_id: session_id
    )

    if @payment.save
      @booking.update!(status: "confirmed")
      BookingMailer.payment_confirmation(@payment).deliver_now
      TwilioService.new.send_booking_confirmation_sms(@booking)
      redirect_to booking_path(@booking), notice: "Paiement réussi ! Votre réservation est confirmée."
    else
      redirect_to new_booking_payment_path(@booking), alert: "Erreur lors de l'enregistrement du paiement."
    end
  end

  def create_traditional_payment
    @payment = Payment.new(payment_params)
    @payment.booking = @booking
    @payment.user = current_user
    @payment.amount = @booking.total_price
    @payment.payment_date = Time.current
    @payment.status = "pending"

    if @payment.save
      @booking.update(status: "confirmed")
      BookingMailer.payment_confirmation(@payment).deliver_now
      TwilioService.new.send_booking_confirmation_sms(@booking)
      redirect_to booking_path(@booking), notice: "Paiement enregistré avec succès. Un email de confirmation vous a été envoyé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def set_payment
    @payment = @booking.payment
    redirect_to new_booking_payment_path(@booking), alert: "Aucun paiement trouvé pour cette réservation." unless @payment
  end

  def authorize_payment_owner
    unless @booking.user == current_user || current_user.role == "admin"
      redirect_to bookings_path, alert: "You are not authorized to access this payment."
    end
  end

  def payment_params
    params.require(:payment).permit(:payment_method)
  end
end
