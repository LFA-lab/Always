require "test_helper"

class ParcoursGuidesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get parcours_guides_create_url
    assert_response :success
  end

  test "should get update" do
    get parcours_guides_update_url
    assert_response :success
  end

  test "should get destroy" do
    get parcours_guides_destroy_url
    assert_response :success
  end
end
