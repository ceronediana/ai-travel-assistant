# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

trip_data = [
  {
    name: "Tokyo Adventure",
    destination: "Tokyo, Japan",
    start_date: Date.today + 60,
    end_date: Date.today + 70
  },
  {
    name: "NYC Weekend",
    destination: "New York City, USA",
    start_date: Date.today + 10,
    end_date: Date.today + 13
  },
  {
    name: "Rome Trip",
    destination: "Rome, Italy",
    start_date: Date.today + 45,
    end_date: Date.today + 52
  }
]

user = "meow"

trip_data.each do |trip|
  Trip.create(
    name: trip[:name],
    destination: trip[:destination],
    start_date: trip[:start_date],
    end_date: trip[:end_date],
    user: user
  )
end
