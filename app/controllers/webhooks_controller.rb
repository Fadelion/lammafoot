class WebhooksController < ApplicationController
  protect_from_forgery except: :stripe

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret) || ENV["STRIPE_WEBHOOK_SECRET"]

    return render json: { error: "Webhook secret not configured" }, status: 500 if endpoint_secret.blank?

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      return render json: { error: "Invalid payload" }, status: 400
    rescue Stripe::SignatureVerificationError
      return render json: { error: "Invalid signature" }, status: 400
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
    return Rails.logger.warn "No booking_id in webhook metadata" unless booking_id

    booking = Booking.find_by(id: booking_id)
    return Rails.logger.warn "Booking #{booking_id} not found" unless booking

    return Rails.logger.info "Payment already processed for booking #{booking_id}" if booking.payment&.completed?

    payment = booking.payment || Payment.new(booking: booking, user: booking.user)
    payment.assign_attributes(
      amount: booking.total_price,
      payment_method: "stripe",
      status: "completed",
      payment_date: Time.current,
      stripe_session_id: session["id"]
    )

    if payment.save
      booking.update!(status: "confirmed")
      BookingMailer.payment_confirmation(payment).deliver_now
      TwilioService.new.send_booking_confirmation_sms(booking)
      Rails.logger.info "Payment processed successfully for booking #{booking_id}"
    else
      Rails.logger.error "Failed to save payment for booking #{booking_id}: #{payment.errors.full_messages}"
    end
  rescue => e
    Rails.logger.error "Error processing webhook for booking #{booking_id}: #{e.message}"
  end

  def handle_payment_succeeded(payment_intent)
    Rails.logger.info "Payment succeeded: #{payment_intent['id']}"
  end
end
