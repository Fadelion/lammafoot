Rails.application.configure do
  config.stripe = {
    publishable_key: Rails.application.credentials.dig(:stripe, :publishable_key) || ENV["STRIPE_PUBLISHABLE_KEY"],
    secret_key: Rails.application.credentials.dig(:stripe, :secret_key) || ENV["STRIPE_SECRET_KEY"]
  }
end

if Rails.application.config.stripe[:secret_key].present?
  Stripe.api_key = Rails.application.config.stripe[:secret_key]
else
  Rails.logger.warn "Stripe secret key not configured" unless Rails.env.test?
end