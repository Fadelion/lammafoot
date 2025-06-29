require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
    @user = users(:one)
    @stadium = stadia(:one)
  end

  test "should require authentication for index" do
    get bookings_url
    assert_redirected_to new_user_session_url
  end

  test "should require authentication for show" do
    get booking_url(@booking)
    assert_redirected_to new_user_session_url
  end

  test "should require authentication for new" do
    get new_stadium_booking_url(@stadium)
    assert_redirected_to new_user_session_url
  end
end
