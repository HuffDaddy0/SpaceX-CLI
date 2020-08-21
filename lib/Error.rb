class Error < StandardError

    def self.invalid_input
        puts Rainbow("ERROR: Invalid input, please try again.").crimson.underline
    end

end