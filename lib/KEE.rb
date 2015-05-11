require_relative 'KEE/version'
require_relative 'KEE/email_server/email_operation'
require_relative 'KEE/filter_emails/filter_emails'
require_relative 'KEE/email_format/email_format'
# email categories {:unknown,:ship_position, :not_ship_position, :personal}
module KEE

    class << self

        def new
            Class.new do
                include Singleton
                include KEE::EmailServer::EmailOperations
                include KEE::CategorizeEmails
                include KEE::FilterEmails
                include KEE::EmailFormat


                # :return [Array] of emails, each email is a [Hash] with the following format {subject:,body:,email_address:,reply_to:,date:}. [] otherwise
                def unread_emails
                    # 1) get all unread emails from the sever
                    emails = obtain_unread_emails # from KEE::EmailServer::EmailOperations
                    return [] if emails.nil?

                    # 2) categorize emails
                    emails.each do |email|
                        email[:category] =  CategorizeEmails::Operation.category(email)
                        label_email(email) # from KEE::EmailServer::EmailOperations
                    end

                    # 3) filter emails
                     FilterEmails.new(emails)

                    # 4) reformat emails and return
                    return format_emails(emails) # from KEE::EmailFormat
                end
            end.instance # return an instance
        end

        # :description establish a connection to a gmail account
        # see https://github.com/nfo/gmail_xoauth for more info
        # :param [option Hash] {auth_type: :basic , :email_address,:password}
        def config_connection(credentials)
            KEE::EmailServer::EmailConnection.config_connection(credentials)
        end
    end

end
