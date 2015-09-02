class EmployeesController < ApplicationController

  respond_to :json

  def current_hero
    employee = nil
    if schedule = Schedule.find_by(support_date: Date.today)
      employee = schedule.employee
    end
    render json: { name: employee.try(:name).to_s }
  end

  def scheduled_dates
    dates = nil
    if current_user
      dates = current_user.schedules.where(
      "support_date >= ?", Date.today
      ).select([:id, :support_date])
    end
    respond_with dates
  end

end
