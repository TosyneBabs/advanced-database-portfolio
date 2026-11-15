USE meronic_hotel;

CREATE TABLE IF NOT EXISTS users (
    user_id CHAR(36) PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(254) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(30) NULL,
    user_role ENUM('guest','owner','staff','admin') NOT NULL DEFAULT 'guest',
    account_status ENUM('active','suspended','closed') NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_users_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS properties (
    property_id CHAR(36) PRIMARY KEY,
    owner_id CHAR(36) NOT NULL,
    property_name VARCHAR(160) NOT NULL,
    property_type ENUM('hotel','serviced_apartment','short_let') NOT NULL,
    description TEXT NULL,
    address_line VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state_region VARCHAR(100) NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NULL,
    currency_code CHAR(3) NOT NULL DEFAULT 'NGN',
    timezone_name VARCHAR(64) NOT NULL DEFAULT 'Africa/Lagos',
    property_status ENUM('draft','active','inactive','suspended') NOT NULL DEFAULT 'draft',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_properties_owner FOREIGN KEY (owner_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_property_currency CHECK (currency_code REGEXP '^[A-Z]{3}$')
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS room_types (
    room_type_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    type_name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    max_occupancy TINYINT UNSIGNED NOT NULL,
    base_rate DECIMAL(12,2) NOT NULL,
    rate_period ENUM('night','day') NOT NULL DEFAULT 'night',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_room_types_property FOREIGN KEY (property_id) REFERENCES properties(property_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_room_type_name_per_property UNIQUE (property_id, type_name),
    CONSTRAINT chk_room_type_occupancy CHECK (max_occupancy > 0),
    CONSTRAINT chk_room_type_rate CHECK (base_rate >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS rooms (
    room_id CHAR(36) PRIMARY KEY,
    room_type_id CHAR(36) NOT NULL,
    room_number VARCHAR(30) NOT NULL,
    floor_number SMALLINT NULL,
    room_status ENUM('available','maintenance','out_of_service') NOT NULL DEFAULT 'available',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rooms_room_type FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_room_number_per_type UNIQUE (room_type_id, room_number)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS amenities (
    amenity_id CHAR(36) PRIMARY KEY,
    amenity_name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_amenity_name UNIQUE (amenity_name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS property_amenities (
    property_id CHAR(36) NOT NULL,
    amenity_id CHAR(36) NOT NULL,
    PRIMARY KEY (property_id, amenity_id),
    CONSTRAINT fk_property_amenities_property FOREIGN KEY (property_id) REFERENCES properties(property_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_property_amenities_amenity FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS room_type_amenities (
    room_type_id CHAR(36) NOT NULL,
    amenity_id CHAR(36) NOT NULL,
    PRIMARY KEY (room_type_id, amenity_id),
    CONSTRAINT fk_room_type_amenities_type FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_room_type_amenities_amenity FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reservations (
    reservation_id CHAR(36) PRIMARY KEY,
    confirmation_code VARCHAR(24) NOT NULL,
    guest_id CHAR(36) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    guest_count SMALLINT UNSIGNED NOT NULL,
    reservation_status ENUM('pending','confirmed','checked_in','completed','cancelled','no_show','expired')
        NOT NULL DEFAULT 'pending',
    total_amount DECIMAL(12,2) NOT NULL,
    currency_code CHAR(3) NOT NULL,
    special_requests TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_reservation_confirmation UNIQUE (confirmation_code),
    CONSTRAINT fk_reservations_guest FOREIGN KEY (guest_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_reservation_dates CHECK (check_out_date > check_in_date),
    CONSTRAINT chk_reservation_guests CHECK (guest_count > 0),
    CONSTRAINT chk_reservation_amount CHECK (total_amount >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reservation_rooms (
    reservation_id CHAR(36) NOT NULL,
    room_id CHAR(36) NOT NULL,
    nightly_rate DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (reservation_id, room_id),
    CONSTRAINT fk_reservation_rooms_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_reservation_rooms_room FOREIGN KEY (room_id) REFERENCES rooms(room_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_reservation_room_rate CHECK (nightly_rate >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payments (
    payment_id CHAR(36) PRIMARY KEY,
    reservation_id CHAR(36) NOT NULL,
    payment_reference VARCHAR(100) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    currency_code CHAR(3) NOT NULL,
    payment_method ENUM('card','bank_transfer','cash','wallet','other') NOT NULL,
    payment_status ENUM('initiated','successful','failed','reversed','refunded') NOT NULL DEFAULT 'initiated',
    paid_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_payment_reference UNIQUE (payment_reference),
    CONSTRAINT fk_payments_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_payment_amount CHECK (amount > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS refunds (
    refund_id CHAR(36) PRIMARY KEY,
    payment_id CHAR(36) NOT NULL,
    refund_reference VARCHAR(100) NOT NULL,
    refund_amount DECIMAL(12,2) NOT NULL,
    refund_status ENUM('requested','processed','rejected','failed') NOT NULL DEFAULT 'requested',
    processed_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_refund_reference UNIQUE (refund_reference),
    CONSTRAINT fk_refunds_payment FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_refund_amount CHECK (refund_amount > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS check_in_records (
    checkin_id CHAR(36) PRIMARY KEY,
    reservation_id CHAR(36) NOT NULL,
    actual_checkin DATETIME NULL,
    actual_checkout DATETIME NULL,
    checked_in_by CHAR(36) NULL,
    notes TEXT NULL,
    CONSTRAINT uq_checkin_reservation UNIQUE (reservation_id),
    CONSTRAINT fk_checkin_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_checkin_staff FOREIGN KEY (checked_in_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_checkin_order CHECK (
        actual_checkout IS NULL OR actual_checkin IS NULL OR actual_checkout >= actual_checkin
    )
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS reviews (
    review_id CHAR(36) PRIMARY KEY,
    reservation_id CHAR(36) NOT NULL,
    guest_id CHAR(36) NOT NULL,
    rating TINYINT UNSIGNED NOT NULL,
    review_comment TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_review_per_reservation UNIQUE (reservation_id),
    CONSTRAINT fk_reviews_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_reviews_guest FOREIGN KEY (guest_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS staff (
    staff_id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    property_id CHAR(36) NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    employment_status ENUM('active','inactive','terminated') NOT NULL DEFAULT 'active',
    hired_at DATE NULL,
    CONSTRAINT uq_staff_user_property UNIQUE (user_id, property_id),
    CONSTRAINT fk_staff_user FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_staff_property FOREIGN KEY (property_id) REFERENCES properties(property_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS guest_messages (
    message_id CHAR(36) PRIMARY KEY,
    reservation_id CHAR(36) NOT NULL,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_messages_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_messages_sender FOREIGN KEY (sender_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_messages_recipient FOREIGN KEY (recipient_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
