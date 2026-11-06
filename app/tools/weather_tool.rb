require "json"
require "open-uri"

class WeatherTool < RubyLLM::Tool
  description "Get current weather conditions and forecasts for a city."
  param :city, desc: "The city to get weather information for"

  def execute(city:)
    url = "https://geocoding-api.open-meteo.com/v1/search?name=#{city}&count=1"
    response = URI.parse(url).read
    data = JSON.parse(response)

    if data["results"].nil?
      return "Sorry, I couldn't find that city."
    end

    latitude = data["results"][0]["latitude"]
    longitude = data["results"][0]["longitude"]

    weather_url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&current=temperature_2m&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto"
    weather_response = URI.parse(weather_url).read
    weather_data = JSON.parse(weather_response)

    dates = weather_data["daily"]["time"]

    forecasts = []

    dates.each_with_index do |date, index|
      minimum_temperature = weather_data["daily"]["temperature_2m_min"][index]
      maximum_temperature = weather_data["daily"]["temperature_2m_max"][index]
      precipitation_probability = weather_data["daily"]["precipitation_probability_max"][index]

      forecasts << "#{date}: Min #{minimum_temperature}°C, Max #{maximum_temperature}°C, Rain #{precipitation_probability}%"
    end

    temperature = weather_data["current"]["temperature_2m"]

    "The current temperature in #{city} is #{temperature}°C.\n\n#{forecasts.join("\n")}"
  end

rescue => e
  { error: e.message }
end
