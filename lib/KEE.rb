require 'KEE/version'
require_relative 'email_server/obtain_emails'
require_relative 'filter_emails/filter_emails'
require_relative 'email_format/email_format'
# email categories {:unknown,:ship_position, :not_ship_position, :personal}
module KEE
    extend ObtainEmails
    extend FilterEmails
    extend EmailFormat
    include EmailCategories

    class << self

        # :description do noting for now
        def new

        end

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
            emails.delete_if {|email| email[:category] != SHIP_POSITION_EMAIL}

            # reformat emails and return
            return format_emails(emails)
        end
    end


    ###
    # for testing purpose
    ###
    #p  KEE.unread_emails
    # emails = obtain_read_emails
    # unless emails.nil?
    #     emails.each do |email|
    #      p  email[:category] =  filter_email(email)
    #      if email[:category] == SHIP_POSITION_EMAIL
    #          File.new('ship_found.txt','w').write(email[:body])
    #      end
    #     end
    # end
end
