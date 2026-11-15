USE meronic_hotel;

-- Record baseline plans before creating any additional indexes.
EXPLAIN
SELECT property_id, property_name
FROM properties
WHERE city='Lagos' AND property_type='hotel' AND property_status='active';

EXPLAIN ANALYZE
SELECT property_id, property_name
FROM properties
WHERE city='Lagos' AND property_type='hotel' AND property_status='active';

-- The following composite index is already created by 03_constraints_indexes.sql.
-- If conducting a controlled before/after experiment, drop it first in a test copy,
-- capture the plan, recreate it, and capture the plan again.
-- DROP INDEX idx_properties_location_type_status ON properties;
-- CREATE INDEX idx_properties_location_type_status
--   ON properties(country, city, property_type, property_status);

-- Inspect index usage and table statistics.
SHOW INDEX FROM properties;
SHOW INDEX FROM reservations;
ANALYZE TABLE properties, reservations, rooms, reservation_rooms, payments;
