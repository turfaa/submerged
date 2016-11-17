# Submerged: Story

You wake up alone in a rapidly sinking submarine, abandoned by the rest of the crew. There is no power, you are almost out of breathable air and enemy subs patrol the area. Can you escape to the surface before time runs out?

## Objectives

- Primary objective: escape to the surface

    1. Torpedo room: remove barrels blocking the hatch, go to sonar room
    2. Sonar room: see exit hatch jammed, go to control room
    3. Control room: can't use control panel, must turn on power first, crew's quarters locked. Go to engine room
    4. Engine room: see fuse box, turn on backup power, go back to control room
    5. Control room: unlock crew's quarters, go to sonar room
    6. Sonar room: go down to crew's quarters
    7. Crew's quarters: go to storage room
    8. Storage room: equip diving equipment, equip oxygen canister, equip crowbar, goto crew's quarters
    9. Crew's quarters: go to sonar room
    10. Sonar room: go to control room
    11. Control room: unlock reactor hatch, sub flooded (power out), go to engine room
    12. Engine room: go to reactor room
    13. Reactor room: see hole, use crowbar to widen hole, exit through hole to surface
    14. Surface: game ends.

- Secondary objective: (revealed through the radio) destroy the sub to prevent it falling to enemy hands

    - In step 5, use radio, secondary objective revealed.
    - In step 7, first go to wardroom, then see explosives arming code in intelligence documents, then go back to crew's quarters, go to sonar room, go to torpedo room, then set timer on explosives, then go to sonar room, go to crew's quarters, then go to storage room. Continue with step 8 (extra 6 steps)

## Map

```
                 Airlock                                 Surface
                    |                                       |
                    |                                       |
Torpedo room - Sonar room - Control room - Engine room - Reactor
                    |
                    |
Wardroom - Crew's quarters - Storage room

<< Forward  Backward >>

```

## Objects

### Torpedo room

- Barrels: initially blocking the hatch, can be moved.
- Explosives: used to self-destruct the sub (secondary objective), requires explosives arming code
- Torpedo: -

### Sonar room

- Sonar display: shows distance to enemy ship (if enemy is too close, it will fire and kill the player). Requires power to function.
- Airlock inner hatch: initially locked.
- Headphones: -

### Airlock

- Airlock outer hatch: permanently jammed.

### Crew quarters

- Book: -
- Canned food: -
- Bucket: -
- Knife: -

### Wardroom

- Intelligence documents: contains explosives arming code
- Ship's log: story

### Storage room

- Diving equipment: required to survive flooding.
- Oxygen canisters: replenish oxygen level (if oxygen level too low, the player will die).
- Crowbar: used to break hole in the reactor.

### Control room

- Control panel: lock/unlock all hatches (except jammed ones). Requires power to function.
- Map: story
- Radio: reveals secondary objective. Requires power to function.
- Periscope: -

### Engine room

- Fuse box: turn on backup power
- Reactor status display: shows that the reactor room is flooded (can exit through hole).
- Engine spare parts: -
- Fire extinguisher: will reduce oxygen level if used.
- Oxygen canister: replenish oxygen level

### Reactor

- Hole: initially too small to pass through, must equip crowbar to break through.
- Engine: -
- Dead engineer: -