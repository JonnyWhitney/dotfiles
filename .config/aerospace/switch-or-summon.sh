#!/bin/bash
ws="$1"
forced="1 2 3 4 5 6 7 8 9 10"
if echo "$forced" | grep -qw "$ws"; then
    aerospace workspace "$ws"
    aerospace move-mouse window-lazy-center
elif aerospace list-workspaces --monitor all --visible | grep -qx "$ws"; then
    aerospace workspace "$ws"
    aerospace move-mouse window-lazy-center
else
    aerospace summon-workspace "$ws"
    aerospace move-mouse window-lazy-center
fi
