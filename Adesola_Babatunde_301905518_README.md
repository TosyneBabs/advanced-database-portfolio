# Meronic Hotel Management and Reservation System
## MIT 8103 – Advanced Database Systems | 2026/2027

A practical database portfolio for a multi-property accommodation platform supporting hotels, serviced apartments and short-let units.

## Technology and assumptions
- Relational database: MySQL 8.0.16+ (InnoDB); scripts are intended for MySQL 8.0/8.4.
- NoSQL: MongoDB (mongosh).
- Distributed exercise: MySQL primary/replica replication design and optional lab.
- Identifiers: UUID strings (`CHAR(36)`).
- Currency: ISO 4217 currency code stored with each property/reservation; monetary amounts use `DECIMAL(12,2)`.
- Dates: reservation stay is a half-open interval `[check_in_date, check_out_date)`. A guest checks out on the checkout date; that date is not an occupied night.
- All timestamps are stored in UTC by convention. The application converts local property time zones.

## Run order
1. `portfolio-1-database-design/sql/01_create_database.sql`
2. `portfolio-1-database-design/sql/02_create_tables.sql`
3. `portfolio-1-database-design/sql/03_constraints_indexes.sql`
4. `portfolio-1-database-design/sql/04_seed_data.sql`
5. `portfolio-2-query-optimisation/01_reporting_queries.sql`
6. `portfolio-2-query-optimisation/02_index_experiments.sql`
7. `portfolio-3-transactions-concurrency/01_booking_transaction_example.sql`
8. `portfolio-3-transactions-concurrency/02_isolation_and_locking.sql`
9. MongoDB scripts in `portfolio-4-nosql/mongodb/` using `mongosh`.

Run the scripts in a disposable development database first. Do not run destructive reset scripts against production data.

## Important booking integrity rule
The supplied stored procedure serialises competing booking attempts by locking the selected room row (`SELECT ... FOR UPDATE`) and checking overlapping active reservations before inserting. This is a demonstrative single-primary MySQL pattern. For multi-room reservations, the application/procedure must lock room IDs in a consistent sorted order to reduce deadlocks. Production deployments should also implement idempotency keys, payment-provider reconciliation, expiry of unpaid holds, and operational monitoring.

## Portfolio contents
- Portfolio 1: conceptual/logical/physical design, ERD, schema, constraints, sample data and normalisation.
- Portfolio 2: reporting queries, indexes, execution-plan and performance comparison instructions.
- Portfolio 3: ACID transaction, rollback, locking, isolation and concurrency test instructions.
- Portfolio 4: MongoDB document model, seed data, CRUD, aggregation and indexes.
- Portfolio 5: replication architecture, sharding discussion, cloud deployment and operational checklist.
- `final-documentation/`: 2–3 page LMS summary draft and AI-use declaration template.

## Evidence to capture yourself
Capture screenshots from your own MySQL/MongoDB environment showing successful database creation, tables, sample rows, query results, `EXPLAIN ANALYZE`, transaction outcomes, MongoDB documents/indexes and (if implemented) replication status. Do not present planned architecture as a completed deployment.

## GitHub
Create progressive commits as each portfolio is completed. Keep credentials, `.env` files, production data and payment card data out of the repository. Add an appropriate `.gitignore`.
