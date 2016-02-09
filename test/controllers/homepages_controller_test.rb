require 'test_helper'

class HomepagesControllerTest < ActionController::TestCase
  test "should get front" do
    get :front
    assert_response :success
  end

  test "should get services" do
    get :services
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
