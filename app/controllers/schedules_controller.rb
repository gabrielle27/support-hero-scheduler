class SchedulesController < ApplicationController

  include SchedulesControllable

  require 'csv'

  respond_to :json

  def index
    todays_schedule = Schedule.find_by(support_date: Date.today )
    @current_hero = todays_schedule ? todays_schedule.employee.name : nil
  end

  def feed
    schedules = feed_base(Schedule).joins(:employee).select([
        "#{Schedule.table_name}.*",
        "'schedule'::character(8) AS event_type",
        "#{Employee.table_name}.name",
        "#{Employee.table_name}.id AS employee_id"
      ])

    if params[:employee_id].present?
      schedules = schedules.where(employee_id: params[:employee_id])
    end
    respond_with schedules
  end

  def set_schedule
    file = params[:schedule][:file]
    list = CSV.read(file.tempfile.path).flatten
    Schedule.from_list(list)
  rescue Exception => e
    flash[:notice] = "There was a problem creating the schedule. " +
                     "Please try again."
  ensure
    redirect_to root_url
  end

  def clear
    Employee.destroy_all
    redirect_to root_url
  end

end
