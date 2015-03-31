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
            emails_obtain
        end

        #####============================================= Private self methods ==============================================####

        private
        # :return [Array] of {subject: , from: , to: body:}
        def convert_email(emails)
            emails_array = []

            emails.each do |email|
                # mark email as read
                email.read!
                email_message = email.message
                email_hash = {}
                email_hash[:subject] = email_message.subject
                email_hash[:from] = email_message.from
                email_hash[:to] = email_message.to
                email_hash[:body] = clean_up_email_body(email_message)
                email_hash[:date] = email_message.date
                email_hash[:category] = :unknown
                emails_array.push(email_hash)

            end
             emails_array
        end

        # :param [Mail::Message]
        # :description delete attachments, and only extract text/plan content type
        # :return [String] email body or empty string
        def clean_up_email_body(email_message)

            # delete attachments
             email_message.without_attachments!

            parts = email_message.parts

            if parts.length > 0
                # parts Default sort is to 'text/plain', then 'text/enriched', then 'text/html' with any other content
                text_plain_body = parts[0].body
                unless text_plain_body.empty?
                    return text_plain_body.to_s
                else
                    return ''
                end
            else
                return  email_message.body.to_s
            end
        end
    end # class self

end