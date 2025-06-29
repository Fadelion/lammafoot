require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should require authentication for show" do
    get profile_url
    assert_redirected_to new_user_session_url
  end

  test "should require authentication for edit" do
    get edit_profile_url
    assert_redirected_to new_user_session_url
  end

  test "should require authentication for update" do
    patch profile_url
    assert_redirected_to new_user_session_url
  end
end
