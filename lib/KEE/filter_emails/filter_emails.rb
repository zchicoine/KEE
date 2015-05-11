require_relative '../categorize_email/categorize_operation'

module KEE
    module FilterEmails
        include CategorizeEmails
        class << self
            # :param [Array] of emails
            # :return ship emails only
            def new(emails)
                emails.delete_if {|email| email[:category] != CategorizeEmails::Constants::SHIP_POSITION_EMAIL}
                emails
            end
        end
    end
end
