require 'test_helper'

class KeystoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(id: 1, name: 'TEST', email: 'TEST@TEST.COM',
                     password_digest: 'passwordDigestHere')
    @user2 = User.new(id: 2, name: 'TEST2', email: 'TEST2@TEST2.COM',
                      password_digest: 'passwordDigestHere')
    @keystore = Keystore.new(url: 'https://google.com', name: 'testApp',
                             user_id: 1)
    @keystore2 = Keystore.new(url: 'https://google2.com', name: 'testApp2',
                              user_id: 1)
  end

  test 'should be a valid keystore' do
    assert @keystore.valid?
  end

  test 'should be invalid without a user id' do
    @keystore.user_id = nil
    assert_not @keystore.valid?
  end

  test 'should be invalid without a name' do
    @keystore.name = nil
    assert_not @keystore.valid?
  end

  test 'should be invalid w/ duplicate app names for same user' do
    @keystore2.name = @keystore.name
    @keystore.save!
    assert_not @keystore2.valid?
  end

  test 'should be valid w/ duplicate app names from different users' do
    @keystore2.name = @keystore.name
    @keystore2.user_id = 2
    @keystore.save!
    assert @keystore.valid?
  end

  test 'should be invalid w/ empty string for a name' do
    @keystore.name = ""
    assert_not @keystore.valid?
  end

  test 'should be invalid w/ name longer than 100' do
    @keystore.name = "!" * 101
    assert_not @keystore.valid?
  end

end
