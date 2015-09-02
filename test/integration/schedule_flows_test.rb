require 'test_helper'

class ScheduleFlowsTest < ActionDispatch::IntegrationTest

  test "load schedule and reschedule around a conflict" do
    # visit homepage
    get "/"
    assert_response :success

    # clear schedule
    delete "/schedules/clear"
    assert_redirected_to "/"

    # load schedule
    test_file = "#{Rails.root}/test/fixtures/files/schedule.txt"
    file = Rack::Test::UploadedFile.new(test_file, "image/jpeg")

    original_count = Schedule.count

    post "/schedules/set_schedule", schedule: { file: file }

    assert Schedule.count == original_count + 40

    # create a conflict ###############
    employee = Employee.order(:id).last
    schedule = employee.schedules.last

    # log user in
    post "/current_user/#{::CurrentUser.authentication_key}/sign_in",
      user_id: employee.id
    assert_redirected_to "/"

    # add conflict
    post "/conflicts", support_date: schedule.support_date.to_s
    assert_response :success

    updated_schedule = Schedule.where(
        support_date: schedule.support_date.to_s
      ).first

    assert updated_schedule.employee.id != employee.id

  end

  test "load schedule and swap schedules" do
    # visit homepage
    get "/"
    assert_response :success

    # clear schedule
    delete "/schedules/clear"
    assert_redirected_to "/"

    # load schedule
    test_file = "#{Rails.root}/test/fixtures/files/schedule.txt"
    file = Rack::Test::UploadedFile.new(test_file, "image/jpeg")

    original_count = Schedule.count

    post "/schedules/set_schedule", schedule: { file: file }

    assert Schedule.count == original_count + 40

    # log user in
    employee = Employee.first
    post "/current_user/#{::CurrentUser.authentication_key}/sign_in",
      user_id: employee.id
    assert_redirected_to "/"

    # add conflict
    src_schedule = employee.schedules.first
    target_schedule = Schedule.where("employee_id != ?", employee.id).first
    post "/swap_requests", src_schedule_id: src_schedule.id,
                           target_schedule_id: target_schedule.id
    assert_response :success

    swap_request = SwapRequest.first
    assert_not_nil swap_request.id

    target_employee = target_schedule.employee
    post "/current_user/#{::CurrentUser.authentication_key}/sign_in",
      user_id: target_employee.id
    assert_redirected_to "/"

    patch "/swap_requests/#{swap_request.id}"
    assert_response :success

    updated_src_schedule = Schedule.find_by(support_date: src_schedule.support_date)
    updated_target_schedule = Schedule.find_by(support_date:
                                               target_schedule.support_date)

    assert updated_src_schedule.employee_id == target_employee.id
    assert updated_target_schedule.employee_id == employee.id

  end

end
