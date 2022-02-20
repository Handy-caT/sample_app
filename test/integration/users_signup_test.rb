require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid registration information" do
    get sign_up_path
    assert_no_difference 'User.count' do
      post users_path, params:{ user: {name: "",
                                       email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "bar"} }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid registration information" do
    get sign_up_path
    assert_difference 'User.count' do
      post users_path, params:{ user: {name: "John",
                                       email: "user@valid.com",
                                       password: "RealPassword",
                                       password_confirmation: "RealPassword"} }
      follow_redirect!
    end
    assert_template 'users/show'
    assert_not flash.blank?
    assert is_logged_in?
  end

end