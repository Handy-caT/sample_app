require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:john)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", sign_up_path, count: 2
    assert_select "a[href=?]", log_in_path
    assert_select "a[href=?]", log_out_path, count: 0
    assert_select "a[href=?]", users_path, count: 0

    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", sign_up_path, count: 1
    assert_select "a[href=?]", log_in_path, count: 0
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", log_out_path

  end

  test "active pages" do
    get root_path
    assert_select 'a.active', count: 1
    get about_path
    assert_select 'a.active', count: 1
    get help_path
    assert_select 'a.active', count: 1
    get sign_up_path
    assert_select 'a.active', count: 1
    get log_in_path
    assert_select 'a.active', count: 1

    log_in_as(@user)
    get users_path
    assert_select 'a.active', count: 1

  end
end