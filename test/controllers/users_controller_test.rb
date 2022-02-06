require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test "should get new" do
    get sign_up_url
    assert_response :success
    assert_select "title", full_title("Sign Up")
  end
end
