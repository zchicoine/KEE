require_relative 'email_connection'
module Kee
    module EmailServer
        class EmailUtilities
            include Singleton
            def initialize
                @gmail = EmailConnection.establish_connection
                self
            end

            # :param [Array] of symbols, Gmail connection which is an option param
            # :param [Integer] number of email should be read
            # :description this method access email server and retrieves param[number] emails
            # :return [Hash] {symbol: []} :Example {unread: [Array] of {subject: , from: , to: body:} of unread emails], read: [[Array] of [Hash] of read emails]}
            def obtain_emails(symbols,number)
                emails_obtain = {}
                return emails_obtain unless @gmail.logged_in?

                number_of_emails_to_retrieves = number
                symbols.each do |symbol|
                    email = @gmail.inbox.emails(symbol).take(number_of_emails_to_retrieves)
                    emails_obtain[symbol] = convert_email(email)
                end
                emails_obtain
            end

            # :description this method access email server and retrieves param[number] of emails by email address
            # :param [String] email address of the sender
            # :param [Array] of symbols, Gmail connection which is an option param
            # :param [Integer] number of email should be read
            # :return [Hash] {symbol: []} :Example {unread: [Array] of {subject: , from: , to: body:} of unread emails], read: [[Array] of [Hash] of read emails]}
            def obtain_emails_by_address(address,symbols,number)
                emails_obtain = {}
                return emails_obtain unless @gmail.logged_in?

                number_of_emails_to_retrieves = number
                symbols.each do |symbol|
                    email = @gmail.inbox.emails(symbol,:from => address).take(number_of_emails_to_retrieves)
                    emails_obtain[symbol] = convert_email(email)
                end
                emails_obtain
            end

            # :param [Hash] {email_address:,subject:,category:,date,etc}
            # :raise an exception
            def label_an_email(email)
                email[:email_object].label!("#{email[:email_address]}:#{email[:category].to_s}") #label will be automatically created new if doesn't exist
            end
            # :param [Hash] {email_address:,subject:,category:,date,etc}
            # :raise an exception
            def add_star(email)
                #email[:email_object].remove_label!("#{email[:email_address]}:#{email[:category].to_s}") #label will be automatically created new if doesn't exist

                ## because remove_label doesn't work, for now we add star to an email
                email[:email_object].star!
            end
            def remove_stars
                #email[:email_object].remove_label!("#{email[:email_address]}:#{email[:category].to_s}") #label will be automatically created new if doesn't exist

                ## because remove_label doesn't work, for now we remove star from an email
                @gmail.mailbox(:all).emails(:starred) {|email| email.unstar!}
            end
            # :description this method access email server and retrieves param[number] of emails by label
            # :param [String] email address of the sender
            # :param [Integer] number of email should be read
            # :param [Integer] categories. please see Kee::CategorizeEmails::Constants
            # :return [Hash] {label: []} :Example {unread: [Array] of {subject: , from: , to: body:} of unread emails], read: [[Array] of [Hash] of read emails]}
            def obtain_label_emails(address,number,category)
                emails_obtain = {}
                return emails_obtain unless @gmail.logged_in?

                email = @gmail.mailbox("#{address}:#{category.to_s}").emails(:unstarred).take(number)
                emails_obtain[:label] = convert_email(email)
            end
            # :description this method access email server and retrieves number of emails by label
            # :param [String] email address of the sender
            # :param [Integer] categories. please see Kee::CategorizeEmails::Constants
            # :return [int]
            def obtain_emails_status(address,category)
                emails_obtain = {}
                return emails_obtain unless @gmail.logged_in?
                begin
                    @gmail.mailbox("#{address}:#{category.to_s}").emails(:read).count
                rescue Net::IMAP::NoResponseError => e
                    0
                end

            end

            #####============================================= Private self methods ==============================================####
            private
            # :return [Array] of {subject: , email_address: , to:, body:, email_object:}
            def convert_email(emails)
                emails_array = []

                emails.each do |email|
                    # mark email as read
                    email.read!
                    email_message = email.message
                    email_hash = {}
                    email_hash[:email_object] = email
                    email_hash[:subject] = email_message.subject
                    email_hash[:email_address] = email_message.from[0] # the user email address
                    email_hash[:to] = email_message.to
                    email_hash[:body] = clean_up_email_body(email_message)
                    email_hash[:date] = email_message.date
                    email_hash[:category] = :unknown # assign the email to unknown category
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
        end
    end # EmailServer
end
