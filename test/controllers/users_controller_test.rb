require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.new(:id => 3, :name => 'Name', :email => 'def@123.net',
                     :password => 'password', :password_confirmation => 'password')
  end

  test 'should not get index' do
    get users_url
    assert_redirected_to root_url
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: {user: {email: @user.email, name: @user.name,
                                      password: @user.password,
                                      password_confirmation: @user.password
      }}
    end
    #The controller calls for a redirect to the user's keystores path
    assert_redirected_to keystores_path
  end

  test 'should not show user profile to user not logged in' do
    @user.save
    get user_url(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should not show user profile of other user to a specific logged in
  user' do
    login(@user)
    get user_url(User.find(1))
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should show user profile of and to authenticated user' do
    @user.save
    login(@user)
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit for authenticated user' do
    @user.save
    login(@user)
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should not get edit for user that is not the authenticated user' do
    @user.save
    login(@user)
    get edit_user_url(User.find(2))
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should not get edit for user that is not logged in' do
    get edit_user_url(User.find(2))
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should update user if logged in' do
    @user.save
    login(@user)
    patch user_url(@user), params: {user: {name: 'Test'}}
    assert_response :success
    assert @user.name == 'Test'
  end

  test 'should not updated if user is not logged in' do
    @user.save
    patch user_url(@user), params: {user: {name: 'Test'}}
    assert_response :success
    assert_not User.find(1).name == 'Test'
  end

  test 'should not allow a logged in user to update someone else' do
    @user.save
    login(@user)
    patch user_url(User.find(1)), params: {user: {name: 'Test'}}
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_not User.find(1).name == 'Test'
  end

end
