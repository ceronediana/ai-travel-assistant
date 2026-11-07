class TripItemsTool < RubyLLM::Tool
  description "Add trip items to trip based on the chats."

  param :trip_item_name, desc: "A short, clear name for the trip item, without descriptions or extra details"
  param :trip_item_notes, desc: "Additional details about the trip item, if provided by the user", required: false

  def initialize(trip_id:)
    @trip_id = trip_id
  end

  def execute(trip_item_name:, trip_item_notes: nil)
    trip = Trip.find(@trip_id)
    trip_item = TripItem.create!(
      trip: trip,
      name: trip_item_name,
      notes: trip_item_notes
    )
    { trip_item_id: trip_item.id, trip: trip.name, name: trip_item.name, notes: trip_item.notes }
  rescue ActiveRecord::RecordNotFound
    { error: "Trip not found" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end

end
