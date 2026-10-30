# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Trip.create(name: "Tokyo Adventure",
    destination: "Tokyo, Japan",
    user: "meow",
    start_date: Date.today + 60,
    end_date: Date.today + 70)

    Trip.create(name: "NYC Weekend",
    destination: "New York City, USA",
    user: "meow"
    start_date: Date.today + 10,
    end_date: Date.today + 13)


Trip.create(name: "Rome Trip",
    destination: "Rome, Italy",
    user: "meow",
    start_date: Date.today + 45,
    end_date: Date.today + 52
    )
