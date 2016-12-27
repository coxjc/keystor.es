require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid signup information' do
    get new_user_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: 'hef',
                                       email: 'user@invalid.com',
                                       password: 'foo',
                                       password_confirmation: 'bar'}}
    end
    assert_template 'users/new'
  end

end
