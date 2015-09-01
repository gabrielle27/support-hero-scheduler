require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase

  test "index" do
    get :index
    assert_response :success
  end

  test "index should assign today's support hero when a hero exists" do
    schedule = schedules(:one)
    Delorean.time_travel_to(schedule.support_date) do
      get :index
      assert assigns(:current_hero)
    end
  end

  test "index should assign today's support hero when hero does not exist" do
    Delorean.time_travel_to(SupportDate.next_open_day) do
      get :index
    end
    assert_nil assigns(:current_hero)
  end

end
