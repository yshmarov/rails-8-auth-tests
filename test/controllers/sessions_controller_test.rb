require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_session_url
    assert_response :success

    user = users(:one)
    sign_in(user, password: "password")

    assert_redirected_to root_url

    get new_session_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    user = users(:one)
    sign_in(user, password: "password")

    assert_redirected_to root_url
  end

  test "should not create session with invalid credentials" do
    user = users(:one)
    sign_in(user, password: "wrongpassword")

    assert_redirected_to new_session_url
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "should destroy session" do
    delete session_url
    assert_redirected_to new_session_url
  end
end