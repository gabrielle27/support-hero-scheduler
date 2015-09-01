require 'test_helper'

class SwapRequestTest < ActiveSupport::TestCase

  #### Validations #############################################################

  test "should not create a swap request without an existing source schedule" do
    swap_request = SwapRequest.create( source_id: INVALID_ID,
                                       target: schedules(:one) )
    assert swap_request.errors[:source].include? "can't be blank"
  end

  test "should not create a swap request without an existing target schedule" do
    swap_request = SwapRequest.create( source: schedules(:one),
                                       target_id: INVALID_ID)
    assert swap_request.errors[:target].include? "can't be blank"
  end

  test "should not allow a swap request with the same employee" do
    swap_request = SwapRequest.create(source: schedules(:one),
                                      target: schedules(:one))
    assert swap_request.errors[:base].include? "Employee may not swap days " +
                                                 "with themselves"
  end

  #### Associations ############################################################

  test "should have associated source schedule" do
    assert swap_requests(:one).source.is_a?(Schedule)
  end

  test "should have associated target schedule" do
    assert swap_requests(:one).target.is_a?(Schedule)
  end

  #### Methods #################################################################

  test "should fulfill a swap requet" do
    requester = schedules(:one).employee
    requested_date = schedules(:two).support_date

    swap_requests(:one).fulfill
    assert scheduled_dates(requester).include?(requested_date)
  end

end
