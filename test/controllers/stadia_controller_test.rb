require "test_helper"

class StadiaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stadia_index_url
    assert_response :success
  end

  test "should get show" do
    get stadia_show_url
    assert_response :success
  end

  test "should get new" do
    get stadia_new_url
    assert_response :success
  end

  test "should get create" do
    get stadia_create_url
    assert_response :success
  end

  test "should get edit" do
    get stadia_edit_url
    assert_response :success
  end

  test "should get update" do
    get stadia_update_url
    assert_response :success
  end

  test "should get destroy" do
    get stadia_destroy_url
    assert_response :success
  end
end
