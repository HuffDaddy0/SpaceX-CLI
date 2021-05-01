class Flights
#? creates and stores instances of each individual flight with info
    
    attr_accessor :flight_number, :mission_name, :rocket, :is_tentative, :launch_year,
     :launch_success, :launch_site, :launch_date, :details, :crew, :launch_failure_details,
     :payload

    @@all = []

    def initialize(flight_hash)
        flight_hash.each {|k, v| self.send("#{k}=", v)}
        @@all << self
    end

    def self.all
         @@all
    end

    def launch_date
        cut_time = @launch_date.split('T')
        @launch_date = cut_time[0]
    end

    def official_details
        puts "Official Flight Details: #{self.details}"
    end

    def launch_failure_details_expand
        puts "This launch lasted #{self.launch_failure_details["time"]} seconds."
        puts "#{self.failure_altitude_conversion}"
        puts "Problem: #{self.launch_failure_details["reason"]}"
    end

    def failure_altitude_conversion
        if self.launch_failure_details["altitude"] == nil
            puts "The rocket did not leave the ground."
        else
            puts "It reached an altitude of #{self.launch_failure_details['altitude']} km."
        end
    end

    def self.find_by_number(number)
        @@all.find {|f| f.flight_number == number.to_i}
    end

    def self.find_by_mission_name(name)
        self.all.find_all {|f| f.mission_name.downcase.include?(name)}
    end

    def self.find_by_success
        self.all.find_all {|f| f.launch_success == true}
    end

    def self.find_by_failure
        self.all.find_all {|f| f.launch_success == false}
    end

    def self.find_by_rocket(name)
        self.all.find_all {|f| f.rocket == name}
    end

    def self.find_by_year(year)
        self.all.find_all {|f| f.launch_year == year}
    end

    def self.random_flight
        self.find_by_number(rand(1..(Flights.all.length+1)))
    end
end