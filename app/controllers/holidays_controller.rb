class HolidaysController < ApplicationController

  include SchedulesControllable

  respond_to :json

  def feed
    respond_with feed_base(Holiday).select([
                            "#{Holiday.table_name}.*",
                            "'holiday'::character(7) AS event_type"
                          ])
  end

end
