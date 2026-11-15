USE meronic_hotel;

INSERT INTO users
(user_id, first_name, last_name, email, password_hash, phone_number, user_role)
VALUES
('11111111-1111-4111-8111-111111111111','Elvis','Ibenacho','elvis.guest@example.test','$2b$12$replace_with_real_hash','08030000001','guest'),
('22222222-2222-4222-8222-222222222222','Ada','Okafor','ada.owner@example.test','$2b$12$replace_with_real_hash','08030000002','owner'),
('33333333-3333-4333-8333-333333333333','Tunde','Balogun','tunde.staff@example.test','$2b$12$replace_with_real_hash','08030000003','staff'),
('44444444-4444-4444-8444-444444444444','Mina','Yusuf','mina.guest@example.test','$2b$12$replace_with_real_hash','08030000004','guest')
ON DUPLICATE KEY UPDATE email=VALUES(email);

INSERT INTO properties
(property_id, owner_id, property_name, property_type, description, address_line, city, state_region, country, currency_code, property_status)
VALUES
('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','22222222-2222-4222-8222-222222222222',
 'Meronic Lagos Waterfront Hotel','hotel','A sample city hotel for the academic database portfolio.',
 '12 Marina Road','Lagos','Lagos','Nigeria','NGN','active'),
('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','22222222-2222-4222-8222-222222222222',
 'Meronic Lekki Serviced Apartments','serviced_apartment','Furnished serviced apartments.',
 '8 Admiralty Way','Lagos','Lagos','Nigeria','NGN','active'),
('cccccccc-cccc-4ccc-8ccc-cccccccccccc','22222222-2222-4222-8222-222222222222',
 'Meronic Abuja Short Lets','short_let','Short-let accommodation in Abuja.',
 '4 Central District','Abuja','FCT','Nigeria','NGN','active')
ON DUPLICATE KEY UPDATE property_name=VALUES(property_name);

INSERT INTO room_types
(room_type_id, property_id, type_name, description, max_occupancy, base_rate, rate_period)
VALUES
('aaaa0001-0000-4000-8000-000000000001','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Standard Queen','Standard room with queen bed.',2,85000.00,'night'),
('aaaa0002-0000-4000-8000-000000000002','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Executive Suite','Larger suite with sitting area.',3,165000.00,'night'),
('bbbb0001-0000-4000-8000-000000000001','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','One Bedroom Apartment','Furnished one-bedroom unit.',2,110000.00,'night'),
('cccc0001-0000-4000-8000-000000000001','cccccccc-cccc-4ccc-8ccc-cccccccccccc','Entire Apartment','Entire short-let apartment.',4,95000.00,'night')
ON DUPLICATE KEY UPDATE base_rate=VALUES(base_rate);

INSERT INTO rooms (room_id, room_type_id, room_number, floor_number, room_status)
VALUES
('10000001-0000-4000-8000-000000000001','aaaa0001-0000-4000-8000-000000000001','101',1,'available'),
('10000002-0000-4000-8000-000000000002','aaaa0001-0000-4000-8000-000000000001','102',1,'available'),
('10000003-0000-4000-8000-000000000003','aaaa0002-0000-4000-8000-000000000002','201',2,'available'),
('20000001-0000-4000-8000-000000000001','bbbb0001-0000-4000-8000-000000000001','A01',1,'available'),
('30000001-0000-4000-8000-000000000001','cccc0001-0000-4000-8000-000000000001','C01',1,'available')
ON DUPLICATE KEY UPDATE room_number=VALUES(room_number);

INSERT INTO amenities (amenity_id, amenity_name)
VALUES
('dddd0001-0000-4000-8000-000000000001','Wi-Fi'),
('dddd0002-0000-4000-8000-000000000002','Swimming pool'),
('dddd0003-0000-4000-8000-000000000003','Air conditioning'),
('dddd0004-0000-4000-8000-000000000004','Parking'),
('dddd0005-0000-4000-8000-000000000005','Kitchen')
ON DUPLICATE KEY UPDATE amenity_name=VALUES(amenity_name);

INSERT IGNORE INTO property_amenities (property_id, amenity_id) VALUES
('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','dddd0001-0000-4000-8000-000000000001'),
('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','dddd0002-0000-4000-8000-000000000002'),
('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','dddd0001-0000-4000-8000-000000000001'),
('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','dddd0005-0000-4000-8000-000000000005');

INSERT IGNORE INTO room_type_amenities (room_type_id, amenity_id) VALUES
('aaaa0001-0000-4000-8000-000000000001','dddd0001-0000-4000-8000-000000000001'),
('aaaa0001-0000-4000-8000-000000000001','dddd0003-0000-4000-8000-000000000003'),
('aaaa0002-0000-4000-8000-000000000002','dddd0001-0000-4000-8000-000000000001');

INSERT INTO staff (staff_id, user_id, property_id, job_title, employment_status, hired_at)
VALUES
('eeee0001-0000-4000-8000-000000000001','33333333-3333-4333-8333-333333333333',
 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','Front Desk Officer','active','2025-01-15')
ON DUPLICATE KEY UPDATE job_title=VALUES(job_title);

-- Sample completed reservation, room allocation, payment and review.
INSERT INTO reservations
(reservation_id, confirmation_code, guest_id, check_in_date, check_out_date, guest_count, reservation_status, total_amount, currency_code)
VALUES
('50000001-0000-4000-8000-000000000001','MRN-2026-0001','11111111-1111-4111-8111-111111111111',
 '2026-10-01','2026-10-04',2,'completed',255000.00,'NGN')
ON DUPLICATE KEY UPDATE confirmation_code=VALUES(confirmation_code);

INSERT IGNORE INTO reservation_rooms (reservation_id, room_id, nightly_rate)
VALUES ('50000001-0000-4000-8000-000000000001','10000001-0000-4000-8000-000000000001',85000.00);

INSERT INTO payments
(payment_id, reservation_id, payment_reference, amount, currency_code, payment_method, payment_status, paid_at)
VALUES
('60000001-0000-4000-8000-000000000001','50000001-0000-4000-8000-000000000001',
 'PAY-MRN-0001',255000.00,'NGN','bank_transfer','successful','2026-09-25 10:30:00')
ON DUPLICATE KEY UPDATE payment_reference=VALUES(payment_reference);

INSERT INTO check_in_records
(checkin_id, reservation_id, actual_checkin, actual_checkout, checked_in_by, notes)
VALUES
('70000001-0000-4000-8000-000000000001','50000001-0000-4000-8000-000000000001',
 '2026-10-01 14:00:00','2026-10-04 11:00:00','33333333-3333-4333-8333-333333333333',
 'Sample completed stay for demonstration.')
ON DUPLICATE KEY UPDATE actual_checkout=VALUES(actual_checkout);

INSERT INTO reviews (review_id, reservation_id, guest_id, rating, review_comment)
VALUES
('80000001-0000-4000-8000-000000000001','50000001-0000-4000-8000-000000000001',
 '11111111-1111-4111-8111-111111111111',5,'Clean room and helpful staff.')
ON DUPLICATE KEY UPDATE rating=VALUES(rating);
