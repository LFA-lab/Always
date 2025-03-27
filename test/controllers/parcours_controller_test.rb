require "test_helper"

class ParcoursControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get parcours_index_url
    assert_response :success
  end

  test "should get show" do
    get parcours_show_url
    assert_response :success
  end

  test "should get new" do
    get parcours_new_url
    assert_response :success
  end

  test "should get edit" do
    get parcours_edit_url
    assert_response :success
  end

  test "should get create" do
    get parcours_create_url
    assert_response :success
  end

  test "should get update" do
    get parcours_update_url
    assert_response :success
  end

  test "should get destroy" do
    get parcours_destroy_url
    assert_response :success
  end
end
