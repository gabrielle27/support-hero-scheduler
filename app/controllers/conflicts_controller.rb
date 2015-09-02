class ConflictsController < ApplicationController

  include SchedulesControllable

  respond_to :json

  def feed
    conflicts = feed_base(Conflict).joins(:employee).select([
                  "#{Conflict.table_name}.*",
                  "'conflict'::character(8) AS event_type",
                  "#{Employee.table_name}.name",
                  "#{Employee.table_name}.id"
                ])
    if params[:employee_id].present?
      conflicts = conflicts.where(employee_id: params[:employee_id])
    end
    respond_with conflicts
  end

end
