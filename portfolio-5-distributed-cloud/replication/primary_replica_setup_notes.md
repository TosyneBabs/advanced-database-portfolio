# MySQL primary/replica lab notes (optional practical exercise)

This is a lab outline, not a turnkey production configuration. Use two isolated MySQL 8 instances/VMs or containers on a private network. Do not expose replication ports to the public internet.

1. Assign stable private addresses and unique `server_id` values.
2. Configure binary logging on the primary (`log_bin`) and a unique server ID.
3. Configure the replica with its own unique server ID and relay log.
4. Create a dedicated replication account restricted to the replica's private address and grant `REPLICATION SLAVE`/appropriate replication privilege for the server version.
5. Take a consistent backup of the primary and restore it to the replica, recording the binary log file and position (or GTID state).
6. Configure the replica source using the matching MySQL version syntax (`CHANGE REPLICATION SOURCE TO ...` in modern MySQL).
7. Start replication and inspect `SHOW REPLICA STATUS\\G`.
8. Insert a test row on primary and verify it appears on replica.
9. Stop the replica SQL thread in a lab, make a primary change, observe lag, then restart and observe catch-up.
10. Document limitations and recovery steps.

Exact commands depend on the selected MySQL version, authentication method, topology and backup method. Record the actual commands and outputs from your own lab.
