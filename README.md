# The Last Lantern

A 2D side-scrolling platformer built with **Godot 4.3** (mobile renderer).
Run through a dark abandoned building, collect coins, dodge monsters, and
reach the exit elevator at the end of the level.

## The level

One continuous **10,320 px** scroll, 8 background screens laid left to
right:

apartment (start) → hallway → hallway → hallway → boiler room →
broken wall → hallway → **exit + elevator (goal)**

23 platforms, 26 coins, 5 patrolling monsters. The camera scrolls with
the player from left to right.

## Controls

| Action | Keys |
| --- | --- |
| Move left / right | A / D or arrow keys |
| Jump | Space (coyote time + jump buffer) |
| Crouch | S or Down (slower, squashed; stands only with headroom) |
| Shoot | X (bullets kill monsters, break on walls/ground) |

## Run it

Open the project in Godot 4.3 and run `scenes/main.tscn`.

- **Web preset** (`Web`) exports an HTML5 build to `Builds/web/`.
  Serve it with `python3 serve_web.py` (adds the COOP/COEP headers the
  threaded web export needs).
- **Android preset** (`Android`, package `com.yasinm.lastlantern`)
  exports to `Builds/LastLantern.apk`.

## Status

In development. The character and monsters are placeholder rectangles —
real sprites drop into the slots documented in
`assets/README_ASSETS.md`.
