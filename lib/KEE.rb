require 'KEE/version'
require 'obtain_emails'
module KEE
    extend ObtainEmails
    emails = obtain_read_emails
    unless emails.nil?
        emails.each do |email|
            p email[:subject]
        end
    end

end
