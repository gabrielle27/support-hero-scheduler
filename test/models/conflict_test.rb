require 'test_helper'

class ConflictTest < ActiveSupport::TestCase

  #### Validations #############################################################

  test "should not create a conflict without an existing employee" do
    conflict = Conflict.create( employee_id: INVALID_ID,
                                support_date: Date.today)
    assert conflict.errors[:employee].include? "can't be blank"
  end

  test "should not create a conflict without a valid date" do
    conflict = Conflict.create(employee_id: employees(:one).id,
                            support_date: "baddate")
    assert conflict.errors[:support_date].include? "is not a date"
  end

  test "should not create a non-unique conflict" do
    support_date = Date.today
    conflict1 = Conflict.create(employee_id: employees(:one).id,
                                support_date: support_date)
    conflict2 = Conflict.create(employee_id: employees(:one).id,
                             support_date: support_date)
    msg = "You have already marked one of your support days as undoable"
    assert conflict2.errors[:employee_id].include? msg
  end

  test "employee should be scheduled to work on a day in order to create a \
        conflict for that day" do
    conflict = Conflict.create(employee_id: employees(:one).id,
                            support_date: Date.today + 1)
    assert conflict.errors[:base].include? "Employee is not scheduled to " +
                                           "work on this date"
  end

  #### Associations ############################################################

  test "should have associated employee" do
    assert conflicts(:one).employee.is_a?(Employee)
  end

end


