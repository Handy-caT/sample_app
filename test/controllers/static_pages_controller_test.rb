require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", full_title("")
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select "title", full_title("Help")
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", full_title("About")
  end
end
