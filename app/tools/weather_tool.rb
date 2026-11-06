class WeatherTool < RubyLLM::Tool
  description "Get current weather conditions and forecasts for a city."
  param :city, desc: "The city to get weather information for"

  def execute(city:)
    "Weather information for #{city} will go here."
  end
end
