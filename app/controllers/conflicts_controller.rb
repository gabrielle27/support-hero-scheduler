class ConflictsController < ApplicationController

  include SchedulesControllable

  before_filter :authenticate_user!, only: :create

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

  def create
    conflict = Conflict.new(employee: current_user,
                            support_date: params[:support_date])

    if conflict.valid?
      if Schedule.reschedule(conflict)
        conflict.accomodated = true
        conflict.save
      else
        conflict.errors.add(:base, I18n.t(:reschedule_error))
      end
    end

    render json: { success: conflict.persisted?,
                   errors: conflict.errors.values.flatten }
  end

end
