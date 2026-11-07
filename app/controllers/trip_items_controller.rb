class TripItemsController < ApplicationController
  before_action :set_trip, only: %i[new create]
  before_action :set_trip_item, only: %i[edit update destroy]

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

  def edit
    @trip = @trip_item.trip
  end

  def category
  end

  def update
    @trip = @trip_item.trip
    if @trip_item.update(trip_item_params)
      redirect_to trip_path(@trip), notice: "Trip item updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip = @trip_item.trip
    @trip_item.destroy
    redirect_to trip_path(@trip), notice: "Trip item deleted"
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_trip_item
    @trip_item = TripItem.find(params[:id])
  end

  def trip_item_params
    params.require(:trip_item).permit(:name, :notes, tag_list: [])
  end
end
