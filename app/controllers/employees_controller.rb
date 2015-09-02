class EmployeesController < ApplicationController

  respond_to :json

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
