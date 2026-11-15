# Core data dictionary

| Entity | Purpose | Key relationships |
|---|---|---|
| users | Login/profile and platform role | Owns properties; makes reservations; writes reviews |
| properties | Hotel, apartment building or short-let property | Has room types, staff and amenities |
| room_types | Sellable category such as Standard or Suite | Belongs to property; contains rooms |
| rooms | Physical or independently bookable unit | Belongs to room type |
| amenities | Reusable facility catalogue | Linked to properties and room types |
| reservations | Guest booking header and lifecycle | Belongs to guest; contains room allocations |
| reservation_rooms | Rooms allocated to a reservation | Links reservation and room; stores booked rate |
| payments | Payment attempts/receipts | Belongs to reservation |
| refunds | Refund transactions | References original payment |
| check_in_records | Actual arrival/departure events | One record per reservation in this simplified model |
| reviews | Guest feedback for a stay | References reservation and guest |
| staff | Staff-to-property assignment | References user and property |

All monetary values are `DECIMAL(12,2)`. Each property stores an ISO 4217 currency code. The prototype does not perform foreign-exchange conversion.
