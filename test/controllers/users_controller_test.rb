require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:john)
    @other_user = users(:steven)
  end

  test "should get new" do
    get sign_up_url
    assert_response :success
    assert_select "title", full_title("Sign Up")
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to log_in_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email} }
    assert_not flash.empty?
    assert_redirected_to log_in_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email} }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_url
    assert_redirected_to log_in_url
  end

end
