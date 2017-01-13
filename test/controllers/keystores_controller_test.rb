require 'test_helper'

class KeystoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @keystore = keystores(:one)
  end

  test "should get index" do
    get keystores_url
    assert_response :success
  end

  test "should get new" do
    get new_keystore_url
    assert_response :success
  end

  test "should create keystore" do
    assert_difference('Keystore.count') do
      post keystores_url, params: {keystore: {url: @keystore.url, user_id: @keystore.user_id}}
    end

    assert_redirected_to keystore_url(Keystore.last)
  end

  test "should show keystore" do
    get keystore_url(@keystore)
    assert_response :success
  end

  test "should get edit" do
    get edit_keystore_url(@keystore)
    assert_response :success
  end

  test "should update keystore" do
    patch keystore_url(@keystore), params: {keystore: {url: @keystore.url, user_id: @keystore.user_id}}
    assert_redirected_to keystore_url(@keystore)
  end

  test "should destroy keystore" do
    assert_difference('Keystore.count', -1) do
      delete keystore_url(@keystore)
    end

    assert_redirected_to keystores_url
  end
end
