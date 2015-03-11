require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get user_signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                     email: "user@invalid",
                     location: "Hello",
                     experience: "",
                     accomplishment: "",
                     password: "abc",
                     password_confirmation: "def"}
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get user_signup_path
    assert_difference 'User.count' do
      post_via_redirect users_path, user: { name: "jamie",
                               email: "user@rogers.com",
                               location: "Ont",
                               experience: "Ran around the world in 80 days.",
                               accomplishment: "Come back to me in 50 years.",
                               password: "abcdef",
                               password_confirmation: "abcdef"}
    end
    assert_template 'users/show'
  end
end
