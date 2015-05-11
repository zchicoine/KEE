###
# Categorize emails to personal, ship ,order or not ship
# Also label emails to Personal, Ship, Orders or Not ship
###
require_relative 'constants'
require_relative 'keys_identifiers/obtain_key_identifiers'
module KEE
    module CategorizeEmails
       module Operation
            include CategorizeEmails::Constants
            class << self
                # :param [Hash] {body:,email_address:,subject:,category:,etc}
                # :description categorize email to personal , ship, order, or not ships
                # 1) check personal
                # 2) check ship
                # 3) check order
                # 4) if none of the above then not ships
                def category(email)
                    email_category = Constants::UNKNOWN_EMAIL
                    email_category = check_personal(email[:subject]) if email_category == Constants::UNKNOWN_EMAIL
                    email_category = check_ship(email[:body]) if email_category == Constants::UNKNOWN_EMAIL
                    email_category = check_order(email[:body]) if email_category == Constants::UNKNOWN_EMAIL
                    email_category = Constants::NOT_SHIP_POSITION_EMAIL if email_category == Constants::UNKNOWN_EMAIL
                    email_category
                end


                private
                # :param [String]
                # :return [Symbol] :personal or :unknown
                def check_personal(email_subject)

                    if  email_subject.downcase.include? 're:'
                        Constants::PERSONAL_EMAIL
                    else
                        Constants::UNKNOWN_EMAIL
                    end
                end

                # :param [String]
                # :description check if the email contains more than 1 ship key identifiers that list on filter_emails/ship_key_identifiers.json
                # :return [Symbol] :ship_position or :not_ship_position
                def check_ship(email_body)
                    counter = 0
                    unless email_body.blank?
                        CategorizeEmails::KeysIdentifiers::ObtainKeyIdentifiers.instance.ship.each do |key|
                            if email_body.downcase.include? key
                                counter = counter + 1
                            end
                        end
                    end

                    (counter > 1) ? Constants::SHIP_POSITION_EMAIL :  Constants::UNKNOWN_EMAIL
                end

                # :param [String]
                # :description check if the email contains more than 1 ship key identifiers that list on filter_emails/ship_key_identifiers.json
                # :return [Symbol] :order or :unknown
                def check_order(email_body)
                    counter = 0
                    unless email_body.blank?
                        CategorizeEmails::KeysIdentifiers::ObtainKeyIdentifiers.instance.order.each do |key|
                            if email_body.downcase.include? key
                                counter = counter + 1
                            end
                        end
                    end
                    (counter > 1) ? Constants::ORDERS_EMAIL :  Constants::UNKNOWN_EMAIL
                end
            end
       end
    end
end