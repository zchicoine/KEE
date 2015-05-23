###
# TODO explain the class responsibility
###
require 'singleton'
module Kee
    module CategorizeEmails
        module KeysIdentifiers
            class ObtainKeyIdentifiers
                include Singleton

                # :return [Array]
                def ship
                    keys = get_ship_keys
                    keys unless keys.blank?
                end

                # :return [Array]
                def order
                    keys = get_order_keys
                    keys unless keys.blank?
                end


                private
                # :description obtain ships keys from a json file
                # :return [Array]
                def get_ship_keys
                    file = File.read(File.expand_path('../ship_key_identifiers.json', __FILE__))
                    JSON.parse(file)
                end

                # :description obtain order keys from a json file
                # :return [Array]
                def get_order_keys
                    file = File.read(File.expand_path('../order_key_identifiers.json', __FILE__))
                    JSON.parse(file)
                end
            end
        end
    end
end
