require "test_helper"

class ServiceRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get service_requests_new_url
    assert_response :success
  end

  test "should get create" do
    get service_requests_create_url
    assert_response :success
  end

  test "should get show" do
    get service_requests_show_url
    assert_response :success
  end
end
