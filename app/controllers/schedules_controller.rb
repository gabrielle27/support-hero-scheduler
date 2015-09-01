class SchedulesController < ApplicationController

  respond_to :json

  def index
    todays_schedule = Schedule.find_by(support_date: Date.today )
    @current_hero = todays_schedule ? todays_schedule.employee.name : nil
  end

end
