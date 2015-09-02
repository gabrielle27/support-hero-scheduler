require 'test_helper'

class SwapRequestsControllerTest < ActionController::TestCase
  test "create" do
    post :create, format: :json
    assert_response :success
  end

  test "should create a swap request" do
    SwapRequest.destroy_all
    sid = schedules(:one).id
    tid = schedules(:two).id
    post :create, src_schedule_id: sid, target_schedule_id: tid, format: :json
    assert_not_nil json_value(@response, "id")
  end
end
