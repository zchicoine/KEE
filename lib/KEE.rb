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

                # :description  download 5 unread emails, categorize them, label them, filter them, and then return emails have ship info.
                # :return [Array] of emails, each email is a [Hash] with the following format {subject:,body:,email_address:,reply_to:,date:}. [] otherwise
                def unread_emails
                    # 1) get all unread emails from the sever
                    emails = obtain_unread_emails(5) # from KEE::EmailServer::EmailOperations
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

                # :description  download number of unread emails, categorize emails and label them.
                # :param[Integer] number of emails to  categorize
                # :param[String option] email address of the sender
                # :return [Array] of emails, each email is a [Hash] with the following format {subject:,body:,email_address:,reply_to:,date:}. [] otherwise
                def categorize_emails(number,address = '')
                    # 1) get all unread emails from the sever
                    emails = obtain_unread_emails_by_address(address,number) # from KEE::EmailServer::EmailOperations
                    return [] if emails.nil?

                    # 2) categorize emails
                    emails.each do |email|
                        email[:category] =  CategorizeEmails::Operation.category(email)
                        label_email(email) # from KEE::EmailServer::EmailOperations
                    end
                end

                # :param [String] email address of the sender
                # :param [Integer] number of email should be download 5 by default
                # :return [Array] of emails, each email is a [Hash] with the following format {subject:,body:,email_address:,reply_to:,date:}. [] otherwise
                def obtain_ship_emails(address,number = 5)
                    emails = obtain_label_emails_by_category(address,number,CategorizeEmails::Constants::SHIP_POSITION_EMAIL)
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
