class TripItemsController < ApplicationController
  before_action :set_trip, only: %i[new create]
  def new
    @trip_item = @trip.trip_items.new
  end

  def create
    @trip_item = @trip.trip_items.new(trip_item_params)

    if @trip_item.save
      redirect_to trip_path(@trip), notice: "Trip item created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def trip_item_params
    params.require(:trip_item).permit(:name, :notes)
  end

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end
end
