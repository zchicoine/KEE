require_relative 'KEE/version'
require_relative 'KEE/email_server/email_operation'
require_relative 'KEE/filter_emails/filter_emails'
require_relative 'KEE/email_format/email_format'
# email categories {:unknown,:ship_position, :not_ship_position, :personal}
module Kee

    class << self

        def new
            Class.new do
                include Singleton
                include Kee::EmailServer::EmailOperations
                include Kee::CategorizeEmails
                include Kee::FilterEmails
                include Kee::EmailFormat

                # :description  download 5 unread emails, categorize them, label them, filter them, and then return emails have ship info.
                # :return [Array] of emails, each email is a [Hash] with the following format {subject:,body:,email_address:,reply_to:,date:}. [] otherwise
                def unread_emails
                    # 1) get all unread emails from the sever
                    emails = obtain_unread_emails(5) # from kee::EmailServer::EmailOperations
                    return [] if emails.nil?

                    # 2) categorize emails
                    emails.each do |email|
                        email[:category] =  CategorizeEmails::Operation.category(email)
                        label_email(email) # from kee::EmailServer::EmailOperations
                    end

                    # 3) filter emails
                     FilterEmails.new(emails)

                    # 4) reformat emails and return
                    return format_emails(emails) # from kee::EmailFormat
                end

                # :description  download number of unread emails, categorize emails and label them.
                # :param[Integer] number of emails to  categorize
                # :param[String option] email address of the sender
                # :return [int] number of categorize emails
                def categorize_emails(number,address = '')
                    # 1) get all unread emails from the sever
                    emails = obtain_unread_emails_by_address(address,number) # from kee::EmailServer::EmailOperations
                    return 0 if emails.nil?
                    # 2) categorize emails
                    emails.each do |email|
                        email[:category] =  CategorizeEmails::Operation.category(email)
                        label_email(email) # from kee::EmailServer::EmailOperations
                    end
                    emails.count
                end

                # :param [String] email address of the sender
                # :param [Integer] number of email should be download 5 by default
                # :return [Array] of emails, each email is a [Hash] with the following format {subject:,body:,email_address:,reply_to:,date:}. [] otherwise
                def obtain_ship_emails(address,number = 5)
                    begin
                        emails = obtain_label_emails_by_category(address,number,CategorizeEmails::Constants::SHIP_POSITION_EMAIL)
                        emails.each do |email|
                            add_star(email) # from kee::EmailServer::EmailOperations
                        end
                       return format_emails(emails) # from kee::EmailFormat
                    rescue Exception => e
                        p "Kee Errors: #{e}"
                    end
                    []
                end

                # :description get the number of categorized emails
                # :param [String] email address of the sender
                # :param [Integer] number of email should be download 5 by default
                # :return [Hash] {num_ship:,num_order:,num_personal:,num_not_ship:}.
                def obtain_emails_status(address)
                    begin
                        emails_status = {}
                        emails_status[:num_ship] = obtain_emails_status_by_category(address,CategorizeEmails::Constants::SHIP_POSITION_EMAIL)
                        emails_status[:num_order] = obtain_emails_status_by_category(address,CategorizeEmails::Constants::ORDERS_EMAIL)
                        emails_status[:num_personal] = obtain_emails_status_by_category(address,CategorizeEmails::Constants::PERSONAL_EMAIL)
                        emails_status[:num_not_ship] = obtain_emails_status_by_category(address,CategorizeEmails::Constants::NOT_SHIP_POSITION_EMAIL)
                        return emails_status
                    rescue Exception => e
                        p "Kee Errors: #{e}"
                    end
                    []
                end

            end.instance # return an instance


        end

        # :description establish a connection to a gmail account
        # see https://github.com/nfo/gmail_xoauth for more info
        # :param [option Hash] {auth_type: :basic , :email_address,:password}
        def config_connection(credentials)
            Kee::EmailServer::EmailConnection.config_connection(credentials)
        end
    end

end
