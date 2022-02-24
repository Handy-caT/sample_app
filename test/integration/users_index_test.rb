require 'test_helper'


class UsersIndexTest < ActionDispatch::IntegrationTest
  include Pagy::Frontend

  def setup
    @admin = users(:john)
    @non_admin = users(:steven)
  end

  test "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    #add test for users on page
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    pagy = @pagy_locale

  end

end