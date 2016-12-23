require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup 
      @user = User.new(:name => "TestingName", :email => "name@domain.net", :password => "password", :password_confirmation => "password")
      @user_2 = User.new(:name => "TestingName2", :email => "name@domain.com", :password => "password", :password_confirmation => "password")
  end
  
  test "testing test suite" do
      assert true
      assert_not false
  end 

  test "valid user" do 
      assert @user.valid? 
  end

  test "invalid without name" do 
      @user.name = nil
      assert_not @user.valid? 
  end

  test "invalid without email" do
      @user.email = nil
      assert_not @user.valid?
   end

  test "invalid without password & password confirmation" do
      @user.password = nil
      @user.password_confirmation = nil
      assert_not @user.valid?
  end

  test "invalid with mismatched password & password confirmation" do
      @user.password = "wrongpassword"
      @user.password_confirmation = "password"
      assert_not @user.valid?
  end 

  test "invalid without unique email" do
      @user_2.email = @user.email
      @user.save!
      assert_not @user_2.valid?
  end

end
