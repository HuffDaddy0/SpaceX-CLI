class CliController
   #? controls the flow of the program while running    
    #!word wrap
#! git pushed, error when adding other files



    def initialize
        Api.new
        puts Rainbow(" ----------------------------------- ").blue
        puts Rainbow("|                                   |").blue
        puts Rainbow("|  Welcome to the SpaceX Launch CLI |").blue
        puts Rainbow("|     Created by: Tyler Huffman     |").blue
        puts Rainbow("|                                   |").blue
        puts Rainbow(" ----------------------------------- ").blue
        puts"                  *     .--.   "
        puts"                       / /  `  "
        puts"      +               | |   "
        puts"             '         \\ \\__,   "
        puts"         *          +   '--'  *  "
        puts"             +   /\\    "
        puts"+              .|  |.   *    "
        puts"       *      /======\\      +   "
        puts"             ;:.  _   ;   "
        puts"             |:. (_)  |   "
        puts"             |:.  _   |   "
        puts"   +         |:. (_)  |          *"
        puts"             ;:.      ;   "
        puts"           .' \\:.    / `.  "
        puts"          / .-'':._.'`-. \\  "
        puts"          |/   /.||.\\   \\|   "
        puts"        _..--**********--.._   "
        puts"  _.-'``                    ``'-._   "
        puts"-'"   
        puts Rainbow("This CLI provides info on all #{Flights.all.length} SpaceX Missions!").orange
        sleep(03)
    end

    def run
        puts ""
        puts Rainbow("Please Enter:").orange
         print Rainbow("'All'").green 
         puts "----- for a list of all SpaceX flights"
        print Rainbow("'Year'").green 
        puts "---- to see flights by a given year"
         print Rainbow("'Rocket'").green 
         puts "-- to see all flights with a given rocket type"
        print Rainbow("'Success'").green 
        puts "- to see all successful or unsuccessful flights"
         print Rainbow("'Number'").green 
         puts "-- to search a specific flight number"
        print Rainbow("'Mission'").green 
        puts "- to search by mission name"
         print Rainbow("'Random'").green 
         puts "-- to see a random launch"
        get_input_main
    end
        
      def get_input_main
        input = gets.chomp.downcase
        case input
        when 'all'
           flight_list 
        when 'year'
            year
        when 'rocket'
            rocket
        when 'success'
            success_failure
        when 'number'
            flight_number
        when 'mission'
            mission_name
        when 'random'
            random
        when 'exit'
            exit
        else 
           begin
               raise Error
           rescue Error => error
            Error.invalid_input
            get_input_main
           end
        end
    end

    def valid?(input)
        input = input.to_i
        if input > 0 && input <= Flights.all.length
            true
        else
            false
        end
    end

    def flight_list
        print_minor(Flights.all)
        secondary_selection
    end

    def year
        puts Rainbow("Please enter a year. [2006-Present]").orange
        input = gets.chomp
        if Flights.find_by_year(input) == []
            puts Rainbow("SpaceX had no flights that year!").red
            year
        elsif input == 'exit'
            exit
        else
            print_minor(Flights.find_by_year(input))
        end
        secondary_selection
    end

    def rocket
        puts Rainbow("Please select a rocket:").orange
        puts Rainbow("'Falcon 1', 'Falcon 9', 'Falcon Heavy'").green
        input = gets.chomp.downcase.split(' ').map{|i| i.capitalize}.join(' ')
         if Flights.find_by_rocket(input) != []
            print_minor(Flights.find_by_rocket(input))
            secondary_selection
         elsif input == 'Exit'
            exit
         else
            begin
            raise Error
               # begin        
            rescue Error => error
                Error.invalid_input
                rocket
           end
        end
    end

    def success_failure
        print Rainbow("Would you like to see ").orange 
        print Rainbow("successful ").green 
        print Rainbow("or ").orange 
        print Rainbow("failed ").red 
        puts Rainbow("flights?").orange
        puts Rainbow("please enter 'success' or 'fail'.").orange
        input = gets.chomp
        input.downcase!
        if input == 'success'
            print_minor(Flights.find_by_success)
            secondary_selection
        elsif input == 'fail'
            print_minor(Flights.find_by_failure)
            secondary_selection
            # puts "select a flight by number to see more infomation."
            # input2 = gets.chomp
            # Flights.find_by_flight_number(input2)
        elsif input == 'exit'
            exit
        else
            raise Error
                begin        
            rescue Error => error
             Error.invalid_input
             success_failure
            end           
        end
    end

    def flight_number
        puts Rainbow("Please choose a number: 1 - #{Flights.all.length}").orange
        input = gets.chomp
        if valid?(input)
            print_major(Flights.find_by_number(input))
            more?
        else
            begin
                raise Error
            rescue Error => error
               Error.invalid_input
               flight_number
            end
        end
    end

    def mission_name
        puts ""
        puts Rainbow("Please enter a mission name to search.").orange
        puts Rainbow("Partial matches will return all similar missions.").orange
        input = gets.chomp 
        print_minor(Flights.find_by_mission_name(input))
        secondary_selection
    end

    def print_minor(data)
        counter = 0
        data.each do |data| 
            if counter.even?
                puts Rainbow("#{data.flight_number}. #{data.mission_name}, (#{data.launch_year})").blue
                counter += 1
            else
                puts Rainbow("#{data.flight_number}. #{data.mission_name}, (#{data.launch_year})").lightblue
                counter +=1
            end
        end
    end

    def random
       puts Rainbow("RaNdOmIzInG...").blink.orange
       sleep(03)
       print_major(Flights.random_flight)
       more?
    end

    def print_major(flight)
        #binding.pry
        puts ""
        puts Rainbow("Flight #{flight.flight_number}. Mission: #{flight.mission_name}").darkblue
        puts Rainbow("This mission took place on #{flight.launch_date}, and launched from #{flight.launch_site}.")
        puts Rainbow("This flight used the #{flight.rocket} booster, and #{flight.payload} type payload.")
            if flight.crew != nil
                puts "Crew: #{flight.crew}"
            end
            if flight.launch_success == true
                puts Rainbow("#{flight.mission_name} was deemed a successful mission.").green
                puts ("#{flight.official_details}")   #!WordWrap?
            else
                puts Rainbow("#{flight.mission_name} was deemed a failed mission.").red
                puts Rainbow("#{flight.launch_failure_details_expand}")   #! WordWrap?
                puts Rainbow("#{flight.official_details}")
            end
        puts "#{}"
    end

    def secondary_selection
        puts ""
        puts Rainbow("Please enter a flight number to see more info").orange
        input = gets.chomp
        if valid?(input)
            print_major(Flights.find_by_number(input))
            more?
        elsif input == 'exit'
            exit
        else 
            begin
                raise Error
            rescue Error => error
               Error.invalid_input
               secondary_selection
            end
        end
    end

    def more?
        print Rainbow("Would you like to see another launch?").orange
        puts Rainbow(" [Y/N]").green
         print Rainbow("'Main'").green
         puts Rainbow(" will return to main menu.").orange
        input = gets.chomp.downcase
        if input == ('y' || 'yes')
            secondary_selection
        elsif input == ('n' || 'no') || input == 'exit'
            exit
        elsif input == 'main'
            run
        else
            begin
                raise Error
            rescue Error => error
               Error.invalid_input
               more?
            end
        end
    end
end

