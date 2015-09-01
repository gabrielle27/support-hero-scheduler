class SchedulesController < ApplicationController

  include SchedulesControllable

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

    respond_with schedules
  end
end
