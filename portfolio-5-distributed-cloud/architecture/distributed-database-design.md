# Portfolio 5 – Distributed and Cloud Database Exercise

## Proposed deployment
A single writable MySQL primary handles transactional writes for reservations, room allocation, payments and refunds. One or more read replicas serve suitable read-only workloads such as property reports and historical dashboards. Replication is asynchronous by default in common MySQL configurations; therefore replica lag and stale reads must be considered.

## Replication
- Primary: accepts application writes.
- Replica: receives binary log events and applies them.
- Monitoring: monitor replica IO/SQL threads, replication delay, disk, CPU and connection saturation.
- Failover: a controlled process promotes a healthy replica only after assessing data freshness and fencing the old primary to avoid split-brain.
- Recovery: rebuild or re-seed the failed replica from a consistent backup/snapshot and resume replication.

Replication improves read scalability and can support recovery, but it is not a backup and does not automatically guarantee zero data loss or automatic high availability.

## Consistency and availability
Reservation creation must be directed to the primary. Do not use a potentially lagging replica to decide whether a room is available. A stale replica could report a room as free after another guest has booked it. Use primary reads/transactional locking for the booking decision. Read replicas are suitable for reports where a small delay is acceptable.

## Sharding
If the platform grows substantially, data could be partitioned by a stable tenant/property-region key. A possible shard key is `property_region_id` or a carefully selected property identifier. The shard key must support the dominant access patterns and avoid hot shards. Cross-region reservations, global guest history, reporting and migrations become more complex. Sharding is a scale-out design option, not required for the small academic implementation.

## Cloud deployment
A managed MySQL service (for example, a managed MySQL offering from a cloud provider) can provide managed backups, patching, monitoring and replicas. Configure private networking, TLS, least-privilege database accounts, encrypted backups, retention, firewall allow-lists and secrets management. Do not expose the database port publicly. The academic report must distinguish a proposed cloud architecture from a deployment that was actually performed.

## Suggested evidence
1. Architecture diagram showing application, primary and replica.
2. MySQL `SHOW REPLICA STATUS\\G` output from an implemented lab (command name depends on MySQL version).
3. Replication lag/health evidence.
4. A controlled test showing a write on primary becoming visible on replica.
5. A short discussion of replica lag and failover risk.
6. If no live cloud deployment is performed, label the cloud portion as a design exercise and include configuration/security decisions rather than claiming deployment.
