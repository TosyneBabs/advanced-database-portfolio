USE meronic_hotel;

-- Demonstration transaction: create a reservation and allocate one room.
-- Run in a disposable test database. Replace IDs/dates for repeat testing.
START TRANSACTION;

-- Lock the room row. Competing transactions for this room must wait.
SELECT room_id, room_status
FROM rooms
WHERE room_id = '10000002-0000-4000-8000-000000000002'
FOR UPDATE;

-- Verify no active reservation overlaps [2026-12-10, 2026-12-13).
SELECT COUNT(*) AS conflicting_reservations
FROM reservation_rooms rr
JOIN reservations r ON r.reservation_id = rr.reservation_id
WHERE rr.room_id = '10000002-0000-4000-8000-000000000002'
  AND r.reservation_status IN ('pending','confirmed','checked_in')
  AND r.check_in_date < '2026-12-13'
  AND r.check_out_date > '2026-12-10';

-- Only proceed when conflicting_reservations = 0.
INSERT INTO reservations
(reservation_id, confirmation_code, guest_id, check_in_date, check_out_date,
 guest_count, reservation_status, total_amount, currency_code)
VALUES
(UUID(),'MRN-TEST-20261210-01','44444444-4444-4444-8444-444444444444',
 '2026-12-10','2026-12-13',2,'confirmed',255000.00,'NGN');

SET @new_reservation_id = (SELECT reservation_id FROM reservations
                           WHERE confirmation_code='MRN-TEST-20261210-01');

INSERT INTO reservation_rooms (reservation_id, room_id, nightly_rate)
VALUES (@new_reservation_id,'10000002-0000-4000-8000-000000000002',85000.00);

COMMIT;

-- To demonstrate rollback instead, start a new transaction, insert a test record,
-- then execute ROLLBACK and verify that the record is absent.
