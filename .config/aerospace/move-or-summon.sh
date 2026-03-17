#!/bin/bash
ws="$1"
forced="1 2 3 4 5 6 7 8 9 10"
if echo "$forced" | grep -qw "$ws"; then
    aerospace move-node-to-workspace "$ws"
    aerospace workspace "$ws"
    aerospace move-mouse window-lazy-center
elif aerospace list-workspaces --monitor all --visible | grep -qx "$ws"; then
    aerospace move-node-to-workspace "$ws"
    aerospace workspace "$ws"
    aerospace move-mouse window-lazy-center
else
    aerospace move-node-to-workspace "$ws"
    aerospace summon-workspace "$ws"
    aerospace move-mouse window-lazy-center
fi
