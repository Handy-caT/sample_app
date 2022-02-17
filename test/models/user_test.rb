require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test User", email: "test@test.com",
                      password:"te$tPassw0rd", password_confirmation:"te$tPassw0rd")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.name = "a"*247+"@test.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[test@test.com TEST@test.COM T_ES-T@test.bar.org
                           test.example@test.com example+test@test.org]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[test@test,com example.com test.example@test.
                             test@example_test.com test@examle+test.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password validation should accept valid passwords" do
    valid_passwords = %w[te$tPassw0rd t-_&hjT0y -_-_-_-_7yU
                            #_7-yIy-7_# tesTexamle!t8com]
    valid_passwords.each do |valid_password|
      @user.password = @user.password_confirmation = valid_password
      assert @user.valid?, "#{valid_password.inspect} should be valid"
    end
  end

  test "password validation should reject invalid passwords" do
    invalid_passwords = %w[a]
    long_invalid_password = "a"*25
    blank_password = '   '
    invalid_passwords.concat [blank_password, long_invalid_password]

    invalid_passwords.each do |invalid_password|
      @user.password = @user.password_confirmation = invalid_password
      assert_not @user.valid?, "#{invalid_password.inspect} should be invalid"
    end
  end

  test "email should be saved in downcase" do
    mixed_case_email = "TeSTmAil@test.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase , @user.reload.email
  end

end
