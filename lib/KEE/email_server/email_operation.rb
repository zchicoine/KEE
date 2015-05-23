# Read email from Email Server
require_relative 'email_utilities'
module Kee
    module EmailServer
        module EmailOperations

            # :description access the email and obtaining all unread emails.
            # :param [Integer] number of email should be download
            # :return [Array] of [Hash] unread emails
            def obtain_unread_emails(number)
                result = EmailUtilities.instance.obtain_emails(%i(unread),number)
                result[:unread]
            end

            # :description access the email and obtaining all unread emails.
            # :param [Integer] number of email should be download
            # :return [Array] of [Hash] unread emails
            def obtain_unread_emails_by_address(address,number)
                result = EmailUtilities.instance.obtain_emails_by_address(address,%i(unread),number)
                result[:unread]
            end

            # :description access the email and obtaining all label emails.
            # :param [String] email address of the sender
            # :param [Integer] number of email should be read
            # :param [Integer] categories. please see Kee::CategorizeEmails::Constants
            # :return [Hash] :Example {unread: [Array] of {subject: , from: , to: body:} of unread emails], read: [[Array] of [Hash] of read emails]}
            def obtain_label_emails_by_category(address,number,category)
                 EmailUtilities.instance.obtain_label_emails(address,number,category)
            end

            # :description access the email and obtaining all read emails.
            # :param [Integer] number of email should be download
            # :return [Array] of [Hash] read emails
            def obtain_read_emails(number)
                result = EmailUtilities.obtain_emails(%i(read),number)
                result[:read]
            end

            # :param [Hash] {email_address:,subject:,category:,date,etc}
            def label_email(email)
                EmailUtilities.instance.label_an_email(email)
            end


        end
    end # EmailServer
end

