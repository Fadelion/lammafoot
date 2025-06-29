require "test_helper"

class StadiaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stadium = stadia(:one)
    @user = users(:one)
  end

  test "should get index" do
    get stadia_url
    assert_response :success
    assert_select "h1", "Nos Terrains Disponibles"
  end

  test "should show stadium" do
    get stadium_url(@stadium)
    assert_response :success
  end

  test "should require admin for new" do
    get new_stadium_url
    assert_redirected_to new_user_session_url
  end

  test "should require admin for create" do
    post stadia_url, params: { stadium: { name: "Test", location: "Test", price: 20, capacity: 10, description: "Test" } }
    assert_redirected_to new_user_session_url
  end
end
