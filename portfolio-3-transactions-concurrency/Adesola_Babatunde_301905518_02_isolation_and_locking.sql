-- Inspect and set transaction isolation for the current session.
SELECT @@transaction_isolation;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Session A (run in one MySQL client):
START TRANSACTION;
SELECT room_id FROM rooms
WHERE room_id='10000001-0000-4000-8000-000000000001'
FOR UPDATE;
-- Leave transaction open temporarily.

-- Session B (run in a second MySQL client):
START TRANSACTION;
SELECT room_id FROM rooms
WHERE room_id='10000001-0000-4000-8000-000000000001'
FOR UPDATE;
-- This statement waits while Session A holds the lock.
-- Commit or roll back Session A; then observe Session B continue.
-- Finally run COMMIT or ROLLBACK in Session B.

-- Demonstrate rollback:
START TRANSACTION;
UPDATE rooms SET room_status='maintenance'
WHERE room_id='10000002-0000-4000-8000-000000000002';
ROLLBACK;
SELECT room_id, room_status FROM rooms
WHERE room_id='10000002-0000-4000-8000-000000000002';

-- Deadlock handling: transactions that lock multiple rooms should acquire locks
-- in a consistent sorted room_id order. Applications must catch error 1213
-- and retry the whole transaction safely with a bounded retry policy.
