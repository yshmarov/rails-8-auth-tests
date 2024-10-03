# test/controllers/passwords_controller_test.rb
require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_password_url
    assert_response :success
  end

  test "should create password reset when user exists" do
    user = users(:one)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post passwords_url, params: { email_address: user.email_address }
      perform_enqueued_jobs
    end
    assert_redirected_to new_session_url
    assert_equal "Password reset instructions sent (if user with that email address exists).", flash[:notice]
  end

  test "should create password reset when user does not exist" do
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post passwords_url, params: { email_address: 'nonexistent@example.com' }
      perform_enqueued_jobs
    end
    assert_redirected_to new_session_url
    assert_equal "Password reset instructions sent (if user with that email address exists).", flash[:notice]
  end

  test "should get edit" do
    user = users(:one)
    get edit_password_url(token: user.password_reset_token)
    assert_response :success
  end

  test "should redirect to new password when token is invalid" do
    get edit_password_url(token: 'invalid_token')
    assert_redirected_to new_password_url
    assert_equal "Password reset link is invalid or has expired.", flash[:alert]
  end

  test "should update password when successful" do
    user = users(:one)
    patch password_url(token: user.password_reset_token), params: { password: 'newpassword', password_confirmation: 'newpassword' }
    assert_redirected_to new_session_url
    assert_equal "Password has been reset.", flash[:notice]
  end

  test "should not update password when passwords do not match" do
    user = users(:one)
    token = user.password_reset_token
    patch password_url(token:), params: { password: 'newpassword', password_confirmation: 'wrongpassword' }
    assert_redirected_to edit_password_url(token:)
    assert_equal "Passwords did not match.", flash[:alert]
  end
end