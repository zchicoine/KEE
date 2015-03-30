require 'gmail'
module EmailConnection

    class << self

        def establish_connection
           return  Gmail.connect('mah.sync24@gmail.com', '***')
        end
    end # class self

    def a

    end
end