# Filter Emails to {ship, no ships and personal}
require_relative 'filter_emails/ship_key_identifiers'
module FilterEmails

    # :param [Hash] {body:,from:,subject:,category:,etc}
    # :description categories emails to personal, ship or no ships
    # :return [Symbol] :personal or :ship_position or :not_ship_position
    def filter_email(email)

        email_category = check_email_subject(email[:subject])
        if email_category == :unknown
            email_category = check_email_body(email[:body])
        end
        return email_category
    end


    private

    # :param [String]
    # :return [Symbol] :personal or :unknown
    def check_email_subject(email_subject)
        if  email_subject.include? 'Re:'
            return :personal
        else
            return :unknown
        end
    end

    # :param [String]
    # :return [Symbol] :ship_position or :not_ship_position
    def check_email_body(email_body)
        counter = 0
        ShipKeyIdentifiers.instance.ship_key_identifiers.each do |key|
           # if email_body.include? key
           #      counter = counter + 1
           # end
        end
        if counter > 2
            return :ship_position
        else
            return :not_ship_position
        end

    end
end