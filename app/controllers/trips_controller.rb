class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find(params[:id])
  end

  def new
    @trip = Trip.new
  end

  def confirm
    @trip = Trip.new(trip_params)
    render :confirm
  end

  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      redirect_to trip_path(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    trip = Trip.find(params[:id])
    # #chat = trip.chat
    trip.destroy
    redirect_to trips_path, notice: "Trip deleted"
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :photo)
  end
end
