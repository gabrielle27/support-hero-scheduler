require 'test_helper'

class ConflictsControllerTest < ActionController::TestCase

  test "feed" do
    get :feed, format: :json
    assert_response :success
  end

  test "should receive conflict feed data" do
    get :feed, start: Date.today, end: Date.today + 1, format: :json
    conflict = conflicts(:one)
    first_response = json_value(@response, "support_date")
    assert json_value(@response, "support_date") == conflict.support_date.to_s
  end

end
