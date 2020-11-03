require 'test_helper'

class SharksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shark = sharks(:one)
  end

  test "should get index" do
    get sharks_url
    assert_response :success
  end

  test "should get new" do
    get new_shark_url
    assert_response :success
  end

  test "should create shark" do
    assert_difference('Shark.count') do
      post sharks_url, params: { shark: { facts: @shark.facts, name: @shark.name } }
    end

    assert_redirected_to shark_url(Shark.last)
  end

  test "should show shark" do
    get shark_url(@shark)
    assert_response :success
  end

  test "should get edit" do
    get edit_shark_url(@shark)
    assert_response :success
  end

  test "should update shark" do
    patch shark_url(@shark), params: { shark: { facts: @shark.facts, name: @shark.name } }
    assert_redirected_to shark_url(@shark)
  end

  test "should destroy shark" do
    assert_difference('Shark.count', -1) do
      delete shark_url(@shark)
    end

    assert_redirected_to sharks_url
  end
end
