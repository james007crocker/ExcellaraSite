require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @company = Company.new(name: "Google", email: "google@google.com", location: "Mountain View", size: 50, description: "We build cool things",
      password: "password", password_confirmation: "password")
  end

  test "Should be valid" do
    assert @company.valid?
  end

  test "name should be present" do
    @company.name = " "
    assert_not @company.valid?
  end

  test "email should be present" do
    @company.email = " "
    assert_not @company.valid?
  end

  test "name should not be too long" do
    @company.name = "a" * 51
    assert_not @company.valid?
  end

  test "email should not be too long" do
    @company.email = "a" * 244 + "@example.com"
    assert_not @company.valid?
  end

  test "email validation should accept valid address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @company.email = valid_address
      assert @company.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @company.dup
    duplicate_user.email = @company.email.upcase
    @company.save
    assert_not duplicate_user.valid?
  end

end
