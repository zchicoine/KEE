# email categories {:unknown,:ship_position, :not_ship_position, :personal}
module Kee
    module CategorizeEmails
        module Constants
            UNKNOWN_EMAIL = :unknown # First time emails are received are categorize to unknown
            SHIP_POSITION_EMAIL = :ship_position
            NOT_SHIP_POSITION_EMAIL = :not_ship_position
            PERSONAL_EMAIL = :personal
            ORDERS_EMAIL = :order # cargo email
        end
    end
end