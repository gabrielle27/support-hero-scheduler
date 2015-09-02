require 'test_helper'

class HolidaysControllerTest < ActionController::TestCase

  test "feed" do
    get :feed, format: :json
    assert_response :success
  end

  test "should receive holiday feed data" do
    holiday = holidays(:one)
    get :feed, start: Date.today, end: holiday.support_date, format: :json
    first_response = json_value(@response, "support_date")
    assert json_value(@response, "support_date") == holiday.support_date.to_s
  end

end
