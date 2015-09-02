class SwapRequestsController < ApplicationController

  respond_to :json

  def create
    swap_request =  SwapRequest.create(
      source_id: params[:src_schedule_id],
      target_id: params[:target_schedule_id]
    )
    render json: swap_request
  end

end
