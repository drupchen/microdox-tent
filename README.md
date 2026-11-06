# charybdis-tent

A fork of [josephdcaputo/microdox-tent](https://github.com/josephdcaputo/microdox-tent),
retargeted from the Boardsource Microdox v2 to a **Bastard Keyboards Charybdis**,
and extended to much steeper tent angles.

Upstream gives us the architecture this needs: one printed stand per half that the
keyboard screws onto, plus a printed spacer that locks the two halves at a chosen
spacing and splay so they behave as one board — all from a single parametric
OpenSCAD file, with collision checking between the stands, the spacer and both
keyboard halves.

What changes here is the angle range, the target board, and the fact that the whole
thing has to work on a lap and then go in a bag.

---

## Why this fork exists

The keyboard currently sits on a folding wire grid table resting on my legs in a
zero-gravity recliner. The halves are held by the upstream Charybdis *modular
adjustable tenting stand* (hinged voronoi plates, slotted steel strut dropping into
a ratchet rail), and the whole assembly — stands and palm rests both — is lashed to
the wire mesh with twist-ties.

It works. Nothing moves. But:

1. **The tent angle is capped by the rig, not chosen.** The current 58° is the
   steepest the strut reaches while the base stays on the grid. It is a ceiling, not
   a preference — and there is evidence (below) that my hands want more.
2. **It isn't portable.** The grid table folds but won't go in a bag, and without it
   the geometry is gone: splay, spacing and rest position all live in twist-ties.
3. **The geometry isn't recorded anywhere.** If the rig were knocked apart, the splay
   in particular would take weeks to rediscover by trial and error.

The goal is to turn the geometry into a file and a set of parts.

---

## Measurements

### Tent angle

Measured with a phone level app (accelerometer, not the compass — the compass is
useless this close to a steel wire rack). The phone was held flat against the **base
plate of each half**, which is the plane the tenting mechanism actually controls. A
vertical plane between the halves was used as the 0° datum.

| | off vertical | from horizontal |
|---|---|---|
| Left half | 31° | 59° |
| Right half | 33° | 57° |
| **Mean** | **32°** | **~58°** |

Opposite signs, so the halves roll toward each other as expected.

**This is a ceiling, not a target.** See *Open questions* below.

### Splay

Measured from a top-down photo against the wire grid, using two straight sticks laid
along the inner edges of the foot plates.

- **~28° per side** from the fore-aft axis
- **~56° included** between the halves

Confidence: moderate. Needs confirming by counting grid squares — lay a stick along a
plate edge, count squares across versus along, `atan(across/along)`. Integer counts,
no measurement error.

This is the number most worth recording. The tent angle could be rediscovered by feel
in ten minutes; a 56° splay could not.

### Symmetry

A **2° left/right difference** has shown up twice, from two different sensors
measuring two different physical quantities:

- Magnetic headings against a midline reference: 61° and 59°
- Level readings off vertical: 31° and 33°

Unlikely to be coincidence in both. Still undecided whether this is a real asymmetry
worth preserving or accumulated drift in the ratchet that I've adapted to.
Test: swap the halves left-for-right and see whether one side suddenly feels wrong.

### Hand posture

- Full **handshake orientation** — hand close to vertical, forearm supported on the
  chair's armrest, pronation essentially eliminated.
- Heel of the palm rests on a **rocking support**: printed cradle, glass dome, ribbed
  foam grip on top. The dome is a deliberate pivot, letting the hand rotate as the
  fingers move between columns. Nothing bounds its travel, which is the one thing
  about it worth fixing.
- **Float test passes**: I can lift the hand clear of the rest and type the home row
  with no change in finger reach. So the rest is a locating surface, not a load path —
  the forearm's weight goes into the armrest, not into the heel of the palm.
- **The pinky is held stretched backwards.** This is the open ergonomic problem.

### The 30° mismatch

Hand at ~90°, board at 58°. Something absorbs the difference, and it's the fingers.
Index through ring are flexing, which they're built for. The little finger can't, so
it extends backwards instead and stays there.

Taking the left half steeper (it has no trackball to fall out) noticeably eased the
tension. That is the main evidence that 58° is too shallow.

### Trackball retention

The stock top adapter does not retain the ball at all. Measured off the upstream STLs:

| | stock `adapter_v4_v4_top.stl` | `mods/trackball_retainer/4x6/trackball_retainer.stl` |
|---|---|---|
| Footprint | 45.60 mm | 45.60 mm |
| Mounting face | −19.00 | −19.00 |
| Top face | −1.00 | **+2.00** |
| Narrowest point above the ball | **35.00 mm** | **33.50 mm** |

Every cross-section below the stock top face is numerically identical between the two
files — the retainer is literally the stock part with 3 mm added.

A 35.00 mm aperture against a 34 mm ball means a full millimetre of clearance: the ball
was never held, only rested. At 58° it is marginal; past that it unseats and leaves one
of its lower contact points.

The retainer's 33.50 mm aperture is smaller than the ball, so the equator cannot pass.
In normal use the ball's width at that height is only ~29 mm, so it's a hard stop rather
than a squeeze. **At steep tent that changes** — gravity presses the ball against the
rim continuously, so expect rim contact and some drag. Upstream's own notes say rotation
feels stiff at first and eases with use.

Note: upstream says the retainer's height is tuned for the `static-bearing-screws` mod,
not the stock bearings. My socket appears to have more contact points than stock, so the
fit needs checking before trusting it.

---

## Requirements

### Must

- Work on a **lap**, in a reclined zero-gravity chair, not only on a desk.
- Capture **tent, splay and inter-half distance** repeatably — set it down, pick it up,
  same geometry.
- **Pack flat** and fit in a bag.
- Reach **~70–75° tent**, well beyond upstream's 20–35° range.
- Work with the trackball retained at that angle.

### Should

- Carry the **palm rests** as part of the geometry. Where the palm pivots sets where all
  four fingers land; leaving the rests behind loses the setup, not just a comfort item.
- **Feet that do both jobs** — pegs that drop into the wire mesh for positive location at
  home, and a flat pad for a table when away.
- Nothing held by **friction**. Pinned, slotted or bolted only, so nothing creeps.

### Constraints

- **No 3D printer.** A print shop in Lousã, charging by weight and machine time at roughly
  €0.05/g (≈€20 for a ~400 g part). So: flat plates, not solid wedges — a fraction of the
  Z height and roughly half the material. Web everything out.
- **One print job.** All prototyping happens in cardboard first; the printed version is a
  transcription of something already proven.
- **PETG, not PLA.** The parts carry the keyboard's weight continuously once tented, and
  PLA creeps under sustained load.

### Explicit non-requirements

- **No adjustment mechanism.** Because the angle gets found in cardboard, the printed part
  can be a single fixed angle — lighter, stronger, cheaper and simpler than detents or
  bolt arrays. Adjustability was only ever a workaround for not being able to iterate.
- No need to print a lap deck. The grid table at home, a table away, or a thin plywood or
  acrylic sheet — the deck is interchangeable and the printed parts carry only the geometry.

---

## Hardware as built

- Charybdis, built from the upstream BastardKB STLs, apparently unmodified except for the
  tenting base. Sourced cheaply; the printed parts are stock files.
- Stock trackball top adapter in place (`adapter_v4_v4_top.stl` / `adapter_v2_top_v75.stl` —
  identical bounding boxes). Removable, which means a full 360° capture ring is viable and
  removing it is how the ball gets cleaned.
- Current tenting: upstream modular adjustable tenting stand, angle set by which ratchet
  tooth the strut's fork sits in, held there by a twist-tie.
- Palm rests: printed peanut-shaped cradle, glass dome, ribbed foam grip, twist-tied to the
  mesh.

---

## Open questions

Ordered by how much they block the design.

1. **What is the right tent angle?** 58° is a ceiling. Cardboard test pairs at 65° and 75°
   bracket the likely answer. Each angle needs a full working session, not five minutes —
   the symptoms being chased are hours-scale, and a wrong angle feels fine for the first
   few minutes.
2. **Is the pinky stretch caused by the tent, the rest position, or the keymap?** Three
   candidates, each cheap to test: take the tent steeper; move the rest forward or outward;
   or remap whatever key the little finger is reaching for. Only the first two are a
   hardware problem.
3. **Real asymmetry or ratchet drift?** Decides whether this is one mirrored part or two
   distinct ones.
4. **Does the upstream trackball retainer fit this socket?** Depends on ball diameter and
   on where the lower bearings sit.

### Still to measure

- Bolt pattern on the case bottom plate (requires opening the keyboard)
- Trackball diameter — assumed 34 mm, unconfirmed
- Lower bearing count and diameter — the socket appears to have more contacts than stock
- Wire grid pitch and wire diameter
- Palm rest positions, in grid squares from a common corner
- Print shop bed size and exact per-gram rate

### Method note

Before dismantling anything, **trace the current layout**: lay cardboard over the grid, put
both halves and both rests in position, draw around all four, mark the inner corners. That
single tracing captures splay, spacing and rest position at once, with no angles and no
arithmetic — and it becomes the baseplate template directly. Once the halves come off the
grid, that information is gone.

---

## Changes planned against upstream

| | upstream microdox-tent | here |
|---|---|---|
| Target board | Microdox v2 | Charybdis |
| Tent range | 20–35° | ~55–80° |
| Mounting | replaces stock 2.0 mm bottom plate | TBD — likely bolts to the existing bottom-plate pattern |
| Construction | printed ribbed stand | flat plates, slot-and-tab, for cost and packing |
| Surface | desk | lap deck, wire mesh, or table |
| Transport | — | comes apart, packs flat |
| Palm rests | not addressed | carried on the spine |
| Trackball | n/a | needs retention at steep tent |

The spacer geometry and the collision checking are the parts worth keeping as-is — they're
the hard bit, and they're already solved.

---

## Credits

- [josephdcaputo/microdox-tent](https://github.com/josephdcaputo/microdox-tent) — the stand
  and spacer architecture, and the parametric OpenSCAD implementation this forks.
- [Bastard Keyboards](https://github.com/Bastardkb/Charybdis) — the Charybdis itself, the
  modular adjustable tenting stand, and the trackball retainer mod. CC BY-NC-SA 4.0.

Worth reading before cutting anything:

- [rgoulter/keyboard-labs](https://github.com/rgoulter/keyboard-labs) — `keyboard_tenting_stand.scad`,
  a laser-cut parametric tenting stand. Laser-cut means flat plates, which is both the
  cost-efficient print and the thing that cuts directly in cardboard.
- [AlSpheric's Iris stand](https://github.com/Ivaan/shapes/tree/master/IrisKeyboardStand) —
  parametric, generated from a list of plate screw coordinates, so it retargets to any split
  board with top/bottom plates and standoffs.
