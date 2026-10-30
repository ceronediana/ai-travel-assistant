class ChatsController < ApplicationController
  def create
    @chat = Chat.new
    @chat.user = current_user
    @trip = current_user.trips.find(params[:trip_id])
    @chat.trip = @trip
    if @chat.save
      redirect_to chat_path(@chat), notice: "Chat created successfully."
    else
      redirect_to trip_path(@trip), alert: "Unable to create chat."
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
  end

  def destroy
    @chat = current_user.chats.find(params[:id])
    @trip = @chat.trip
    @chat.destroy
    redirect_to trip_path(@trip), status: :see_other
  end
end
