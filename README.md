# charybdis-tent

A fully vertical (90°) stand for Drupchen's split Bastard Keyboards build: the left half on a
Scylla MK1 bottom plate, the right half on a Charybdis MK1 plate. It started as a fork of
[josephdcaputo/microdox-tent](https://github.com/josephdcaputo/microdox-tent); none of the
upstream wedge is left, because at 90° a wedge is the wrong shape and the stand became a
bookend.

It has to work on a lap in a reclining chair, hold splay and distance repeatably, and fold
flat into a bag without taking the boards off.

![The 90° stand, both halves on the spine](docs/images/assembly_vertical.png)

## What's in here

| | |
|---|---|
| `cad/vertical.scad` | The stand. One parametric file; every part, the assembly, and the asserts that check it. |
| `cad/charybdis_ref.scad`, `cad/scylla_ref.scad` | The two real bottom plates: outline, six mounting holes, reset plunger, cable opening. Holes from the upstream DXFs, checked against tracings of both plates (0.5–0.6 mm rms). |
| `stl/vertical/` | The parts, ready to print. Right-hand parts are already mirrored. |
| `OWED.md` | Running record of what was found, asked and decided. |

Export a part with `openscad -D 'vpart="wall_left"' -o wall_left.stl cad/vertical.scad`
(`--backend=manifold` is much faster). `vpart="none"` runs only the asserts: an empty echo
means they all pass.

## Parts

| part | print | |
|---|---|---|
| `wall_left`, `wall_right` | 1 each | Flat frame the board screws to: a foot that is the wall's half of the hinge, two columns, a top bar, four screw seats. Different parts, because the halves carry different plates. Print board face down, lobes up. |
| `spine_left`, `spine_right` | 1 each | Flat plate on the desk between the halves: the other half of the hinge at its outer end, half-lapped with its partner in the middle through a hole row. Hollowed: rim, hinge strip, haunch feet and a centre bar stay solid. |
| `haunch` | 3 | A 30 × 108 mm, 8 mm thick triangular knee brace, open in the middle, that slots into wall and plate on the inboard side; one M4 × 16 at each end. |
| `haunch_key` | 1 | The same haunch with a snap clip for the 3 mm hex key on one face (two channels and a stop under the tip; long leg vertical, short leg under the top pad). It goes on the left half's far haunch, clip facing away from you. Print it clip up. |
| `lap_pin` | 6 | A headed pin, 3.1 mm shaft, dropped into each pair of lined-up lap holes (4 at the 270 mm gap, up to 6 at 250). It takes the lap's shear; gravity and the boards hold the halves down. |

Mass, solid PETG: walls 38 + 39 g, plates 41 g each, haunches 20 g each, pins 0.1 g:
~239 g in all.

**Hardware, per half:** one 3 mm steel rod, 96 mm long (the hinge pin); 4 × M4 × 16
socket-head screws and 4 × M4 nuts (the eight sets from the Bastardkb wrist-pad stand's
hinges, reused); and the four board screws that fit the 3 mm Bastardkb stand plate.

## How it works

**Everything is inboard.** At 90° the space between the two halves is dead: no hands, no
keycaps, no cables. It is the one place structure doesn't get in the way, so the plates,
haunches and joint all live there. The boards stand straight on the desk, outboard of their
walls, and their own screws hold them on.

**Stability comes from the joint.** The keys face outward, so a keypress pushes each half
*inward*, toward the other, and the haunches take it in compression. A lone half has almost
no restoring moment at 90° (upstream's wedge already tipped over under 7 N at 35°), so the
lapped plates are what keep the keyboard upright. Never stand one half up on its own.

**The hinge.** Wall and plate meet in a five-knuckle hinge exactly as thick as the plate
(6 mm). Its axis sits just inboard of the wall, at the plate's mid-thickness, so standing,
every knuckle lies within the plate's thickness: flush top and bottom, and the wall's foot
stands on the desk along its whole length. It folds **inward**, from 90° (standing) to 0°
(the wall lying on its own plate, board on top, keys up), which is how it packs. Nothing in
the hinge holds 90°: inward the haunches do; outward the board does, since it stands on the
desk outboard of the wall and the lap holds the plate down. The plate owns both end
knuckles, so the two low board screws land in plate knuckles, with no lobe in front of
their heads (asserted). Clash-tested wall against plate every 15° from 0° to 90°.

**The haunches.** Two per half, flat triangles, the shape a steel portal frame uses at its
knee. Each top sits just under one of the board's two top screws, 108 mm above the plate, so
slack in a joint is magnified about 1.4× at the top of the board. Each one touches wall and
plate only at its two ends, a tab into a slot plus one M4 × 16 at each:

- **Wall joint.** The nut sits in a hex pocket on the wall's *board* face, under the board,
  so tightening pulls it against the wall, and once the board is on it cannot fall out. The
  screw goes in from the haunch's outer edge, its head in a notch there, and the hex key
  reaches it from inboard. A 3.7 mm ring just under the head, which the thread cuts through
  once, keeps the screw in the haunch when it is out of the wall. Nothing under the board
  ever has to be undone.
- **Plate joint.** The screw comes up from the desk side, its head sunk in a counterbore in
  the plate's underside, into a nut standing in a cross-slot in the haunch's foot.

The second haunch sits at v = 103 mm so it and its wall nut clear the left wall's reset hole
with 2.7 mm to spare (the file checks every haunch feature against the openings' real cuts).

**The wall is a frame along the load paths.** The board's case is the stiff member, so the
wall does not need to follow its shape. Four of each plate's six screw positions hold the
board, the same four the Bastardkb wrist-pad stand plate uses: the two at the bottom, in the
hinge, and the two at the top, tied across to the haunches' top pads. Each seat copies that
plate's (a ~10 mm countersink with 3 mm under it) at the bottom of a 3 mm counterbore, so
the same screws work in the 6 mm wall. The reset plunger and the cable opening are left open.

**Splay is printed into the hinge line.** Each plate's hinge edge is turned by half the
splay, 28° per side (56° included, Drupchen's setting, confirmed at 90° on 2026-11-08), so
nothing has to be aimed by eye when reassembling. Distance is the thing you adjust.

**Distance: a half-lap.** The two plates are relieved to half thickness over their inner
80 mm, on opposite faces, so they interlock to full thickness and are pinned through a shared
hole row at 10 mm pitch. The rows run in opposite directions, so holes only meet in 10 mm
steps. Drupchen measured 22 cm between the keyboards' edges at their closest point (the far
end, where the halves converge); at 28° per side that is 270 mm between the walls' inboard
faces on the centreline, set as the **middle** of the range:

| gap (centreline) | keyboards at closest | pins |
|---|---|---|
| 250 mm | ~202 mm | 6 |
| 260 mm | ~211 mm | 5 |
| **270 mm** | **220 mm** | **4** |
| 280 mm | ~229 mm | 3 |
| 290 mm | ~238 mm | 2 |

Changing the gap needs no reprint, only a different pair of holes.

## Assembly

Order matters. Per half:

1. Press the two wall nuts into their pockets on the board face.
2. Screw the board onto the wall, with the wall on its own: once the plate is hinged on, its
   knuckles cover the low screws. The board keeps the nuts in for good.
3. Push the pin through the knuckles and stand the wall up.
4. Drop in the haunches and screw each one: the top screw from the haunch's edge into the
   wall nut, the foot screw up from under the plate into the nut in the haunch's foot.

Then slide the two halves' laps together and drop a pin into each pair of lined-up holes.
Bolt the haunches before joining the halves, while the key has room.

**To pack, boards left on:** lift the pins out and pull the halves apart, undo the four haunch
screws on each half, lift the haunches out, and fold each wall onto its plate. The top screws
stay in their haunches and the wall nuts stay under the board; only the foot nuts come loose,
so keep them with the haunches. The key rides on its haunch. Folded, a wall reaches about
150 mm inboard, past the lap, so the halves have to come apart to fold.

## Printing

PETG, not PLA: the parts carry the boards' weight continuously, and PLA creeps under
sustained load. Every part is a flat plate, so they print flat and nest.

## Open questions

- **Does 90° hold up over a full working day?** It has been typed on and liked, but the
  symptoms this project chases are hours-scale.
- **Does the case reach below the bottom plate's edge?** The wall's foot is flush with the
  plate's bottom edge on the desk; if the case reaches lower, the wall stands that much proud.
- **Trackball at 90°.** The stock top adapter's 35.00 mm aperture does not retain the 34 mm
  ball once the socket faces sideways; fit BastardKB's trackball retainer mod (33.50 mm)
  before standing the right half up.

## Credits

- [josephdcaputo/microdox-tent](https://github.com/josephdcaputo/microdox-tent): where this
  started, and the idea of a parametric stand with collision checks.
- [Bastard Keyboards](https://github.com/Bastardkb/Charybdis): the Charybdis and Scylla
  plate geometry the walls are built on, and the wrist-pad stand whose screws and nuts this
  reuses. CC BY-NC-SA 4.0.
