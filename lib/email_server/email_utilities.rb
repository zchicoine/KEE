require_relative 'email_connection'
module EmailUtilities
    class << self

        # :param [Array] of symbols
        # :description this method access email server and retrieves 5 emails
        # :return [Hash] {symbol: []} :Example {unread: [Array] of {subject: , from: , to: body:} of unread emails], read: [[Array] of [Hash] of read emails]}
        def obtain_emails(symbols)
           # connect to gmail
            emails_obtain = {}
           p gmail = EmailConnection.establish_connection
            return emails_obtain unless gmail.logged_in?
            number_of_emails_to_retrieves = 5
            symbols.each do |symbol|
                emails_obtain[symbol] = convert_email(gmail.inbox.emails(symbol).take(number_of_emails_to_retrieves))
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
                email_hash[:body] = email_message.body.decoded
                email_hash[:date] = email_message.date
                emails_array.push(email_hash)

            end

            return emails_array
        end

    end # class self

end