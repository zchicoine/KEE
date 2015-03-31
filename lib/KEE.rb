require 'KEE/version'
require 'obtain_emails'
require 'filter_emails'

# email categories {:unknown,:ship_position, :not_ship_position, :personal}
module KEE
    extend ObtainEmails
    extend FilterEmails
    emails = obtain_read_emails
    unless emails.nil?
        emails.each do |email|
         p  email[:category] =  filter_email(email)

         if email[:category] == :ship_position
             File.new('t.txt','w').write(email[:body])
         end
        end
    end
end
