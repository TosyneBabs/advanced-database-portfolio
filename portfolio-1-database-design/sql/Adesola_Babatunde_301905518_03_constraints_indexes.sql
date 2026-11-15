USE meronic_hotel;

CREATE INDEX idx_properties_location_type_status
    ON properties (country, city, property_type, property_status);

CREATE INDEX idx_room_types_property_active
    ON room_types (property_id, is_active);

CREATE INDEX idx_rooms_type_status
    ON rooms (room_type_id, room_status);

CREATE INDEX idx_reservations_guest_created
    ON reservations (guest_id, created_at);

CREATE INDEX idx_reservations_dates_status
    ON reservations (check_in_date, check_out_date, reservation_status);

CREATE INDEX idx_reservation_rooms_room
    ON reservation_rooms (room_id, reservation_id);

CREATE INDEX idx_payments_reservation_status
    ON payments (reservation_id, payment_status);

CREATE INDEX idx_reviews_guest_created
    ON reviews (guest_id, created_at);

CREATE INDEX idx_staff_property_status
    ON staff (property_id, employment_status);
