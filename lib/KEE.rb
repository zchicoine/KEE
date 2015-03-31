require 'KEE/version'
require 'obtain_emails'
require_relative 'filter_emails/filter_emails'

# email categories {:unknown,:ship_position, :not_ship_position, :personal}
module KEE
    extend ObtainEmails
    extend FilterEmails
    include EmailCategories
    emails = obtain_read_emails
    unless emails.nil?
        emails.each do |email|
         p  email[:category] =  filter_email(email)
         if email[:category] == SHIP_POSITION_EMAIL
             File.new('ship_found.txt','w').write(email[:body])
         end
        end
    end
end
