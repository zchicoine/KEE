# Read email from Email Server
require_relative 'email_utilities'
module KEE
    module EmailServer
        module EmailOperations

            # :description access the email and obtaining all unread emails.
            # :return [Array] of [Hash] unread emails
            def obtain_unread_emails
                result = EmailUtilities.instance.obtain_emails(%i(unread))
                result[:unread]
            end

            # :description access the email and obtaining all read emails.
            # :return [Array] of [Hash] read emails
            def obtain_read_emails
                result = EmailUtilities.obtain_emails(%i(read))
                result[:read]
            end

            # :param [Hash] {email_address:,subject:,category:,date,etc}
            def label_email(email)
                EmailUtilities.instance.label_an_email(email)
            end

        end
    end # EmailServer
end

