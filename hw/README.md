# Snitch Hardware

The `hw` directory contains various HW IPs which are instantiated in the Snitch Cluster design e.g., they are not stand-alone.
Some of the IPs have stand-alone test benches. The top level structure of the `hw` folder is as follows:

- `<snitch_ip>`: IP components for the snitch cluster
- `chisel`: SNAX Framework componets written in the Chisel HDL.
- `<snax_ip>`: SNAX Accelerators 
- `templates`: Template files which are used to generate the snax wrappers and Chisel parameters based on the supplied config files.

All IPs inside the `hw` directory are structured as follows:

- `<ip_name>`: each directory contains one IP that is instantiated in the cluster design
  - `doc`: documentation if existing
  - `src`: RTL sources
  - `test`: Standalone testbenches if existing
  - `util`: Helper scripts to run standalone test benches if existing

The exact structure for `chisel` differs from this, but is very similar:

- `chisel`
  - `doc`: documentation 
  - `src/main/scala/snax/<component>`: RTL sources
  - `src/test/scala/snax/<component>`: Standalone testbenches
