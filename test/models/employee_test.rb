require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase

  #### Validations #############################################################

  test "should not create an employee without a name" do
    employee = Employee.create
    assert employee.errors[:name].include? "can't be blank"
  end

  test "should not create an employee with a name that is too long" do
    employee = Employee.create(name: over_max_limit_string)
    assert employee.errors[:name].include?  "is too long (maximum is 255 " +
                                            "characters)"
  end

  test "should not create an employee with a non-unique name" do
    employee = Employee.create(name: employees(:one).name)
    assert employee.errors[:name].include? "has already been taken"
  end

  #### Associations ############################################################

  test "should report correct number of outgoing swap requests" do
    assert employees(:one).outgoing_swap_requests.size == 1
  end

  test "should report correct number of incoming swap requests" do
    assert employees(:two).incoming_swap_requests.size == 1
  end

  test "should report correct number of conflicts" do
    assert employees(:one).conflicts.size == 1
  end

  test "should report correct number of schedules" do
    assert employees(:one).schedules.size == 1
  end

end
