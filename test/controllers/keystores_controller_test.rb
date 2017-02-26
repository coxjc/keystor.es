require 'test_helper'

class KeystoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.new(:name => 'Name', :email => 'def@123.net',
                     :password => 'password', :password_confirmation => 'password')
    @user.save!
    @keystore = keystores(:one)
  end

  test 'index should get user\'s keystores index' do
    login(@user)
    get keystores_url
    assert_response :success
    assert (@user.keystores.length == 0)
  end

  test 'should get new for user with confirmed email and updated payment' do
    @user.update_membership true
    @user.email_activate
    login(@user)
    get new_keystore_url
    assert_empty flash
    assert_response :success
  end

  test 'should redirect to root for user w/ confirmed email but
w/o updated payment' do
    @user.email_activate
    login(@user)
    get new_keystore_url
    assert_not_empty flash
    assert_redirected_to root_url
  end

  test 'should redirect to keystores new for user w/o confirmed email but w/o
  updated payment' do
    @user.update_membership true
    login(@user)
    get new_keystore_url
    assert_not_empty flash
    assert_redirected_to root_url
  end

  test 'should show keystore for authorized user' do
    @user.update_attribute(:id, @keystore.user_id)
    @user.save!
    login(@user)
    get keystore_url(@keystore)
    assert_response :success
  end

  test 'should not show keystore for unauthorized user' do
    @user.update_attribute(:id, @keystore.user_id + 5)
    @user.save!
    login(@user)
    get keystore_url(@keystore)
    assert_not_empty flash
    assert_redirected_to root_url
  end

  test 'should not show keystore for unauthenticated user' do
    get keystore_url(@keystore)
    assert_not_empty flash
    assert_redirected_to root_url
  end

  # test 'should not destroy keystore for unauthorized user' do
  #   @user.update_attribute(:id, keystores(:one).user_id)
  #   @user.save!
  #   login(@user)
  #   assert_difference('Keystore.count', 0) do
  #     delete keystore_url(keystores(:two))
  #   end
  #   assert_redirected_to root_url
  # end
end
