require 'pry'

class Api
#? Pulls data from API and creates flights
    attr_accessor :info

    #URL = api.spacexdata.com/v2/launches

    def initialize
        uri = URI.parse('https://api.spacexdata.com/v2/launches')
        response = Net::HTTP.get_response(uri)
        @info = JSON.parse(response.body)
        self.create_flights
#        binding.pry
    end

    def create_flights
        @info.each do |flight|
            #binding.pry
            hash = {flight_number: flight['flight_number'],
                launch_year: flight['launch_year'],
                mission_name: flight['mission_name'],
                rocket: flight['rocket']['rocket_name'],
                is_tentative: flight['is_tentative'],
                launch_success: flight['launch_success'],
                launch_site: flight['launch_site']['site_name_long'],
                launch_date: flight['launch_date_utc'],
                details: flight['details'],
                crew: flight['crew'],
                launch_failure_details: flight['launch_failure_details'],
                payload: flight['rocket']['second_stage']['payloads'][0]['payload_type']
            }
            Flights.new(hash)
        end
    end

end

#:flight_number, :mission_name, :rocket, :is_tentative, :launch_year,
#:launch_success, :launch_site, :launch_date, :details, :crew, :launch_failure_details