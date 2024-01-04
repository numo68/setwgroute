# Wait until there is a device where WGNET is routed, then route
# WGPEERNET via WGGATEWAY on this device
#
# Used to connect two docker networks on different docker hosts
# through a wireguard tunnel

WGNET=${WGNET:-192.168.10.0/24}
WGGATEWAY=${WGGATEWAY:-192.168.10.2}
WGPEERNET=${WGPEERNET:-192.168.11.0/24}

CHECK_INTERVAL=${CHECK_INTERVAL:-30}

getrouteparam()
{
        KW=$1
        shift
        while [ $# != "0" ] ;
        do
                if [ "$1" == "$KW" ] ;
                then
                        shift
                        echo $1
                        break
                fi
                shift
        done
}

while true ;
do
        WGDEV=$(getrouteparam dev $(ip route show to $WGNET))
        PEERVIA=$(getrouteparam via $(ip route show to $WGPEERNET))

        if [ -n "$WGDEV" -a -z "$PEERVIA" ] ;
        then
                echo Setting route to $WGPEERNET via $WGGATEWAY on $WGDEV >&2
                ip route add $WGPEERNET via $WGGATEWAY
        fi
        sleep $CHECK_INTERVAL
done
