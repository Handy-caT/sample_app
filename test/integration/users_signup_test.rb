require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid registration information" do
    get sign_up_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bar"}
    end
    assert_template 'users/new'
  end

end