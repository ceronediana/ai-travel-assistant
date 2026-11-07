require "json"
require "open-uri"
require "date"

class WeatherTool < RubyLLM::Tool
  description "Get current weather conditions and forecasts for a city."
  param :city, desc: "The city to get weather information for"
  param :start_date, desc: "The travel start date in YYYY-MM-DD format", required: false
  param :end_date, desc: "The travel end date in YYYY-MM-DD format", required: false

  def execute(city:, start_date: nil, end_date: nil)
    if start_date && end_date
      last_forecast_date = Date.today + 15
      trip_end_date = Date.parse(end_date)
      trip_start_date = Date.parse(start_date)

      if trip_start_date < Date.today
        return "Sorry, weather forecasts are not available for past dates."
      end

      if trip_end_date > last_forecast_date
        return "Sorry, weather forecasts are only available up to 16 days in advance."
      end

      if trip_end_date < trip_start_date
        return "Sorry, the trip end date cannot be before the start date."
      end
    end

    url = "https://geocoding-api.open-meteo.com/v1/search?name=#{city}&count=1"
    response = URI.parse(url).read
    data = JSON.parse(response)

    if data["results"].nil?
      return "Sorry, I couldn't find that city."
    end

    latitude = data["results"][0]["latitude"]
    longitude = data["results"][0]["longitude"]

    if start_date && end_date
      weather_url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&start_date=#{start_date}&end_date=#{end_date}"
    else
      weather_url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&current=temperature_2m&timezone=auto"
    end

    weather_response = URI.parse(weather_url).read
    weather_data = JSON.parse(weather_response)

    if start_date && end_date
      dates = weather_data["daily"]["time"]
      forecasts = []

      dates.each_with_index do |date, index|
        minimum_temperature = weather_data["daily"]["temperature_2m_min"][index]
        maximum_temperature = weather_data["daily"]["temperature_2m_max"][index]
        precipitation_probability = weather_data["daily"]["precipitation_probability_max"][index]

        forecasts << "#{date}: Min #{minimum_temperature}°C, Max #{maximum_temperature}°C, Rain #{precipitation_probability}%"
      end

      forecasts.join("\n")
    else
      temperature = weather_data["current"]["temperature_2m"]
      "The current temperature in #{city} is #{temperature}°C."
    end
  rescue => e
    { error: e.message }
  end
end
