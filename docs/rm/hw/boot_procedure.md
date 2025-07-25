# Boot procedure

When the Snitch cluster comes out of reset, the Snitch cores start fetching instructions from a hardwired boot address (`BootAddr` parameter), defined at design time.

This parameter can be set at the cluster interface to point to an external bootrom. Alternatively, if the `IntBootromEnable` parameter is asserted, an internal bootrom is instantiated within the cluster itself, and the `BootAddr` of the cores will be overriden to point to the internal bootrom.

The internal bootrom is enabled in the default cluster configuration and its contents are compiled from [bootrom.S](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/test/bootrom.S).
Please refer to the comments in this file for more information on the boot procedure defined by the internal bootrom.
