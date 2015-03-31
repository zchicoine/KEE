require 'singleton'

class ShipKeyIdentifiers
    include Singleton

    FILE_PATH = 'filter_emails/ship_key_identifiers.json'

    # :return [Array]
    def ship_key_identifiers
        keys = get_key_identifiers
        return keys unless keys.blank?

    end

    private
    def get_key_identifiers
        file = File.read(FILE_PATH)
        return JSON.parse(file)
    end
end