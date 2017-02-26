require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test 'the truth' do
  #   assert true
  # end
  def setup
    @user = User.new(:name => 'TestingName', :email => 'name@domain.net', :password => 'password', :password_confirmation => 'password')
    @user_2 = User.new(:name => 'TestingName2', :email => 'name@domain.com', :password => 'password', :password_confirmation => 'password')
  end

  test 'testing test suite' do
    assert true
    assert_not false
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'invalid without name' do
    @user.name = nil
    assert_not @user.valid?
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'invalid without email' do
    @user.email = nil
    assert_not @user.valid?
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'invalid without password & password confirmation' do
    @user.password = nil
    @user.password_confirmation = nil
    assert_not @user.valid?
    @user.password = ' '
    @user.password_confirmation = ' '
    assert_not @user.valid?
  end

  test 'invalid with mismatched password & password confirmation' do
    @user.password = 'wrongpassword'
    @user.password_confirmation = 'password'
    assert_not @user.valid?
  end

  test 'invalid w/ password less than 6 characters long' do
    @user.password = @user.password_confirmation = 'passw'
    assert_not @user.valid?
    @user.password = @user.password_confirmation = 'password'
    assert @user.valid?
  end

  test 'invalid without unique email' do
    @user_2.email = @user.email
    @user.save!
    assert_not @user_2.valid?
  end

  test 'name saves as uppercase' do
    user_name = @user.name.upcase
    @user.save!
    assert @user.name == user_name
    user_2_name = @user_2.name.upcase
    @user_2.save!
    assert @user_2.name == user_2_name
  end

  test 'email saves as uppercase' do
    user_email = @user.email.upcase
    @user.save!
    assert @user.email == user_email
    user_2_email = @user_2.email.upcase
    @user_2.save!
    assert @user_2.email = user_2_email
  end

  test 'create reset digest' do
    @user.create_reset_digest
    assert_not_nil @user.reset_digest
    assert_not_nil @user.reset_sent_at
  end

  test 'password reset valid for two hours max' do
    @user.create_reset_digest
    assert_not @user.password_reset_expired?
    @user.reset_sent_at = Time.zone.now - 3.hours
    assert @user.password_reset_expired?
  end

  test 'updating membership changes subscription validity date' do
    @user.update_membership true
    assert @user.stripe_end_date = Date.today + 1.month
    assert @user.has_valid_membership?
  end

  test 'invalid membership if never paid/used stripe' do
    assert_not @user.has_valid_membership?
  end

  test 'email is not confirmed until user uses the confirm token link' do
    assert_not @user.email_confirmed
    @user.email_activate
    assert @user.email_confirmed
  end

end
