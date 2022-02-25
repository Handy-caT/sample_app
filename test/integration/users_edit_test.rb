require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:john)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: { user: { name: "",
                                              email: "test@invalid.com",
                                              password: "test",
                                              password_confirmation: "wrong"} }
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)

    name = "New Name"
    email = "real@email.com"

    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: ""} }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email

  end

  test "should not allow to change password without old password" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { password: "Pa$$word1",
                                              password_confirmation: "Pa$$word1"} }
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "should allow to change password with old password" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { password: "Pa$$word1",
                                              password_confirmation: "Pa$$word1",
                                              old_password: 'password'} }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert BCrypt::Password.new(@user.password_digest).is_password?("Pa$$word1")
  end

end