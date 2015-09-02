require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase

  test "current hero" do
    get :current_hero, format: :json
    assert_response :success
  end

  test "should display today's current hero" do
    schedule = create_current_hero
    Delorean.time_travel_to(schedule.support_date) do
      get :current_hero, format: :json
      name = json_value(@response, "name")
      assert name == schedule.employee.name
    end
  end

  test "scheduled dates" do
    get :scheduled_dates, format: :json
    assert_response :success
  end

  test "returns schedule dates for employee" do
    employee = employees(:one)
    sign_in_user(employee)
    get :scheduled_dates, format: :json
    date = json_value(@response, "support_date")
    assert scheduled_dates(employee).map(&:to_s).include?(date)
  end

end
