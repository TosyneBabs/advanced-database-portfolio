USE meronic_hotel;
DELIMITER $$

DROP PROCEDURE IF EXISTS create_room_reservation$$
CREATE PROCEDURE create_room_reservation(
    IN p_reservation_id CHAR(36),
    IN p_confirmation_code VARCHAR(24),
    IN p_guest_id CHAR(36),
    IN p_room_id CHAR(36),
    IN p_check_in DATE,
    IN p_check_out DATE,
    IN p_guest_count SMALLINT UNSIGNED,
    IN p_nightly_rate DECIMAL(12,2),
    IN p_currency CHAR(3)
)
BEGIN
    DECLARE v_room_status VARCHAR(30);
    DECLARE v_max_occupancy TINYINT UNSIGNED;
    DECLARE v_conflicts INT DEFAULT 0;
    DECLARE v_total DECIMAL(12,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_check_out <= p_check_in THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Check-out must be after check-in';
    END IF;

    IF p_guest_count < 1 OR p_nightly_rate < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid guest count or nightly rate';
    END IF;

    START TRANSACTION;

    SELECT rm.room_status, rt.max_occupancy
      INTO v_room_status, v_max_occupancy
    FROM rooms rm
    JOIN room_types rt ON rt.room_type_id=rm.room_type_id
    WHERE rm.room_id=p_room_id
    FOR UPDATE;

    IF v_room_status <> 'available' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Room is not in an available operational state';
    END IF;

    IF p_guest_count > v_max_occupancy THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Guest count exceeds room capacity';
    END IF;

    SELECT COUNT(*) INTO v_conflicts
    FROM reservation_rooms rr
    JOIN reservations r ON r.reservation_id=rr.reservation_id
    WHERE rr.room_id=p_room_id
      AND r.reservation_status IN ('pending','confirmed','checked_in')
      AND r.check_in_date < p_check_out
      AND r.check_out_date > p_check_in;

    IF v_conflicts > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Room is already reserved for part of this stay';
    END IF;

    SET v_total = DATEDIFF(p_check_out,p_check_in) * p_nightly_rate;

    INSERT INTO reservations
      (reservation_id,confirmation_code,guest_id,check_in_date,check_out_date,
       guest_count,reservation_status,total_amount,currency_code)
    VALUES
      (p_reservation_id,p_confirmation_code,p_guest_id,p_check_in,p_check_out,
       p_guest_count,'confirmed',v_total,p_currency);

    INSERT INTO reservation_rooms(reservation_id,room_id,nightly_rate)
    VALUES(p_reservation_id,p_room_id,p_nightly_rate);

    COMMIT;
END$$
DELIMITER ;

-- Example invocation (use a unique confirmation code each time):
-- CALL create_room_reservation(
--   UUID(),'MRN-PROC-001','44444444-4444-4444-8444-444444444444',
--   '10000003-0000-4000-8000-000000000003','2026-12-20','2026-12-22',2,165000.00,'NGN'
-- );
