require "test_helper"

class PrivacyPolicyTest < ActionDispatch::IntegrationTest
  test "access public privacy policy without authentication" do
    get "/privacy-policy"
    assert_equal 200, response.status, "La page privacy-policy doit être accessible publiquement (HTTP 200) et non redirigée vers la page de connexion."
  end
end 