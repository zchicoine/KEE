# reformat email to be pass to Email Recognition script

module EmailFormat

    # :param [Array] of [Hash] {subject:,body:,to:,from:,category:,date:}
    # :description convert the email to the format that Email Recognition accept
    # :return [Array] of [Hash] {subject:,body:,from:,reply_to:,date:}
    def format_emails(emails)
        emails_array = []
        emails.each do |email|
            email_hash = {}
            email_hash[:subject] = email[:subject]
            email_hash[:body] = email[:body]
            email_hash[:from] = email[:from]
            email_hash[:reply_to] = nil
            email_hash[:date] = email[:date]
            emails_array.push(email_hash)
        end
        emails_array
    end
end