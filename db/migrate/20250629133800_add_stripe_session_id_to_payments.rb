class AddStripeSessionIdToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :stripe_session_id, :string
  end
end
