###
# TODO explain the class responsibility
###
require 'singleton'
module KEE
    module FilterEmails
        class ShipKeyIdentifiers
            include Singleton

            # :description TODO
            # :return [Array]
            def ship_key_identifiers
                keys = get_key_identifiers
                keys unless keys.blank?
            end

            private
            # :description TODO
            # :return [Array]
            def get_key_identifiers
                file = File.read(File.expand_path('../ship_key_identifiers.json', __FILE__))
                JSON.parse(file)
            end
        end
    end
end
