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

  test "feed" do
    get :feed, format: :json
    assert_response :success
  end

  test "should receive schedule feed data" do
    schedule = schedules(:one)
    get :feed, start: Date.today, end: schedule.support_date, format: :json
    first_response = json_value(@response, "support_date")
    assert json_value(@response, "support_date") == schedule.support_date.to_s
  end

  test "set schedule" do
    post :set_schedule, format: :json
    assert_redirected_to root_url
  end

  test "load schedule from file" do
    test_file = "#{Rails.root}/test/fixtures/files/schedule.txt"
    file = Rack::Test::UploadedFile.new(test_file, "image/jpeg")

    original_count = Schedule.count

    post :set_schedule, format: :json, schedule: { file: file }

    assert Schedule.count == original_count + 40
  end

  test "should handle schedule load error" do
    post :set_schedule, format: :json
    msg = "There was a problem creating the schedule. Please try again."
    assert_equal msg, flash[:notice]
  end

  test "clear schedule should redirect to schedule page" do
    delete :clear, format: :json
    assert_redirected_to root_url
  end

  test "clear schedule should clear the schedule" do
    delete :clear, format: :json

    assert Schedule.count == 0
  end

end
