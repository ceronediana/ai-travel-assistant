class TripItemsController < ApplicationController
  before_action :set_trip_item, only: [:show]
  def new
    @trip_item = TripItem.new
  end

  def create
    @trip_item = TripItem.new(trip_item_params)
    if @trip_item.save
      redirect_to trip_item_path(@trip_item), notice: "Trip item created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def trip_item_params
    params.require(:trip_item).permit(:name, :notes, :trip_id)
  end

  def set_trip_item
    @trip_item = TripItem.find(params[:id])
  end
end
