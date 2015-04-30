require_relative 'KEE/version'
require_relative 'KEE/email_server/obtain_emails'
require_relative 'KEE/filter_emails/filter_emails'
require_relative 'KEE/email_format/email_format'
# email categories {:unknown,:ship_position, :not_ship_position, :personal}
module KEE

    class << self

        def new
            Class.new do
                include Singleton
                include KEE::EmailServer::ObtainEmails
                include KEE::FilterEmails
                include KEE::EmailFormat
                include KEE::EmailCategories

                # :return [Array] of emails, each email is a [Hash] with the following format {subject:,body:,from:,reply_to:,date:}. [] otherwise
                def unread_emails
                    # get all unread emails from the sever
                    emails = obtain_unread_emails
                    return [] if emails.nil?

                    # filter each email
                    emails.each do |email|
                        email[:category] =  filter_email(email)
                    end
                    # delete emails that not Ship position
                    emails.delete_if {|email| email[:category] != KEE::EmailCategories::SHIP_POSITION_EMAIL}

                    # reformat emails and return
                    return format_emails(emails)
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
