class AddUserInfoToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :user_name, :string
    add_column :bookings, :user_email, :string
  end
end
