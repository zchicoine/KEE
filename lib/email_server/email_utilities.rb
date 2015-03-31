require_relative 'email_connection'
module EmailUtilities
    class << self

        # :param [Array] of symbols
        # :description this method access email server and retrieves 5 emails
        # :return [Hash] {symbol: []} :Example {unread: [Array] of {subject: , from: , to: body:} of unread emails], read: [[Array] of [Hash] of read emails]}
        def obtain_emails(symbols)
           # connect to gmail
            emails_obtain = {}
            gmail = EmailConnection.establish_connection
            return emails_obtain unless gmail.logged_in?
            number_of_emails_to_retrieves = 5
            symbols.each do |symbol|
                email = gmail.inbox.emails(symbol,:from => "shahrad.rezaei@shah-network.com").take(number_of_emails_to_retrieves)
                emails_obtain[symbol] = convert_email(email)
            end
            return emails_obtain
        end

        private
        # :return [Array] of {subject: , from: , to: body:}
        def convert_email(emails)
            emails_array = []
                i = 0
            emails.each do |email|
                email_message = email.message
                email_hash = {}
                i=  i + 1
                email_hash[:subject] = email_message.subject
                email_hash[:from] = email_message.from
                email_hash[:to] = email_message.to
                email_hash[:body] = clean_up_email_body(email_message)
                email_hash[:date] = email_message.date
                email_hash[:category] = :unknown
                emails_array.push(email_hash)

            end

            return emails_array
        end

        def clean_up_email_body(email_message)

            parts = email_message.parts

            if parts.length > 0
                return ''
            else
                return email_message.body.to_s
            end
        end

    end # class self

end