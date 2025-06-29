require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
    @user = users(:one)
  end

  test "should require authentication for new" do
    get new_booking_payment_url(@booking)
    assert_redirected_to new_user_session_url
  end

  test "should require authentication for create" do
    post booking_payments_url(@booking)
    assert_redirected_to new_user_session_url
  end

  test "should require authentication for show" do
    payment = payments(:one)
    get booking_payment_url(@booking, payment)
    assert_redirected_to new_user_session_url
  end
end
