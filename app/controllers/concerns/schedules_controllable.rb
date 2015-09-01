module SchedulesControllable
  extend ActiveSupport::Concern

  private

  def feed_base(model, table_name=nil)
    table_name ||= model.table_name
    model.where(
      "#{table_name}.support_date BETWEEN ? AND ?", params[:start], params[:end]
      )
  end

end
