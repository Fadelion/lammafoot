require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stadium = stadia(:one)
    @review = reviews(:one)
    @user = users(:one)
  end

  test "should require authentication for new" do
    get new_stadium_review_url(@stadium)
    assert_redirected_to new_user_session_url
  end

  test "should require authentication for create" do
    post stadium_reviews_url(@stadium)
    assert_redirected_to new_user_session_url
  end

  test "should require authentication for edit" do
    get edit_review_url(@review)
    assert_redirected_to new_user_session_url
  end
end
