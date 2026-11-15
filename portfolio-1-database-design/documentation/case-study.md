# Case Study: Meronic Hotel Management and Reservation System

## 1. Organisation and system
Meronic is a proposed multi-property accommodation management platform supporting hotels, serviced apartments and short-let properties. It provides a common reservation and operational database for property owners, hotel staff, guests and platform administrators.

## 2. Users
- Guest: searches accommodation, creates reservations, pays and submits reviews.
- Property owner/manager: manages properties, room types, rooms, rates and operational information.
- Staff: performs property-level operations such as check-in and check-out.
- Administrator: manages platform-level access and oversight.

## 3. Main data
The database stores user profiles, properties, room types, physical rooms, amenities, reservations, allocated rooms, payments, refunds, check-in/out records, reviews and staff assignments.

## 4. Core operations
1. Register guests, owners, staff and administrators.
2. Register a property and define its room types and rooms.
3. Search accommodation by location, property type, dates, capacity and price.
4. Create a reservation and allocate one or more rooms.
5. Record payment attempts and refunds.
6. Record check-in and check-out.
7. Collect reviews for completed stays.
8. Produce occupancy, booking and revenue reports.

## 5. Scope and assumptions
This is an academic prototype, not a production payment or hotel platform. The sample schema models a property owner as a user and supports multiple room types per property. An entire short-let unit can be represented as a property with one room/unit. Reservations use a check-in date inclusive and check-out date exclusive. A room is unavailable when another pending/confirmed reservation overlaps the requested stay. Pending holds require expiry handling in a production application.

## 6. Design rationale
The relational database is the system of record for reservations, room allocation and financial records because these require referential integrity and transactional consistency. MongoDB is used separately for flexible property catalogue content. The NoSQL portfolio does not replace the relational reservation ledger.
