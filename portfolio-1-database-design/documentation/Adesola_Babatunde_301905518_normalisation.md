# Normalisation and relational design notes

The design separates users, properties, room types, rooms, reservations, payments, refunds and amenities to reduce update anomalies.

- **1NF:** Attributes contain single values; repeating room and amenity groups are represented by separate rows and junction tables.
- **2NF:** Junction tables use composite primary keys where appropriate; non-key attributes depend on the complete key. Reservation-room-specific nightly rate is stored on the allocation row because it depends on the reservation-room pairing.
- **3NF:** Descriptive property, room-type, user and amenity attributes are held in their own relations rather than repeated in reservation or payment records. Payment details are separated from reservation details; refunds reference payments.

The reservation total is retained as a transaction snapshot because prices and taxes may change after booking. It is not intended to be recalculated from current room rates. Production systems should additionally retain a detailed nightly price/tax breakdown and currency rounding policy.
