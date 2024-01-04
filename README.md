# setwgroute
A helper container to set a route in another one, e.g. to setup routes through wireguard tunnels.


Usage:

```
services:
  main:
    ...
  setwgroute:
    image: numo68/setwgroute:latest
    depends_on:
      main:
        condition: service_started
        restart: true
    cap_add:
      - NET_ADMIN
    environment:
      - WGNET=192.168.10.0/24
      - WGGATEWAY=192.168.10.2/24
      - WGPEERNET=192.168.11.0/24
      - CHECK_INTERVAL=30
    restart: unless-stopped
``````

`WGNET` is the local network both the wireguard container and the main service's one is attached to.

`WGNETGATEWAY` is the address of the wireguard container.

`WGPEERNET` is the network at the other end of the tunnel we want to reach.

`CHECK_INTERVAL` is the time the container checks whether the routing is still present.

The container waits until there is a device where `WGNET` is routed, then sets up a route to `WGPEERNET` via `WGGATEWAY` through this device.

The success is reported in the log:
```
main-setwgroute-1  | Setting route to 192.168.11.0/24 via 192.168.10.2 on eth1
```