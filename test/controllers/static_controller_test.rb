require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should get index when authenticated" do
    user = users(:one)
    sign_in(user, password: "password")

    get root_url
    assert_response :success

    assert_match user.email_address, response.body
  end

  test "should not get dashboard when unauthenticated" do 
    get dashboard_url
    assert_response :redirect
  end
  
  test "should get dashboard when authenticated" do
    user = users(:one)
    sign_in(user, password: "password")
    get dashboard_url
    assert_response :success
    assert_match user.email_address, response.body

    delete session_url
    assert_redirected_to new_session_url
    follow_redirect!
    assert_no_match user.email_address, response.body
  end
end
