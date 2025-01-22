# Write your soltuion here!
require "dotenv/load"
require "http"

pp "What is your current location?"
location = gets.chomp
#location = "427 West Walnut Street, Hinsdale, Illinois"

# Google Location 
google_key = ENV.fetch("google_key")
google_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{google_key}"

data = HTTP.get(google_url)
clean = JSON.parse(data)
results = clean.fetch('results')[0]
results2 = results.fetch('navigation_points')[0].fetch('location')
lat = results2.fetch('latitude')
long = results2.fetch('longitude')

# Weather Finding
weather_key = ENV.fetch("weather_key")
weather_url = "https://api.pirateweather.net/forecast/" + weather_key + "/" + lat.to_s + "," + long.to_s + ""

raw_response = HTTP.get(weather_url)
parsed = JSON.parse(raw_response)
curr = parsed.fetch("currently")
temp = curr.fetch("temperature")
pp "The current temperature is #{temp} degrees Fahrenheit!"

# How the Time works
require 'time'
hours = parsed.fetch("hourly")
# time = hourly['data'][1].fetch('time')
# time2 = Time.at(time).utc

hourly = hours.fetch('data')[0,12]

need_umbrella = false
counter = 1

hourly.each do |thing|
  prob = thing.fetch('precipProbability')
  if prob > 0.1
    need_umbrella = true
    pp "The probability that it rains is #{prob*100}% in #{counter} hours."
  end
  counter = counter + 1
end

if need_umbrella
  pp "You might want to bring an umbrella today!"
else
  pp "You probably won't need an umbrella today."
end
