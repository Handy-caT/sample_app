require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:john)
  end

  test "login with invalid information" do
    get log_in_path
    assert_template 'sessions/new'
    post log_in_path, params: { session: { email: "", password: ""} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get log_in_path
    post log_in_path, params: { session: { email: @user.email, password: "password"} }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?

    assert_template 'users/show'
    assert_select "a[href=?]", log_in_path, count: 0
    assert_select "a[href=?]", log_out_path
    assert_select "a[href=?]", user_path(@user)

    delete log_out_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    delete log_out_path
    follow_redirect!

    assert_select "a[href=?]", log_in_path
    assert_select "a[href=?]", log_out_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal assigns(:user).remember_token, cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

end
