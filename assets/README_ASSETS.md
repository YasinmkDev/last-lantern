# Asset swap guide — The Last Lantern (2D side-view setup)

Everything in the game right now is a placeholder (coloured rectangles and
drawn circles). When the real assets arrive, drop them in here and swap the
matching placeholder node — no code changes needed for the swap itself.

## Folders (create as needed)

- `assets/characters/` — hero sprites / animations
  - Swap: `scenes/player.tscn` → the `Visual` node (currently a blue
    ColorRect body + white eyes). Replace it with a Sprite2D /
    AnimatedSprite2D. Keep the CollisionShape2D (40x64, origin at feet).
  - Controls already wired: `move_left`, `move_right`, `jump`
    (see `project.godot` input map, `scripts/player.gd`).
- `assets/monsters/` — monster sprites / animations
  - Swap: `scenes/monster.tscn` → the `Visual` node (currently a red
    ColorRect body + eyes). Keep the CollisionShape2D (48x48) and the
    `Hitbox` Area2D. Patrol behaviour lives in `scripts/monster.gd`
    (`patrol_range`, `speed` are exported per instance).
- `assets/backgrounds/` — level backgrounds
  - Swap: `scenes/main.tscn` → `ParallaxBackground` layers:
    `Sky` (static), `FarHills` (0.25x scroll), `NearHills` (0.55x scroll).
    Replace the ColorRect/Polygon2D placeholders with Sprite2D textures.
    Keep the layer motion_scale values or tune them for the new art.
- `assets/items/` — pickups
  - Swap: `scenes/coin.tscn` → replace the drawn circle in
    `scripts/coin.gd` (`_draw`) with a Sprite2D, or keep `_draw` and change
    the colours. Collection logic (signal `collected`, HUD counter) stays.

## Arrived assets

- `assets/backgrounds/level_start_room.png` (1376x768) — dark abandoned
  room, in use as the level-start background: a Sprite2D named `StartRoom`
  in `scenes/main.tscn` covering the first screen (x 0..1280).
- Continuous scroll (from `stitch_2d_side_scroller_visual_design.zip`),
  laid out left to right after the start room, each screen 1290 px wide
  at scale 0.9375, in this order:
  `level_hallway.png` (darker hallway) → `level_seg1.png` →
  `level_seg2.png` → `level_seg4.png` (boiler room) →
  `level_seg5.png` (broken wall) → `level_seg6.png` (hallway) →
  `level_seg3.png` (EXIT + elevator — the ENDING panel; goal post stands
  at the elevator doors, x=9765). CORRECTION 2026-10-24: the elevator
  panel was first placed mid-map by file number; the user confirmed the
  ending panel is the exit+elevator one, so it was moved last.
- Panels are placed edge-to-edge with no gaps or overlaps (1290 px
  spacing = 1376 × 0.9375), but the art was rendered as separate screens,
  so the joints are visible hard cuts, not one blended panorama.
- Theme file from the zip: `nocturnal_mischief/DESIGN.md` (dark surfaces
  `#111319`, warm light `#ffeac9`/`#ffc857`) — kept in the zip extract at
  `~/workspace/tools/jtmp/stitch/`, not copied into the project.

## Controls & mechanics (verified 2026-10-24, 13/13 logic-test checks)

- Move left/right: A/D or arrow keys. Jump: Space (coyote time +
  jump buffer). Crouch: S or Down (slower move, squashed collision +
  visual; stands up only when headroom is clear, and jumping while
  crouched stands up first). Shoot: X (bullet, 0.25 s cooldown;
  kills monsters, dies on walls/ground).
- Test: `test_player.gd` (headless, simulates real key presses).
  Screenshots: `screenshot_tool.gd` renders one shot per screen
  (output outside the project so exports stay small).

## Level facts (so new art fits)

- Viewport: 1280x720, landscape. Level width: 10320 px.
- Ground top at y = 600. Player spawn at (100, 600), origin at feet.
- Camera: `Camera2D` in `scenes/main.tscn` follows the player horizontally
  only (see `scripts/camera_follow.gd`), clamped to x 0..10320.
- Goal post at x = 10050. Monsters patrol around x = 1500, 2700, 4200,
  6200, 8800. 26 coins, 23 platforms across the full length.
- Touch controls are NOT built yet — they will drive the same input
  actions (`move_left`, `move_right`, `jump`) when added.
