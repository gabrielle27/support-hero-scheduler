class SwapRequestsController < ApplicationController

  include SchedulesControllable

  respond_to :json

  def update
    swap_request = SwapRequest.find(params[:id])
    status = swap_request.fulfill
  rescue Exception => e
    status = false
  ensure
    render json: { success: status }
  end

  def feed
    swap_requests = nil
    if current_user
      swap_requests = feed_base(SwapRequest, Schedule.table_name).where(
          "#{Employee.table_name}.id = ?",  current_user.id
        ).joins(
          target: :employee
        ).joins(
          source: :employee
        ).select([
          "#{SwapRequest.table_name}.*",
          "'swap request'::character(12) AS event_type",
          "#{Schedule.table_name}.support_date AS support_date",
          "sources_swap_requests.support_date AS src_support_date",
          "employees_schedules.name AS src_name",
          "#{Employee.table_name}.name",
          "#{Employee.table_name}.id AS employee_id"
        ])

    end
    respond_with swap_requests
  end

  def create
    swap_request =  SwapRequest.create(
      source_id: params[:src_schedule_id],
      target_id: params[:target_schedule_id]
    )
    render json: swap_request
  end

end
