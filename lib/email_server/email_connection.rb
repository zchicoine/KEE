require 'gmail'
module EmailConnection

    class << self

        def establish_connection
            Gmail.connect('mah.sync24@gmail.com', '***')
        end
    end # class self
end