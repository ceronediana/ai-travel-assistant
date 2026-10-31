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
    @trip.user = current_user

    if @trip.save
      redirect_to trip_path(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
    @trip.update(trip_params)
    redirect_to trip_path(@trip)
  end

  def destroy
    trip = Trip.find(params[:id])
    # #chat = trip.chat
    trip.destroy
    redirect_to trips_path, notice: "Trip deleted"
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :destination, :start_date, :end_date, :user_id, :photo)
  end
end
