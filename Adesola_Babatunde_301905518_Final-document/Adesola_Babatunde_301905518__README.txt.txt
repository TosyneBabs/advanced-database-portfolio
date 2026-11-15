MIT 8103 – ADVANCED DATABASE SYSTEMS

Individual Practical Database Portfolio Summary
Case Study: Meronic Hotel Management and Reservation System
GitHub Repository: https://github.com/TosyneBabs/advanced-database-portfolio
  

1. Case Study and Objectives
Meronic is a proposed multi-property accommodation management platform supporting hotels, serviced apartments and short-let properties. It provides a shared database for guests, property owners and managers, operational staff and administrators.
The system manages property registration, room inventory, date-based availability, reservations, payments, refunds, check-in/check-out records, guest reviews and management reporting. A property represents an accommodation facility or listing, room types define the categories available, and rooms represent individual bookable units. This structure supports both multi-room hotels and single-unit short-let properties.
The project applies relational database design, query optimisation, transaction management, NoSQL modelling and distributed database concepts to the same business scenario.
2. Portfolio 1 – Database Design and Modelling
The relational database is designed using MySQL 8 and InnoDB. Its 15 core entities include Users, Properties, Room_Types, Rooms, Amenities, Property_Amenities, Room_Type_Amenities, Reservations, Reservation_Rooms, Payments, Refunds, Check_In_Records, Reviews, Staff and Guest_Messages.
Primary keys and foreign keys establish entity relationships, while unique constraints protect important values such as email addresses, reservation confirmation codes and payment references. Check constraints support validation of date ranges, occupancy, monetary values and review ratings.
The schema separates reusable property, room, guest, amenity and financial information to reduce duplication and update anomalies. Junction tables represent many-to-many relationships, while the design follows the principles of Third Normal Form (3NF). Reservation totals are retained as booking-time financial snapshots so that subsequent rate changes do not alter historical booking values.
Evidence: The repository contains the database creation scripts, table definitions, constraints, indexes, seed data and ER diagram.

  
Fig 1:

  
Fig 2:


  
Fig 3: 
  
Fig 

3. Portfolio 2 – Query Processing and Optimisation
The SQL query portfolio addresses practical reporting and retrieval requirements, including guest reservation counts, property booking rankings, revenue by property, upcoming reservations, average property ratings, room inventory, outstanding payments, location-based property searches and monthly payment totals.
Indexes are designed around frequently used search and join conditions, including property location and status, reservation dates and status, room type and status, and payment reservation references. Query execution plans using EXPLAIN and, where supported, EXPLAIN ANALYZE are used to examine access paths and assess the effect of indexing.
Performance conclusions should be based on the actual execution plans and test results saved in the repository rather than assumed improvements.
Evidence: SQL query scripts, query outputs, execution plans and before-and-after index comparison results.
  
Fig 4
  Fig 5:


  

Fig 6
  Fig 7


  

Fig 8
  Fig 9
  
Fig 10


4. Portfolio 3 – Transactions and Concurrency
Reservation creation is treated as a critical transaction because concurrent requests must not allocate the same room for overlapping dates. The transaction design uses InnoDB, row-level locking through SELECT ... FOR UPDATE, and an overlap check before inserting a reservation and its room allocation.
The booking interval follows the convention [check-in, check-out), meaning the check-in date is included and the checkout date is excluded. An existing booking conflicts when:
existing_check_in < requested_check_out AND existing_check_out > requested_check_in
The practical work demonstrates transaction boundaries through COMMIT and ROLLBACK, and considers isolation levels, lock waiting and deadlocks. For multi-room reservations, locking room identifiers in a consistent order helps reduce deadlock risk.
Evidence: Transaction scripts and the saved outputs or screenshots from commit, rollback and concurrency tests.
  

Fig 11

  
Fig 12




5. Portfolio 4 – NoSQL and Advanced Data Models
MongoDB complements the MySQL database by storing flexible property catalogue information. Property documents contain fields such as location, property type, amenities, policies, tags and nested room-type descriptions. This document structure accommodates differences between hotels, serviced apartments and short-let properties.
The MongoDB work covers sample documents, CRUD and search operations, aggregation by city and property type, and indexes for relevant catalogue fields. MySQL remains the authoritative system for reservations, room allocations, payments and refunds. MongoDB catalogue data is not used to make final live room-availability decisions.
Other models are evaluated for their suitability: Redis for caching and session data, Cassandra for high-volume activity events, and Neo4j for relationship-based analysis and recommendations. These are conceptual evaluations, not claimed deployments.
Evidence: MongoDB sample documents, implementation scripts, queries and aggregation outputs.
  
Fig 13


  
Fig 14
6. Portfolio 5 – Distributed and Cloud Database Exercise
MongoDB complements the MySQL database by storing flexible property catalogue information. Property documents contain fields such as location, property type, amenities, policies, tags and nested room-type descriptions. This document structure accommodates differences between hotels, serviced apartments and short-let properties.
The MongoDB work covers sample documents, CRUD and search operations, aggregation by city and property type, and indexes for relevant catalogue fields. MySQL remains the authoritative system for reservations, room allocations, payments and refunds. MongoDB catalogue data is not used to make final live room-availability decisions.
Other models are evaluated for their suitability: Redis for caching and session data, Cassandra for high-volume activity events, and Neo4j for relationship-based analysis and recommendations. These are conceptual evaluations, not claimed deployments.


Evidence: MongoDB sample documents, implementation scripts, queries and aggregation outputs.
  
Fig 15
  

Fig 16


7. Technical Reflection
The project demonstrates how database design decisions affect the reliability and performance of an accommodation management system. Separating properties, room types and individual rooms provides a flexible structure, while junction tables reduce duplication and support many-to-many relationships.
A key technical consideration is preventing overlapping room reservations during concurrent requests. Transaction boundaries, row-level locking and date-overlap validation are important to maintaining booking consistency. The project also highlights that NoSQL databases and read replicas should complement, rather than replace, the authoritative transactional database for critical reservation decisions.
The main lesson is that database performance, consistency and availability depend not only on the schema, but also on query design, transaction handling, indexing and deployment architecture.
8. References and AI Use Declaration
References: MySQL 8.0 Reference Manual; MongoDB Manual; and the official documentation for any additional database technologies, tools or libraries used. Full source details and relevant implementation references should be maintained in the repository README.