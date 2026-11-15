USE meronic_hotel;

-- Q1: Count reservations made by each guest.
SELECT u.user_id, u.first_name, u.last_name, COUNT(r.reservation_id) AS reservation_count
FROM users AS u
LEFT JOIN reservations AS r ON r.guest_id = u.user_id
WHERE u.user_role = 'guest'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY reservation_count DESC;

-- Q2: Property performance by reservation count.
SELECT p.property_id, p.property_name, COUNT(DISTINCT r.reservation_id) AS reservations
FROM properties AS p
JOIN room_types AS rt ON rt.property_id = p.property_id
JOIN rooms AS rm ON rm.room_type_id = rt.room_type_id
JOIN reservation_rooms AS rr ON rr.room_id = rm.room_id
JOIN reservations AS r ON r.reservation_id = rr.reservation_id
WHERE r.reservation_status IN ('confirmed','checked_in','completed')
GROUP BY p.property_id, p.property_name
ORDER BY reservations DESC;

-- Q3: Revenue by property from successful payments.
SELECT p.property_name, p.currency_code, SUM(pay.amount) AS gross_collected
FROM properties AS p
JOIN room_types AS rt ON rt.property_id = p.property_id
JOIN rooms AS rm ON rm.room_type_id = rt.room_type_id
JOIN reservation_rooms AS rr ON rr.room_id = rm.room_id
JOIN reservations AS r ON r.reservation_id = rr.reservation_id
JOIN payments AS pay ON pay.reservation_id = r.reservation_id
WHERE pay.payment_status = 'successful'
GROUP BY p.property_id, p.property_name, p.currency_code
ORDER BY gross_collected DESC;

-- Q4: Upcoming confirmed reservations.
SELECT r.confirmation_code, u.first_name, u.last_name, r.check_in_date, r.check_out_date,
       p.property_name, rm.room_number
FROM reservations AS r
JOIN users AS u ON u.user_id = r.guest_id
JOIN reservation_rooms AS rr ON rr.reservation_id = r.reservation_id
JOIN rooms AS rm ON rm.room_id = rr.room_id
JOIN room_types AS rt ON rt.room_type_id = rm.room_type_id
JOIN properties AS p ON p.property_id = rt.property_id
WHERE r.reservation_status = 'confirmed'
  AND r.check_in_date >= CURRENT_DATE
ORDER BY r.check_in_date;

-- Q5: Average guest rating per property.
SELECT p.property_name, ROUND(AVG(rv.rating),2) AS average_rating, COUNT(*) AS review_count
FROM properties AS p
JOIN room_types AS rt ON rt.property_id = p.property_id
JOIN rooms AS rm ON rm.room_type_id = rt.room_type_id
JOIN reservation_rooms AS rr ON rr.room_id = rm.room_id
JOIN reviews AS rv ON rv.reservation_id = rr.reservation_id
GROUP BY p.property_id, p.property_name
ORDER BY average_rating DESC;

-- Q6: Rank properties by number of reservations (MySQL 8 window functions).
WITH property_counts AS (
  SELECT p.property_id, p.property_name, COUNT(DISTINCT r.reservation_id) AS booking_count
  FROM properties p
  LEFT JOIN room_types rt ON rt.property_id = p.property_id
  LEFT JOIN rooms rm ON rm.room_type_id = rt.room_type_id
  LEFT JOIN reservation_rooms rr ON rr.room_id = rm.room_id
  LEFT JOIN reservations r ON r.reservation_id = rr.reservation_id
  GROUP BY p.property_id, p.property_name
)
SELECT property_id, property_name, booking_count,
       RANK() OVER (ORDER BY booking_count DESC) AS booking_rank,
       ROW_NUMBER() OVER (ORDER BY booking_count DESC, property_id) AS row_num
FROM property_counts;

-- Q7: Room inventory by property and room status.
SELECT p.property_name, rm.room_status, COUNT(*) AS room_count
FROM properties p
JOIN room_types rt ON rt.property_id = p.property_id
JOIN rooms rm ON rm.room_type_id = rt.room_type_id
GROUP BY p.property_id, p.property_name, rm.room_status
ORDER BY p.property_name, rm.room_status;

-- Q8: Reservations with outstanding or unsuccessful payment status.
SELECT r.confirmation_code, r.total_amount, r.currency_code,
       COALESCE(SUM(CASE WHEN pay.payment_status='successful' THEN pay.amount ELSE 0 END),0) AS paid_amount
FROM reservations r
LEFT JOIN payments pay ON pay.reservation_id = r.reservation_id
GROUP BY r.reservation_id, r.confirmation_code, r.total_amount, r.currency_code
HAVING paid_amount < r.total_amount;

-- Q9: Search active properties in a city and property type.
SELECT p.property_name, p.city, p.property_type, rt.type_name, rt.base_rate, p.currency_code
FROM properties p
JOIN room_types rt ON rt.property_id = p.property_id
WHERE p.city = 'Lagos'
  AND p.property_type IN ('hotel','serviced_apartment')
  AND p.property_status = 'active'
  AND rt.is_active = TRUE
ORDER BY rt.base_rate;

-- Q10: Monthly successful payment totals.
SELECT DATE_FORMAT(paid_at,'%Y-%m') AS payment_month, currency_code, SUM(amount) AS monthly_total
FROM payments
WHERE payment_status = 'successful' AND paid_at IS NOT NULL
GROUP BY DATE_FORMAT(paid_at,'%Y-%m'), currency_code
ORDER BY payment_month;
