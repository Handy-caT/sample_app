require 'test_helper'


class UsersIndexTest < ActionDispatch::IntegrationTest
  include Pagy::Backend

  def setup
    @admin = users(:john)
    @non_admin = users(:steven)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    @pagy , users_first_list = pagy(User.all,page: 1)
    users_first_list.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: 'delete', method: :delete
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end