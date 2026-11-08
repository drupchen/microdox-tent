# Owed

Open items that must reach Drupchen. Close an item (mark `[x]` + date + how) only once it
was told, done, or answered. Never delete.

## Open

- [x] 2026-11-08 — Measurements needed from Drupchen before the stand can be printed
  (HANDOFF.md §7): splay per side at 90°, half-to-half spacing at 90° (sets `gap`), rest
  height at 90° (`rest_lift`). Splay and gap are stale (58° rig). (`lip_reach` dropped
  2026-11-08 with the lip.) New with the hinge: board screw head diameter + current length.
  (Case vs plate edge ANSWERED 2026-11-08: flush with the plate and the table; matches the design.)
  Splay: Drupchen believes he gave it; the only value on file is ~28 deg/side from the 58 deg
  rig (HANDOFF.md). Asked 2026-11-08 whether it still holds at 90. ANSWERED: holds, keep it.
  Board screws ANSWERED: the ones fitting the 3 mm Bastardkb plate. Still open: gap, rest_lift.
  Gap ANSWERED 2026-11-08: 22 cm at the closest point of the two walls (at 90). Applying.
  APPLIED 2026-11-08: read as inboard faces 220 apart at the closest point (far end, over
  the board's length) -> 280.5 on the centreline; gap 280, rail_len 100 -> 162 (44 overlap,
  3 bolt positions). Plates 28 -> 43 g, total ~243 g. Checks clean. Note: the printed frame
  walls don't reach the board's far corner, so the printed walls' own closest point is 233.
  ASKED: was the 22 cm between rig walls ~6 mm thick (-> 280), or between the boards
  themselves (-> 270, one hole step)? Told; ANSWERED below.
  ANSWERED 2026-11-08: between the keyboards' edges -> 270. And make 270 the CENTRE of the
  adjustable range (holes to go wider or narrower from it). Doing it.
  DONE 2026-11-08: gap 270 (boards 220.2 apart at closest, measured in the model), lap_len
  60 -> 80, rail_len 162: usable 250/260/270/280/290 with 6/5/4/3/2 bolts, 270 the middle
  (asserted; usable_gaps now needs >= 2 bolts). Laps interlock clean at 250/270/290, hinge
  clean, meshes watertight, plates 41 g, ~238 g total. Told.
- [x] 2026-11-08 — Question: does anything protrude from the plate's square cable opening
  (deeper than ~6 mm)? The wall has a hole there; the rails are kept clear of it either way.
  MOOT 2026-11-08: Drupchen sees no cable there. "Cable" was MY label, unfounded; the stock
  plate's openings there are on/off + reset, so it is most likely the power switch. The frame
  wall no longer covers it (v~140, outside the frame). Told.
- [x] 2026-11-08 — Drupchen: won't attach the rests -> spine hollowed (46.7 -> 27.5 g each,
  ~189 g total), checks clean. Asked whether to drop carrier/rest_arm + rest_lift. Told.
- [ ] 2026-11-08 — Retarget, bar removal and hinge redesign all done but NOT committed;
  awaiting Drupchen's go to commit.
- [x] 2026-11-08 — (superseded by the hinge design, ~246 g; told) Mass: walls + spines ~443 g solid PETG (~€15–21 at the shop's rate, less
  with infill), well over the handoff's "98 g × 1.5" guess. Dropping the bar did NOT make it
  lighter (I had predicted it would): taller flange + gussets + solid wall lands ate it.
  Levers if wanted: narrower spine plate, more wall lightening.
- [x] 2026-11-08 — ANSWERED by Drupchen: splay holds (tested at 90 since yesterday, same
  splay) -> keep 28 deg/side. Board screws: the ones that fit the 3 mm Bastardkb plate, so the
  wall must take the SAME screws (counterbore to 3 mm under the head). Doing it now.
  DONE 2026-11-08: seat = 10 mm countersink, 3 mm under the head, in a 3 mm counterbore;
  knuckles 7 -> 5 and foot_v [42,139] so the low seats fit in plate knuckles. Checks clean. Told.
- [x] 2026-11-08 — Question from Drupchen: any gain keeping the spine plate solid vs hollowing
  it? Answer owed.
  Answer: no structural gain (desk carries it); hollow prototype 27 g vs 46 g each (-38 g
  total). Only reason to stay solid: wrist-rest fixing point not chosen yet. Offered. Told.
- [x] 2026-11-08 — BUG found by Drupchen (render screenshot): board-screw seats (counterbore +
  countersink) cut on the BOARD face, not the inboard face. My board_seat() assumed z=0 is the
  board face; in wall_flat the board is on +z. Already told as done. Fixing.
  FIXED 2026-11-08: seat flipped (mirror in wall_flat); sliced: 10.3 mm at the inboard face,
  ~5 mm at the board face. Checks clean, rendered from the inboard side. Told.

- [x] 2026-11-08 — BUG (mine, found drawing the joint section for Drupchen): the haunch's
  WALL bolt goes in from the wall's board face, so its head is under the mounted board. It
  can't be undone without taking the board off, which contradicts what I just told him about
  folding (undo the haunch bolts, fold the wall with the board on). Plate bolts are fine (desk
  side). Must tell + propose a fix (e.g. heat-set insert in the wall from the inboard face,
  bolt put in through the haunch's outer edge). Not fixed; awaiting his choice.
  Told. Drupchen: removing the board defeats the purpose; keep the bolt when folding or change
  strategy. Proposed: drop the wall bolt (top joint = tab in slot, in compression; foot bolt
  from below holds the haunch), or a captive wall bolt + open slot + thumb nut. Awaiting go.
  Drupchen proposes inverting: nut in the wall, bolt in the haunch. Answer: works if the nut
  sits in a hex pocket on the wall's BOARD face (captive under the board, wall material
  between nut and haunch); a pocket on the inboard face would not clamp. Bolt head on the
  haunch's outer edge. Offered to build; awaiting go.
  Drupchen sent a photo of a socket-head cap screw (Image #13). Photo suggests ~M3 x 12 but
  scale is unreliable; asked for thread diameter + length under head + how many he has.
  Plan for a short screw: head in a through-window in the haunch pad, hex-key hole from the
  outer edge. Awaiting measurements.
  Drupchen: reuse the screws + nuts from the Bastardkb plate's hinge. MEASURED from plate.3mf +
  bottom.3mf: M4 (bore 4.2), nut pocket 7.0 AF x 2.0 deep (M4 nut 3.2 thick sticks out 1.2),
  plate boss 6 mm + brace ear 6 mm on the axis -> screw M4 x 12-14 (photo suggests 14).
  4 bosses per half -> 8 sets. Changes the joint: M4 not M3, head 7 mm > 6 mm haunch.
  Asked: length under the head (12/14/16?) and count. Told.
  ANSWERED 2026-11-08: all 8 sets; ruler photos -> M4 x 16, head ~7 x 4 (told). STARTED the
  inverted M4 joint: wall nut in a hex pocket on the board face, screw from the haunch's
  outer edge (head in a notch); foot: M4 up from the desk into a haunch cross-slot nut;
  haunch 6 -> 8 mm thick so an M4 runs in its plane. Not done until verified and told.
  FINISHED 2026-11-08 (to tell): built as above + a 3.7 mm keeper ring under the head so the
  top screw stays in its haunch; haunch_vs [64,105] -> [64,103] (the 8 mm haunch hit the left
  reset cut); plate solid under the whole foot. Asserts pass, clash-free (haunch x wall /
  plate / board; wall x plate 0/45/90), meshes watertight, ~212 g. STLs, assembly image,
  README, joint drawings redone. Told.

- [x] 2026-11-08 — FINISHED, Told (Drupchen's request): a clip on the back face of one haunch to
  carry his hex key (photos: 3 mm L-key, legs ~56 x 19 mm), and something to insert in each
  aligned lap-hole pair (reading: printed pins replacing the M3 lap bolts). Not done until
  verified and told.

- [ ] 2026-11-08 — Repo cleaned on request ("only keep what we have built"): removed the
  upstream wedge (microdox_ref/ribs, tools, check_results, reference/, stl/stands, joint,
  test-prints), the 1:1 fit template, HANDOFF.md, old images, and the rest kit (carrier,
  rest_arm, pad_ring_ref; closes the rest_lift question, since the rests aren't attached).
  README rewritten for the stand alone. All in git history at 45d80ce. Told. Commit still
  awaits go (item above).

## Closed

- [x] 2026-11-08 — Found (to tell): the Bastardkb stand plate uses exactly 4 of the 6
  Charybdis holes, CB 0,1,4,5 = right wall's 2 top (u~122-124, v 56/105) + 2 bottom (u~8,
  v 51/133); it drops (98.9,12.7) and (65.2,147.2). Matches Drupchen's "2 top, 2 bottom". Told.
- [x] 2026-11-08 — STARTED: load-path wall: foot strip + two columns on the haunch lines +
  bosses on the 4 used screws only (2 top, 2 bottom); rim/outline wall dropped. Not done
  until verified and told.
  FINISHED 2026-11-08: walls 37.5/38.7 g (were 55.6/55.5), total ~227 g. Asserts, meshes
  watertight, clash checks clean (wall x plate 0/30/60/90, haunch x wall/plate/board). Told.
- [x] 2026-11-08 — BUG (mine, in the tall-haunch build already told as "clean"): on the LEFT
  wall the v=107 haunch's bolt countersink (edge v 113.3) is 0.6 mm from the reset-hole cut
  (v 113.9): a sliver that would crack. Asserts only checked the haunch body, not its bolt
  head against the opening's clearance cut. Fix: haunch_vs 107 -> 105. Must tell.
  FIXED 2026-11-08: 2.6 mm now; clash assert grows openings by their cut + 2 mm and was
  shown to fail at 107. Told.

- [x] 2026-11-08 — Question from Drupchen: tall haunches reaching the top board screws for
  sturdiness? My answer (to tell): yes. Wobble from joint slop scales with H/haunch_h:
  60 -> ~120 mm halves it and halves bolt/tab loads; +~6 g per haunch. Top screws sit right
  above the haunch planes (left u~127 at v 64/105, right u~122 at v 56/105). Left reset
  hole at v~116-123 is within a mm of the v 110 haunch. Offered to build; awaiting go.
  Told; Drupchen said build. BUILT 2026-11-08: haunch_h 108, open frame (7 mm bars, pads at
  joints), joints only at the far ends, wall land kept only at the top pad, haunch_vs
  [64,107] (reset hole). Asserts, clash checks, meshes clean, ~262 g. Told.

- [x] 2026-11-08 — STARTED: hinge that folds 90 -> 0 (wall onto the plate, inboard), axis
  moved 3.5 mm inboard of the wall into the plate's plane; haunches stop it inward at 90,
  board on desk + joined plates stop it outboard. Low screws must move to PLATE knuckles
  (the wall's lobe now sits in front of their heads). Not done until verified and told.
  FINISHED 2026-11-08: asserts pass, clash-free 0..90 every 15 deg, meshes watertight,
  ~244 g. Told.

- [x] 2026-11-08 — Question answered (to tell): gain of a Bastardkb-like frame wall vs the
  current wall: ~0 g (frame through the 6 screws 56/58 g vs current 59/56 g; the current
  wall is already a lightened rim). Gain is only a smaller sheet (~134x127 vs 151x158).
  Bastardkb plate itself: 25 g at 3 mm, 4 holes.
  Told 2026-11-08.

- [x] 2026-11-08 — BUG in my own hinge report: I told Drupchen the wall opens 90->180 "board on
  top, keys up". Wrong: the board is on the wall's OUTBOARD face and stands on the desk, so
  opening outboard drives the board into the desk (scratchpad flat.png shows it under the
  wall). 90->180 only works with the board removed. Must tell him.
  Told 2026-11-08, and the README says so.

- [x] 2026-11-08 — Question: board screws through the 6 mm wall. Drupchen's current stand
  plate (Bastardkb tenting-stand-with-wrist-pads/plate.3mf) is 3.00 mm with countersunk
  holes, so his screws now are countersunk and stock+3. The wall needs stock+6 = current+3
  mm. Countersink the wall's board-screw holes so his flat heads sit flush? Answered YES
  2026-11-08; doing it with the hinge redesign below.

- [x] 2026-11-08 — STARTED: redesign per Drupchen. Wall-spine joint becomes a flush knuckle
  hinge, 90..180 deg, closing (stop) at 90; haunch becomes a separate insertable piece (1 or 2
  per half); no lip, the keyboard touches the desk, screws hold it. Plus countersunk board
  screws. Not done until verified and told.
  FINISHED 2026-11-08: 7-knuckle flush hinge (3 mm rod), stop ~84.5 deg, clash-free 90..180,
  2 haunches/half (tabs + M3x16 T-slot bolts), lip removed, board screws countersunk.
  Meshes watertight, asserts pass, ~246 g. Told.

- [x] 2026-11-08 — OpenSCAD installed locally (AppImage 2026.11.01 + wrapper
  `~/.local/bin/openscad` silencing GStreamer clash). Told.
- [x] 2026-11-08 — Retarget `cad/vertical.scad` to the Charybdis (right) and Scylla (left)
  plates, upper bar, tenon/mortise seats. Done, verified (asserts, watertight meshes, zero
  rail/wall interpenetration, no rail touches a board). Told in session.
- [x] 2026-11-08 — Bug found: the old `stl/vertical/spine_right.stl` was exported
  un-mirrored, i.e. the wrong hand (the assembly mirrors it, the export did not). Fixed in
  the new exports. Told in session.
- [x] 2026-11-08 — BUG found by Drupchen (tracing photo of the right bottom): to_uv() put
  the plates in transposed (a mirror image). Old mapping vs his tracing: 12.1 mm rms (no
  fit); corrected u = CB_H - y, v = x (right), u = y, v = x (left): 0.8 mm rms. Bands
  re-placed (v_c 90, spine flange v 60-124, bar u 62-92), STLs + render regenerated,
  asserts/meshes/clash checks clean. Told in session.
- [x] 2026-11-08 — Upper bar removed (Drupchen's go). Spine: 115 mm flange, bolt rows 97 mm
  apart, two 60 mm gussets (clipped at the lap; lap_len 70 -> 60 to give them 14 mm min
  reach at 28 deg splay), windowed flange, 2 x 3 mm dowel pins per joint. Flange stopped at
  u 103 to clear Scylla's reset hole. Asserts, watertight meshes, zero overlap. Told.
- [x] 2026-11-08 — Measured plate.3mf (Bastardkb tenting-stand-with-wrist-pads): plate 3.00
  mm, flat face to the keyboard; 10 mm bosses on the other face (13.0 overall); 4 holes on
  Charybdis screw positions (~1.4 mm rms, oblong ~5 mm), countersunk from the boss side,
  ~90 deg, ~10 mm at the surface. Told.
