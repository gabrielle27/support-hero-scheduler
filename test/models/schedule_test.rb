require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase

  #### Validations #############################################################

  test "should not create a schedule without an existing employee" do
    schedule = Schedule.create(employee_id: INVALID_ID,
                               support_date: Date.today)
    assert schedule.errors[:employee].include? "can't be blank"
  end

  test "should not create a schedule without a valid date" do
    schedule = Schedule.create(employee_id: employees(:one).id,
                            :support_date => "baddate")
    assert schedule.errors[:support_date].include? "is not a date"
  end

  test "should not schedule more than 1 employee on the same date" do
    schedule = Schedule.create(employee_id: employees(:one).id,
                             support_date: schedules(:one).support_date)

    assert schedule.errors[:support_date].include? "has already been taken"
  end

  test "should not schedule anyone on a holiday" do
    schedule = Schedule.create(employee_id: employees(:one).id,
                            support_date: holidays(:one).support_date)
    assert schedule.errors[:support_date].include? "is not a workday"
  end

  test "should not schedule anyone on a weekend" do
    schedule = Schedule.create(employee_id: employees(:one).id,
                            support_date: next_weekend_day)
    assert schedule.errors[:support_date].include? "is not a workday"
  end

  test "should not schedule an employee on a day they are not available" do
    schedule = Schedule.create(support_date: conflicts(:one).support_date,
                            employee_id: conflicts(:one).employee_id)
    assert schedule.errors[:employee].include? "is not available on this date"
  end

  #### Associations ############################################################

  test "should have associated employee" do
    assert schedules(:one).employee.is_a?(Employee)
  end

  test "should report correct number of outgoing swap requests" do
    assert schedules(:one).outgoing_swap_requests.size == 1
  end

  test "should report correct number of incoming swap requests" do
    assert schedules(:two).incoming_swap_requests.size == 1
  end

end

