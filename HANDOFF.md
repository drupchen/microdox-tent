# Handoff — Charybdis project

Written to hand this work to a Claude Code session running on Drupchen's own machine.
Everything below is either verified (how is stated) or flagged as assumed. Where something
was got wrong earlier and corrected, the correction is recorded, because the wrong version
is the intuitive one and will otherwise be re-derived.

The previous session ran in a cloud container with no access to the keyboard or the local
filesystem. **A local session can do things it could not**: flash firmware, run
`bluetoothctl`/`gdbus` against the real device, measure parts, and test.

---

## 1. The two strands

| | repo | branch |
|---|---|---|
| Firmware | `drupchen/zmk-for-charybdis` | **`Charybdis_4x6`** — not `main` |
| 3D-printed stand | `drupchen/microdox-tent` | `main` |

They are independent. Nothing in one depends on the other.

---

## 2. Hardware, as established

Charybdis 4x6 bought on AliExpress, ~€250 without switches or keycaps. Hot-swap.
Printed parts are upstream BastardKB geometry; the seller is violating the CC BY-NC-SA 4.0
non-commercial term, which is their problem, not a build issue.

- **Controllers**: ProMicro nRF52840 "SuperMini" clones, built as `nice_nano_v2`.
- **Right half is the central** (`Kconfig.defconfig` sets `ZMK_SPLIT_BLE_ROLE_CENTRAL` for
  `charybdis_right`). It carries the trackball and talks to the computer.
- **Sensor is PMW3610**, not PMW3360. An early session claimed PMW3360 and wrote a swap
  recommendation on that basis; it was wrong. PMW3610 draws 0.6 mA against the 3360's 23.4.
- **Trackball is 34 mm** on **three** bearings. Established rather than measured: it passes
  through the stock 35.00 mm aperture, so it is under 35, and 34 is the stock size. A
  photo-based estimate of ~42 mm was wrong (the boxes it was wedged between weren't
  vertical), and a count of six bearings from a dark photo was also wrong.
- **Batteries**: 304070, labelled 3.7 V 1500 mAh. The cell is 8.4 cm³ and LiPo runs about
  0.38 Wh/cm³, so true capacity is nearer **850 mAh**. Judge battery readings against that.
- **Bluetooth MAC**: `E2:A2:5E:92:72:51`, advertises as `Charybdis`.

### The bottom plates — the surprising part

The two halves carry plates from **two different boards**:

| half | plate | evidence |
|---|---|---|
| left | **Scylla MK1** | tracing matches to 0.58 mm rms (vs 6.30 against Charybdis) |
| right | **Charybdis MK1** | tracing matches to 0.51 mm rms (vs 5.89 against Scylla) |

This is not a clone oddity — it is what the `tenting-stand-with-wrist-pads` mod ships
(`left-case-bottom-scylla.3mf`, `right-case-bottom-charybdis.3mf`). It explains the
different thumb clusters and an early confusing measurement (45 mm on one hand, 50 on the
other: inner-edge-to-inner-edge versus centre-to-centre across the same ~49 mm spacing).

Both plates are **remixes** of the published parts: battery tray, a square cable opening and
a reset plunger replace the stock pair of 5 mm openings, and the hole beside the USB-C is
gone. **Only the six-hole mounting pattern carried over unchanged** — which is fortunate,
since it is the only thing that has to be right to a tenth of a millimetre.

**The reset plunger's dome protrudes on the INSIDE**, toward the PCB. You press the flexure
tab from outside. So the outer face — the one a stand bolts against — is flat and needs no
relief pocket, only a through-hole so the tab stays reachable. (An earlier session had this
backwards and designed a pocket for it.)

The rig itself is BastardKB's `files/mods/tenting-stand-with-wrist-pads`: hinged skeletal
bottom plates, a honeycomb strut, `pads-arm`, `pads-base`, `pads-holder`. Drupchen kept only
`pads-holder` — a bare 120 × 83 × 10 mm bezel with **no screw holes, tabs or bosses**, which
is why the rest is currently twist-tied to the mesh.

---

## 3. Ergonomics, as recorded

- **Tent is 90°, settled.** Vertical. This is the end of the range: the forearm is in true
  neutral and pronation is zero; past vertical it would supinate. The angle question is
  closed, which is what a one-shot print needs.
- At 90° the outer (USB/pinky) edge is at the bottom, so **the keys face outward** and the
  hands come in from outside. This decides every force direction in the design.
- **Splay ~28°/side, ~56° included — STALE.** Measured on the 58° rig. Re-measure before
  cutting. Count grid squares: lay a stick along a plate edge, `atan(across/along)`.
- Hand is in full handshake with the little finger extended backwards. At 58° there was a
  30° hand-to-board mismatch the fingers absorbed; 90° removes it at the source. **Whether
  the pinky stretch survives at 90° is an open question** and a clean test: if it persists,
  the tent was never the cause and only rest position and keymap remain.
- Rest position and height at 90° are **unmeasured**. The hand meets the board much higher
  than at 58°.

---

## 4. Firmware — what is on `Charybdis_4x6`

All merged and building green. Flashed and working as of 2026-11-08.

| change | why |
|---|---|
| `CONFIG_ZMK_SLEEP=y`, idle/sleep timeouts | ZMK does **not** enable deep sleep by default, so the external rail and the trackball sensor never powered down. The main battery fix. |
| `&spi3 { status = "disabled"; }` in both overlays | nRF52840 anomaly 195: SPIM3 keeps drawing ~900 µA after disable. |
| Dropped `CONFIG_BT_CTLR_TX_PWR_PLUS_8` | Maximum TX power for halves 30 cm apart, costing battery for nothing. |
| `CONFIG_ZMK_BATTERY_REPORTING=y` | Defaults to `n`. Setting the report interval alone did nothing, which is why no battery level ever appeared. |
| `CONFIG_ZMK_SPLIT_BLE_CENTRAL_BATTERY_LEVEL_FETCHING/_PROXY=y` (right only) | Without these the host sees one battery. The peripheral's level never leaves the split link. |
| `CONFIG_BT_PERIPHERAL_PREF_LATENCY=0` (right only) | Default 30 against a 7.5 ms interval lets the keyboard skip up to ~225 ms. Sparse keypresses never notice; 125 mouse reports/s queue and the pointer carries on after the ball stops. |
| `west.yml` pinned to `1d9c2c68…` | The pmw3610 driver was tracking `main`. |
| Deleted duplicate `charybdis_right.conf` | Both the shield's and `config/`'s copies applied; editing one appeared to do nothing. |

### Firmware gotchas

- **Adding or removing a GATT service invalidates the host's cached attribute table.** This
  manifested as the trackball working on USB but dead over Bluetooth — not as a missing
  battery. Fix is a full both-sides clear: `bluetoothctl remove <MAC>`, then **Ctrl/Esc +
  Left Shift** on the keyboard followed by **A** (`BT_CLR_ALL`), then re-pair. Clearing only
  one side gives `PIN or Key Missing (0x06)` then `Authentication Failure (0x05)` in
  `btmon`, and an endless connect/disconnect loop.
- The VDDH battery reading tracks the supply, so **it pegs at 100% whenever USB is plugged
  in**. There is no usable divider pin — `P0.24` is wired as a matrix row.
- `nice_nano_v2.dts` **already** defines `vbatt` with `compatible = "zmk,battery-nrf-vddh"`.
  Adding a second node with that compatible makes it instance 1, and the driver only does
  `DEVICE_DT_INST_DEFINE(0, …)`, so the build fails to link with
  `undefined reference to __device_dts_ord_25`. An earlier session did exactly this.
- `CONFIG_PMW3610_POLLING_RATE_125_SW` is **not** software polling. It sets the sensor's
  internal rate register to the 250 Hz value and coalesces pairs of interrupt-driven
  reports. `FORCE_AWAKE` is correctly off; the REST2/REST3 zeros are guarded and simply
  leave chip defaults in place.
- `gh repo view --json` fails (no GraphQL); use `gh api repos/{owner}/{repo}`.

### Still open on firmware

- **Progressive keypress lag** over a day or two off USB, worse over Bluetooth, cured by a
  power cycle but not by plugging in. Never bisected. Best theory is accumulating firmware
  state (suspects: ZMK Studio, the pmw3610 driver fork). **Deep sleep will now mask it**,
  because System OFF wake is a reset — so to investigate, disable sleep first. The decisive
  untested experiment: power-cycle while lagging, *without* charging, and see how long it
  stays fast.
- Trackball over BLE is "acceptable" but comes and goes, with occasional jumps. WiFi was off
  throughout, so the user's own radio is ruled out. Remaining suspects: other 2.4 GHz
  traffic, and the central time-slicing one radio between the host and the split link. The
  untried lever is raising `CONFIG_ZMK_SPLIT_BLE_PREF_INT` from 6 to 12, halving the split
  link's share. Keypresses wouldn't suffer — they have data pending either way.
- `btusb enable_autosuspend` is `Y` on the host. Latent cause of future dropouts. Not applied.

### Battery monitor

`~/bin/zmk-batt` on the user's machine reports both halves for conky; `conky-charybdis.conf`
holds the block. Two things it had to work around:

- **`busctl` cannot serialise BlueZ's `GetManagedObjects` reply to JSON** — it returns
  `Failed to dump DBus message to JSON object: Invalid argument`.
- **`bluetoothctl gatt.read` is asynchronous**; piping commands in returns before BlueZ
  answers. Use `gdbus call --system --dest org.bluez --object-path <path> --method
  org.bluez.GattCharacteristic1.ReadValue "{}"`, which is synchronous.

Discovery is `bluetoothctl gatt.list-attributes <MAC>`, which **does not return attributes
in handle order**. The two halves are told apart by reading the Characteristic User
Description: the proxy's reads `Peripheral 0`, the central's has none. Both carry a
presentation-format descriptor, so presence alone does not distinguish them.

---

## 5. The stand — `drupchen/microdox-tent`

A fork of `josephdcaputo/microdox-tent`, retargeted from Microdox to Charybdis and from a
tenting wedge to a vertical stand.

### Files

| | |
|---|---|
| `cad/microdox_ribs.scad` | Upstream's wedge, 20–35°. Untouched but for a comment. |
| `cad/vertical.scad` | The 90° stand. **Still built on Microdox geometry — this is the thing to retarget.** |
| `cad/charybdis_ref.scad` | Right plate: outline, six holes, reset plunger, cable opening. |
| `cad/scylla_ref.scad` | Left plate, same form. |
| `cad/pad_ring_ref.scad` | The gel-pad bezel's profile, sliced from BastardKB's own mesh. |
| `cad/charybdis_template.scad` | 1:1 printable overlay for checking a pattern against a plate. |
| `README.md` | Long-form record of every measurement with confidence levels. |

Hole positions come from upstream **DXFs** (exact circles, not meshes) and are good to
0.01 mm. Feature positions come from Drupchen's A4 tracings, perspective-corrected and
mapped through the six holes, good to ~0.5 mm.

### Why the wedge could not simply be given a bigger angle

`plate_in_x()` collapses from ~87 mm at 30° to `plate_t` at 90°, `foot_x()` goes negative,
and the wishbone ribs invert through the plate. The `tent_deg` assert is a real structural
limit. 36–89° is unexplored; neither file covers it.

### Current design, and the two changes it still needs

Two walls and a spine between them, flanges turned up at the spine's outer ends, no base
plates and no braces. Structure lives **inboard**, in the dead space between the halves —
an earlier version put a 139 × 105 mm base plate outboard under the hands, which was 62% of
each half's mass and in the wrong place.

- **Splay is printed into the flange angle**, not chosen at assembly, so it cannot be got
  wrong when repacking. Sign follows `place_half()` in `microdox_ref.scad`.
- **Distance is a half-lap with a shared hole row.** The two rows run in opposite
  directions, so holes only meet where `h1 + h2 == gap` — the gap is quantised and the file
  asserts on it. An early version was 10 mm out of phase at every position.
- **Board retention is a lip plus bolts with different jobs**: the lip carries weight in
  compression, the bolts only stop it lifting or being pulled off by the trackball. At 90°
  keypresses push the board *into* the wall, so the bolts are nearly unloaded.

**Change 1 — add the upper bar.** A second bar between the walls at about key height. The
reason is quantitative: a 6 mm wall 150 mm tall deflects only **0.18 mm** under 1.5 N, but
an M3 bolt in a 3.4 mm hole has 0.4 mm of clearance, and rocking a 24 mm-spaced joint
through that clearance gives **2.5 mm at the top**. So 93% of the movement is slop, not
bending — more material will not help. An upper bar reacts the keypress at the height it is
applied and removes the lever arm.

**Change 2 — seat the bar ends in pockets**, so compression bears on a shoulder instead of
loading bolts in shear. Clearance then closes once and the joint is solid.

**Change 3 — retarget to the two real plates.** Two different walls, not one part flipped.
The Charybdis plate is 153.6 × 149.6 and the Scylla 155.2 × 149.5, against the Microdox's
100 × 93, so the wall grows from ~100 mm tall to ~150 mm and both mass and tipping moments
rise with it. The 98 g core figure will not survive; expect half as much again.

### Stability reasoning, so it is not re-derived

At 90° the keys face outward, so **a keypress pushes each half inward**, into the spine,
which takes it in compression — axial stiffness about 11,500 N/mm, so a keypress compresses
it by a ten-thousandth of a millimetre. That load path is solid.

What is *not* automatic is standing up. `docs/check_results/stability.txt`, generated from
this repo's own geometry, shows a lone wedge-mounted half going from 101 N at 20° to 3.4 N
at 35°. Extrapolated to vertical there is essentially no restoring moment left. **The spine
is what stops the keyboard falling over, not a convenience that holds splay.** One half must
never be stood up alone.

### Rest kit

`carrier` replaces `pads-base` (51 g → 20 g), built around the bezel's own sliced profile.
`rest_arm` is a plain adjustable blade, deliberately **not** committed to a fixing point —
where it attaches depends on the unmeasured rest position at 90°, and `rest_lift` is 0
rather than a guess, because guessing it is a reprint. A 120 × 83 mm rest on each half
roughly doubles the footprint, so detachable may be the right answer anyway.

### Printing

No printer. A shop in Lousã charges by weight and machine time, around €0.05/g. The plan is
to prototype in cardboard, measure carefully, and print **once**. The flat-plate
construction serves both: the same 2D profiles cut in cardboard.

Print the trackball retainer first, on its own — it is a few grams, and it shows how the
shop's printer handles a part with one tight functional dimension before anything expensive
is committed.

### Trackball retention

The stock aperture is 35.00 mm against a 34 mm ball: a full millimetre of clearance, so the
ball was never held, only rested. **At 90° the socket faces sideways and nothing retains it
at all.** Upstream's `mods/trackball_retainer/4x6/trackball_retainer.stl` has a 33.50 mm
aperture on the same mounting face — a confirmed drop-in, and now a prerequisite rather than
an upgrade. Its height is tuned for the `static-bearing-screws` mod, so check that before
trusting the fit; the bearing count is three, which is stock.

---

## 6. Local environment

```bash
sudo apt install openscad xvfb librsvg2-bin
pip install trimesh shapely rtree numpy opencv-python-headless
```

- Render headless with `xvfb-run -a openscad …`; plain `openscad --render -o out.png` writes
  a zero-byte file with no GL context.
- `include <foo.scad>` resolves relative to the including **file**, so run OpenSCAD from the
  directory containing it, or pass an absolute path.
- Check exported parts with `trimesh`: `is_watertight`, and `(2 - euler_number) // 2` for the
  hole count. Both caught real bugs in this work.
- `rsvg-convert -f pdf` preserves true scale for 1:1 templates; verify by parsing
  `/MediaBox` out of the PDF (it may be inside a compressed object stream).

---

## 7. What to do next

1. **Retarget `cad/vertical.scad`** to `charybdis_ref.scad` and `scylla_ref.scad`, with the
   upper bar and the pocketed bar ends. Two handed walls.
2. **Re-measure splay at 90°**, and re-trace the layout: the tracing on file was taken at
   58°, and splay, spacing and rest position are the three things most likely to have moved.
   At 90° each half's footprint is also much narrower.
3. **Measure the rest height at 90°** — sets `rest_lift`.
4. Cardboard mock-up, then one print.
5. Separately, when there is appetite: the lag bisection, and `enable_autosuspend=0`.

Watch the conky battery readout over the next few days. The right half will always drain
faster — it runs the sensor, two BLE connections and the host link — so the useful figure is
%/hour, not the gap between halves. Against a real ~850 mAh, the original "flat in a day or
two" implies something was pulling around 25 mA, one to two orders of magnitude more than it
should. The fixes above should show up plainly.
