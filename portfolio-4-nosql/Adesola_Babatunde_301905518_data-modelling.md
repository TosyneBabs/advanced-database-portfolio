# NoSQL modelling decision

## Chosen model: document database (MongoDB)
The property catalogue contains attributes that vary by accommodation type. A hotel, serviced apartment and short-let property may expose different amenities, policies, tags and room-type metadata. A MongoDB document can group catalogue fields and nested room-type descriptions for read-oriented property pages.

## Why not move all data to MongoDB?
Reservations, room allocation and payment records require strong relational constraints and carefully controlled transactions. The portfolio therefore keeps MySQL as the transactional system of record. MongoDB is a complementary catalogue model, not a second authoritative booking ledger.

## Other NoSQL models (conceptual examples)
- Key-value: Redis could cache frequently requested property search results or short-lived sessions. Cache entries must have expiry and must not be treated as authoritative booking availability.
- Column-family: Cassandra could store high-volume append-oriented search impressions or property-view events where wide-column distribution and write throughput are important.
- Graph: Neo4j could represent relationships among guests, hosts, properties and recommendations (for example, guests who favour similar property attributes).

These are suitability examples only; the practical implementation in this portfolio is MongoDB.
