class ChatsController < ApplicationController
  def create
    @chat = Chat.new
    @chat.user = current_user
    @trip = Trip.find(params[:trip_id])
    @chat.trip = @trip
  end

  def show
    @chat = Chat.find(params[:id])
  end

  def destroy
    @chat = Chat.find(params[:id])
    @trip = @chat.trip
    @chat.destroy

    redirect_to trip_path(@trip)
  end
end
