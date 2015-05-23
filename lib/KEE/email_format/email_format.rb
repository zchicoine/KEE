# reformat email to be pass to Email Recognition script

module Kee
    module EmailFormat

        # :param [Array] of [Hash] {subject:,body:,to:,email_address:,category:,date:}
        # :description convert the email to the format that Email Recognition accept
        # :return [Array] of [Hash] {subject:,body:,email_address:,reply_to:,date:}
        def format_emails(emails)
            emails_array = []
            emails.each do |email|
                email_hash = {}
                email_hash[:subject] = email[:subject]
                email_hash[:body] = email[:body]
                email_hash[:email_address] = email[:email_address]
                email_hash[:reply_to] = nil
                email_hash[:date] = email[:date]
                emails_array.push(email_hash)
            end
            emails_array
        end
    end
end
