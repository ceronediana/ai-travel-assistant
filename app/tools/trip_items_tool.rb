class TripItemsTool < RubyLLM::Tool
  description "Add trip items to trip based on the chats."

  param :trip_item_name, desc: "The name of the trip item"

  def initialize(trip_id:)
    @trip_id = trip_id
  end

  def execute(trip_item_name:)
    trip = Trip.find(@trip_id)
    trip_item = TripItem.create!(
      trip: trip,
      name: trip_item_name,
      notes: "Add notes for this item"
    )
    { trip_item_id: trip_item.id, trip: trip.name, name: trip_item_name }
  rescue ActiveRecord::RecordNotFound
    { error: "Trip not found" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end

end
