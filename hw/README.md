# Snitch Hardware

The `hw` directory contains various HW IPs which are instantiated in the Snitch Cluster design e.g., they are not stand-alone.
Some of the IPs have stand-alone test benches. All IPs inside the `hw` directory are structured as follows:

- `<ip_name>`: each directory contains one IP that is instantiated in the cluster design, e.g., they are not stand-alone.
  - `doc`: documentation if existing
  - `src`: RTL sources
  - `test`: Standalone testbenches if existing
  - `util`: Helper scripts to run standalone test benches if existing
