class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def show
    @trips = Trip.find(params[:id])
  end
end
