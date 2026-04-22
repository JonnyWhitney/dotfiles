#!/bin/bash
ws="$1"
forced="1 2 3 4 5 6 7 8 9 10"
if echo "$forced" | grep -qw "$ws"; then
    aerospace move-node-to-workspace "$ws"
    aerospace workspace "$ws"
    sleep 0.01
    aerospace move-mouse window-force-center
elif aerospace list-workspaces --monitor all --visible | grep -qx "$ws"; then
    aerospace move-node-to-workspace "$ws"
    aerospace workspace "$ws"
    sleep 0.01
    aerospace move-mouse window-force-center
else
    aerospace move-node-to-workspace "$ws"
    aerospace summon-workspace "$ws"
    sleep 0.01
    aerospace move-mouse window-force-center
fi
