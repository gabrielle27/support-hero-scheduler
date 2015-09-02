require 'test_helper'

class SwapRequestsControllerTest < ActionController::TestCase

  test "feed" do
    get :feed, format: :json
    assert_response :success
  end

  test "should receive swap request feed data" do
    swap_request = swap_requests(:one).target
    sign_in_user(swap_request.employee)
    get :feed, start: Date.today, end: swap_request.support_date,
        format: :json

    first_response = json_value(@response, "support_date")
    date = swap_request.support_date.to_s
    assert json_value(@response, "support_date") == date
  end

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

  test "update" do
    patch :update, id: swap_requests(:one).id, format: :json
    assert_response :success
  end

  test "should update a swap request" do
    patch :update, id: swap_requests(:one).id, format: :json
    assert_response :success
    assert json_value(@response, "success")
  end

end
