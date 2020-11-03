require 'test_helper'

class EndangeredControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get endangered_index_url
    assert_response :success
  end

end
