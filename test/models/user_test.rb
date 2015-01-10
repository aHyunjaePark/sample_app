require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "shoul be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 100
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 1000
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    invalid_addresses = %w[user@example USER@foo,COM]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be valid"
    end
  end

  test 'email address should be unique' do
    dup_user = @user.dup
    @user.save
    assert_not dup_user.valid?
  end

  test "password should be longer than 6" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?, "password has to be longer than 6"
  end
  
  test "email should be saved as lowercase" do
    mixed_email = "dEjIIIJKkk@test.com"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end
end
