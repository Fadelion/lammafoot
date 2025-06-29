class WebhooksController < ApplicationController
  protect_from_forgery except: :stripe

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret) || ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { error: "Invalid payload" }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: "Invalid signature" }, status: 400
      return
    end

    case event["type"]
    when "checkout.session.completed"
      handle_checkout_session_completed(event["data"]["object"])
    when "payment_intent.succeeded"
      handle_payment_succeeded(event["data"]["object"])
    else
      Rails.logger.info "Unhandled event type: #{event['type']}"
    end

    render json: { status: "success" }
  end

  private

  def handle_checkout_session_completed(session)
    booking_id = session["metadata"]["booking_id"]
    return unless booking_id

    booking = Booking.find_by(id: booking_id)
    return unless booking

    payment = booking.payment || Payment.new(booking: booking, user: booking.user)
    payment.amount = booking.total_price
    payment.payment_method = "stripe"
    payment.status = "completed"
    payment.payment_date = Time.current
    payment.stripe_session_id = session["id"]

    if payment.save
      booking.update(status: "confirmed")
      BookingMailer.payment_confirmation(payment).deliver_now
      TwilioService.new.send_booking_confirmation_sms(booking)
    end
  end

  def handle_payment_succeeded(payment_intent)
    Rails.logger.info "Payment succeeded: #{payment_intent['id']}"
  end
end
