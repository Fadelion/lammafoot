class StripeService
  def initialize
    @stripe_secret_key = Rails.application.config.stripe[:secret_key]
  end

  def create_checkout_session(booking)
    Stripe::Checkout::Session.create({
      payment_method_types: [ "card" ],
      line_items: [ {
        price_data: {
          currency: "eur",
          product_data: {
            name: "Réservation - #{booking.stadium.name}",
            description: "Réservation du #{booking.start_date.strftime('%d/%m/%Y de %H:%M')} à #{booking.end_date.strftime('%H:%M')}"
          },
          unit_amount: (booking.total_price * 100).to_i # Stripe utilise les centimes
        },
        quantity: 1
      } ],
      mode: "payment",
      success_url: "#{Rails.application.routes.url_helpers.root_url}bookings/#{booking.id}/payment/success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{Rails.application.routes.url_helpers.root_url}bookings/#{booking.id}/payment/cancel",
      metadata: {
        booking_id: booking.id,
        user_id: booking.user.id
      }
    })
  end

  def retrieve_session(session_id)
    Stripe::Checkout::Session.retrieve(session_id)
  end

  def create_payment_intent(amount, currency = "eur", metadata = {})
    Stripe::PaymentIntent.create({
      amount: (amount * 100).to_i,
      currency: currency,
      metadata: metadata
    })
  end
end
