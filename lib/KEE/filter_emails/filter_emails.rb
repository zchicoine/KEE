# Filter Emails to {ship, no ships and personal}
require_relative 'ship_key_identifiers'
require_relative '../email_categories'
module KEE
    module FilterEmails
        include KEE::EmailCategories

        # :param [Hash] {body:,from:,subject:,category:,etc}
        # :description categories emails to personal, ship or no ships
        # :return [Symbol] :personal or :ship_position or :not_ship_position
        def filter_email(email)
            email_category = check_email_subject(email[:subject])

            if email_category == :unknown
                email_category = check_email_body(email[:body])
            end

            email_category
        end


        #####============================================= Private methods ==============================================####
        private

        # :param [String]
        # :return [Symbol] :personal or :unknown
        def check_email_subject(email_subject)

            if  email_subject.downcase.include? 're:'
                PERSONAL_EMAIL
            else
                UNKNOWN_EMAIL
            end
        end

        # :param [String]
        # :description check if the email contains more than 2 ship key identifiers that list on filter_emails/ship_key_identifiers.json
        # :return [Symbol] :ship_position or :not_ship_position
        def check_email_body(email_body)
            counter = 0
            unless email_body.blank?
                KEE::FilterEmails::ShipKeyIdentifiers.instance.ship_key_identifiers.each do |key|
                    if email_body.include? key
                        counter = counter + 1
                    end
                end
            end

            (counter > 2) ?  SHIP_POSITION_EMAIL :  NOT_SHIP_POSITION_EMAIL
        end
    end
end
