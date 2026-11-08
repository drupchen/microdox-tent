// vertical.scad - 90 deg (fully vertical) stand. Two walls and a splayed spine. No base plates.
//
// Supersedes the earlier version of this file, which gave each half a 139 x 105 mm base
// plate. That was wrong twice over: the plate was 62% of each half's mass, and it put the
// structure OUTBOARD, under the hands, while leaving the ~170 mm of air between the two
// vertical halves completely empty. At 90 deg that gap is dead space - no hands, no
// keycaps, no cables - and it is the only place structure does not get in the way.
//
// So everything moved inboard:
//   wall    flat plate, board bolts to its outer face, bottom edge stands on the desk
//   spine   flat plate between the halves, with an upturned flange at its outer end that
//           the wall bolts to face-to-face. Two handed halves, half-lapped and bolted
//           through a hole row, so the distance between the halves stays adjustable.
// No braces and no feet: a bolted face-to-face lap is already a moment connection, and the
// wall's own bottom edge carries the vertical load straight to the desk.
//
// Why this is stable. A keypress pushes each half INWARD (the keys face outward at 90 deg),
// so the halves lean on the spine and it takes the load in compression. Outward tipping
// pivots about each wall's outer bottom edge and would have to lift the spine AND the other
// half, which is a large restoring moment. The repo's own docs/check_results/stability.txt
// shows a lone wedge-mounted half collapsing from 101 N at 20 deg to 3.4 N at 35 deg; at
// 90 deg a lone half has essentially none left. Do not stand one of these up on its own.
//
// Splay is built into the printed flange angle, not chosen at assembly. That is deliberate:
// splay is the one measurement that cannot be rediscovered by feel, so it should be
// impossible to reassemble wrong. Distance is the thing you adjust, via the hole row.
//
// Board retention is a lip AND two bolts, with different jobs. The lip carries the weight
// in compression; the bolts only stop the board lifting or being pulled off by working the
// trackball. Clearance holes are provided at all five mount points - use whichever two or
// three of yours line up.
//
// Board geometry is still Microdox v1 (microdox_ref.scad). The Charybdis bolt pattern is
// NOT measured yet, so nothing here is printable for a Charybdis. Retarget by replacing
// PCB_OUTLINE / M2_HOLES in microdox_ref.scad; a pencil rubbing of the bottom plate gives
// them 1:1. See README.

include <microdox_ref.scad>
include <pad_ring_ref.scad>

vpart = "assembly";
$fn   = 48;

/* ---------- material ---------- */
mat_t = 6.0;            // every flat part is this thick
fit   = 0.30;           // clearance added to slots and laps

/* ---------- splay ---------- */
// Total included angle between the halves. README records ~28 deg per side / ~56 included,
// but that was measured on the 58 deg rig and is STALE - re-measure before printing.
splay_deg = 56;

/* ---------- board mount ---------- */
lip_z     = 10;         // board's bottom edge sits this high; keeps the lip under the USB port
lip_t     = 5;          // thickness of the lip shelf
lip_reach = 14;         // MEASURE: how far the lip must reach to sit under the case
m2_hole_d = 2.6;        // M2 clearance (prints ~0.2 small)
wall_rim  = 5;
wall_boss = 14;

/* ---------- spine ---------- */
// gap is NOT free: the two hole rows only meet where h1 + h2 == gap, so gap moves in
// hole_pitch steps. The assert below lists the values that actually work.
gap        = 156;       // assembled flange-face to flange-face distance
spine_len  = 100;       // each half, flange face to inner tip
spine_w    = 88;
lap_len    = 70;        // length of the half-thickness overlap region
hole_pitch = 10;
flange_h   = 38;
flange_t   = 6;
m3_clear   = 3.4;

BOARD_U = 100.092;      // board extent along the tenting axis -> vertical
BOARD_V =  93.384;      // board extent along the fingers      -> horizontal
FOOT_Y  = [4.0, 88.5];  // y span of the board outline at its bottom edge, with slack

// Negative so that positive splay_deg means the same here as in microdox_ref.scad's
// place_half(): the halves converge away from you, matching how the forearms come in.
// If the tracing says otherwise, pass a negative splay_deg rather than editing this.
function a_half()   = -splay_deg / 2;
function overlap()  = 2 * spine_len - gap;
function bolt_vs()  = [BOARD_V / 2 - 26, BOARD_V / 2 + 26];
function bolt_us()  = [mat_t - lip_z + 6, mat_t - lip_z + flange_h - 12];
function spine_y(v) = v - BOARD_V / 2;          // wall's v axis -> spine's y axis

assert(mat_t >= 4, "mat_t must be >= 4 mm; thinner plates flex under a keypress at this height");
assert(overlap() >= 15 && overlap() <= lap_len,
       str("overlap is ", overlap(), " mm; must be 15..", lap_len, ". Change gap or spine_len."));
assert(len(aligned_hs()) >= 2,
       str("gap ", gap, " mm does not line the two bolt rows up. Usable gaps: ", usable_gaps()));
assert(lip_reach > 0, "lip_reach is a MEASURE value - set it from the case before printing");

/* ================= wall ================= */
// Print frame: local x = u (0 at the board's bottom edge, vertical in use), local y = v,
// extruded in local z by mat_t. The board goes on the +z face, so in use the keys face
// outward. The lip stands up from that same face at the bottom.
module wall2d() difference() {
    union() {
        offset(r = 1.5) pcb_outline();
        translate([-lip_z, FOOT_Y[0]]) square([lip_z + 1, FOOT_Y[1] - FOOT_Y[0]]);  // down to the desk
    }
    offset(r = 4) offset(delta = -4) difference() {                 // lightening, soft corners
        offset(delta = -wall_rim) pcb_outline();
        for (h = M2_HOLES) translate(h) circle(d = wall_boss);      // land round every mount point
        translate(CTRL_ZONE[0] - [2, 2]) square(CTRL_ZONE[1] - CTRL_ZONE[0] + [4, 4]);
        for (v = bolt_vs()) translate([-lip_z - 1, v - 11]) square([flange_h + 6, 22]);  // keep the bolt band solid
    }
    for (h = M2_HOLES) translate(h) circle(d = m2_hole_d);          // board screws: use any two or three
    for (v = bolt_vs()) for (u = bolt_us()) translate([u, v]) circle(d = m3_clear);  // to the flange
}
module wall() {
    linear_extrude(mat_t) wall2d();
    translate([-lip_t, FOOT_Y[0] + 2, mat_t])                       // the lip the board rests on
        cube([lip_t, FOOT_Y[1] - FOOT_Y[0] - 4, lip_reach]);
}
// Stand it up: local x -> world z, local z -> world -x, so the wall occupies x in
// [-mat_t, 0] - outboard of the flange, whose outer face is at x = 0 - and the board and
// lip sit further out still. Bottom edge lands on z = 0 and carries the load to the desk.
module wall_in_use() translate([0, -BOARD_V / 2, lip_z]) rotate([0, -90, 0]) wall();

/* ================= spine ================= */
// Print frame: plate lies in XY from the flange plane out to +x, flange standing up at the
// outer end. The flange plane is rotated by half the splay about z, so the wall bolted to it
// comes out splayed and nothing has to be aimed by eye at assembly.
module outboard_cut(h) rotate([0, 0, a_half()]) translate([-300, -300, -1]) cube([300, 600, h + 2]);
module spine_plate2d() difference() {
    offset(r = -5) offset(delta = 5)
        translate([-30, -spine_w / 2]) square([spine_len + 30, spine_w]);
    projection(cut = false) outboard_cut(1);                 // trim flush with the flange plane
}
// Only outside the lap: in the overlap each plate is half thickness and every bit of it is
// bolted bearing area, so holes there would cost stiffness exactly where the joint needs it.
module spine_lightening() for (s = [-1, 1])
    translate([18, s * 23, -1]) linear_extrude(mat_t + 2)
        offset(r = 5) offset(delta = -5) square([18, 34], center = true);
module lap_relief() translate([spine_len - lap_len, -spine_w / 2 - 1, mat_t / 2])
    cube([lap_len + 1, spine_w + 2, mat_t]);
// Both halves carry the same row, so a hole at h on one meets a hole at gap - h on the
// other. Mirrored parts, so the rows are counter-running: only some gaps line up at all.
function n_lap()  = floor((lap_len - 16) / hole_pitch);
function lap_h(i) = spine_len - lap_len + 8 + i * hole_pitch;
function aligned_hs() = [for (i = [0:n_lap()]) for (j = [0:n_lap()])
                         if (abs(lap_h(i) + lap_h(j) - gap) < 0.01) lap_h(i)];
function usable_gaps() = [for (g = [2*lap_h(0) : hole_pitch : 2*lap_h(n_lap())])
                          if (2*spine_len - g >= 15 && 2*spine_len - g <= lap_len) g];
module lap_holes() for (i = [0 : n_lap()])
    translate([lap_h(i), 0, -1]) cylinder(d = m3_clear, h = mat_t + 2);
module flange() rotate([0, 0, a_half()]) translate([0, -84 / 2, mat_t])
    cube([flange_t, 84, flange_h - mat_t]);
module flange_holes() rotate([0, 0, a_half()]) for (v = bolt_vs()) for (u = bolt_us())
    translate([-1, spine_y(v), u + lip_z]) rotate([0, 90, 0]) cylinder(d = m3_clear, h = flange_t + 2);

// handed: "a" is relieved on its top face, "b" on its bottom, so the two half-lap together.
module spine_half(hand = "a") difference() {
    union() {
        difference() {
            linear_extrude(mat_t) spine_plate2d();
            if (hand == "a") lap_relief();          // keeps the lower half
            else translate([0, 0, -mat_t]) lap_relief();   // keeps the upper half
            spine_lightening();
        }
        flange();
    }
    lap_holes();
    flange_holes();
}

/* ================= rest kit ================= */
// Replaces pads-base from Bastardkb/charybdis (files/mods/tenting-stand-with-wrist-pads),
// which is a 28 mm hollow kidney weighing ~51 g. The part Drupchen kept is pads-holder:
// a bare 10 mm bezel with no screw holes, no tabs and no bosses - it only traps the gel
// pad's rim, so dropping the body dropped the only part with a mounting interface.
// The profile here is sliced from that bezel's own mesh (see pad_ring_ref.scad), so the
// ring drops straight in rather than being fitted to a guess.
//
// rest_lift is a MEASURE value and currently 0. At 90 deg the hand meets the board much
// higher than it did at 58 deg, so the rest almost certainly needs raising - but by how
// much is one of the open questions in the README, and a wrong guess here is a reprint.
// At 0 this is a flat tray. Raise it and the tray grows a thin open skirt, still far
// lighter than the original body because the walls are 3 mm and the bottom is open.
carrier_t    = 3.5;     // floor the gel pad sits on
carrier_rim  = 3.0;     // upstand the bezel drops into
carrier_wall = 3.0;     // skirt wall thickness when lifted
rest_lift    = 0;       // MEASURE: height under the pad
arm_w        = 24;      // adjustable blade
arm_len      = 140;
arm_pitch    = 10;

function ring_pad()  = carrier_rim + 1.5;                       // material outside the bezel
function carrier_h() = rest_lift + carrier_t;
function arm_bolt_ys() = [14, 32];      // along the carrier's long axis, x on centreline
function carrier_cx()  = 41.5;          // centre of the measured bezel profile
function carrier_cy()  = 60.0;

module carrier_outer2d() offset(delta = ring_pad()) pad_ring_outline();
module carrier() {
    cx = 0; cy = 0;
    difference() {
        union() {
            if (rest_lift > 0)                                  // open skirt, bottom open
                linear_extrude(rest_lift) difference() {
                    carrier_outer2d();
                    offset(delta = -carrier_wall) carrier_outer2d();
                }
            translate([0, 0, rest_lift]) linear_extrude(carrier_t) carrier_outer2d();
            translate([0, 0, carrier_h()]) linear_extrude(carrier_rim) difference() {
                carrier_outer2d();
                offset(delta = 0.4) pad_ring_outline();         // the bezel drops in here
            }
        }
        // lightening under the pad, kept small so the gel cannot bulge through
        // kept clear of the bolt line at the narrow end
        for (p = [[-13, 32], [13, 32], [0, 2]])
            translate([p[0] + carrier_cx(), p[1] + carrier_cy(), rest_lift - 1])
                linear_extrude(carrier_t + 2) offset(r = 5) offset(delta = -5) circle(d = 26);
        // arm bolts, through the floor
        for (y = arm_bolt_ys()) translate([carrier_cx(), y, rest_lift - 1])
            cylinder(d = m3_clear, h = carrier_t + 2);
    }
}

// A plain blade with a hole row at each end: one end bolts up into the carrier floor, the
// other goes wherever the rest turns out to belong. Deliberately not committed to a fixing
// point on the stand - that waits on the same measurement as rest_lift.
module rest_arm() difference() {
    linear_extrude(mat_t) offset(r = 4) offset(delta = -4)
        translate([-arm_w / 2, 0]) square([arm_w, arm_len]);
    for (y = arm_bolt_ys()) translate([0, y, -1]) cylinder(d = m3_clear, h = mat_t + 2);
    for (i = [0 : floor((arm_len - 75) / arm_pitch)])
        translate([0, 58 + i * arm_pitch, -1]) cylinder(d = m3_clear, h = mat_t + 2);
}

/* ================= assembly ================= */
module half_left() {
    translate([-gap / 2, 0, 0]) {
        color([0.95, 0.47, 0.32]) spine_half("a");
        color([0.80, 0.84, 0.90]) rotate([0, 0, a_half()]) translate([0, 0, 0]) wall_in_use();
    }
}
module half_right() mirror([1, 0, 0]) {
    translate([-gap / 2, 0, 0]) {
        color([0.95, 0.47, 0.32]) spine_half("b");
        color([0.80, 0.84, 0.90]) rotate([0, 0, a_half()]) wall_in_use();
    }
}
module board_ghost() color([0.22, 0.24, 0.27], 0.85)
    translate([0, -BOARD_V / 2, lip_z]) rotate([0, -90, 0]) translate([0, 0, mat_t + standoff_h])
        linear_extrude(1.6) pcb_outline();
module boards() {
    translate([-gap / 2, 0, 0]) rotate([0, 0, a_half()]) board_ghost();
    mirror([1, 0, 0]) translate([-gap / 2, 0, 0]) rotate([0, 0, a_half()]) board_ghost();
}

/* ================= output ================= */
if (vpart == "wall")        wall();
if (vpart == "spine_left")  spine_half("a");
if (vpart == "spine_right") spine_half("b");
if (vpart == "carrier")     carrier();
if (vpart == "rest_arm")    rest_arm();
if (vpart == "half")        half_left();
if (vpart == "assembly")  { half_left(); half_right(); boards(); }
