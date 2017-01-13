require 'test_helper'

class KeystoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(id: 1, name: 'TEST', email: 'TEST@TEST.COM',
                     password_digest: 'passwordDigestHere')
    @keystore = Keystore.new(url: 'https://google.com', name: 'testApp',
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

end
