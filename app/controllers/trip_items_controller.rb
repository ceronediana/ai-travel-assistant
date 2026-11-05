class TripItemsController < ApplicationController
  before_action :set_trip
  before_action :set_trip_item, only: %i[show edit update destroy]
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

  def edit
  end

  def update
    if @trip_item.update(trip_item_params)
      redirect_to trip_path(@trip), notice: "Trip item updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip_item.destroy
    redirect_to trip_path(@trip), notice: "Trip Item deleted"
  end

  private

  def trip_item_params
    params.require(:trip_item).permit(:name, :notes)
  end

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_trip_item
    @trip_item = @trip.trip_items.find(params[:id])
  end
end
