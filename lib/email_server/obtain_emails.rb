# Read email from Email Server
require_relative 'email_utilities'
module ObtainEmails

    # :description access the email and obtaining all unread emails.
    # :return [Array] of [Hash] unread emails
    def obtain_unread_emails
       result = EmailUtilities.obtain_emails(%i(unread))
       result[:unread]
    end

    # :description access the email and obtaining all read emails.
    # :return [Array] of [Hash] read emails
    def obtain_read_emails
        result = EmailUtilities.obtain_emails(%i(read))
        result[:read]
    end

end
