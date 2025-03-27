require "test_helper"

class GuideFeedbacksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get guide_feedbacks_new_url
    assert_response :success
  end

  test "should get create" do
    get guide_feedbacks_create_url
    assert_response :success
  end
end
