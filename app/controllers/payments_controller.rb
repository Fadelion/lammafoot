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
    stripe_service = StripeService.new

    begin
      session = stripe_service.retrieve_session(session_id)

      if session.payment_status == "paid"
        @payment = @booking.payment || Payment.new(booking: @booking, user: current_user)
        @payment.amount = @booking.total_price
        @payment.payment_method = "stripe"
        @payment.status = "completed"
        @payment.payment_date = Time.current
        @payment.stripe_session_id = session_id

        if @payment.save
          @booking.update(status: "confirmed")
          BookingMailer.payment_confirmation(@payment).deliver_now
          TwilioService.new.send_booking_confirmation_sms(@booking)
          redirect_to booking_path(@booking), notice: "Paiement réussi ! Votre réservation est confirmée."
        else
          redirect_to new_booking_payment_path(@booking), alert: "Erreur lors de l'enregistrement du paiement."
        end
      else
        redirect_to new_booking_payment_path(@booking), alert: "Le paiement n'a pas été complété."
      end
    rescue Stripe::StripeError => e
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
    stripe_service = StripeService.new

    begin
      session = stripe_service.create_checkout_session(@booking)
      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      redirect_to new_booking_payment_path(@booking), alert: "Erreur lors de la création de la session de paiement."
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

  private
    def set_booking
      @booking = Booking.find(params[:booking_id])
    end

    def set_payment
      @payment = @booking.payment
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
