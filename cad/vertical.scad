// vertical.scad - 90 deg (fully vertical) tenting stand, flat-plate construction.
//
// Why a second file instead of widening microdox_ribs.scad: the "Ribs" stand is a wedge.
// Its geometry degenerates as the tent approaches vertical - plate_in_x() collapses from
// ~87 mm at 30 deg to plate_t (3 mm) at 90 deg, foot_x() goes negative, and the wishbone
// ribs invert through the plate. No parameter value turns a wedge into a bookend. The
// assert in that file is a real limit, not a conservative one. 36..89 deg is unexplored:
// neither file covers it.
//
// What IS kept from it: the dovetail joint, included directly and unchanged, so every
// spacer and coupler already in stl/joint/ fits these stands. top_slope() is
// max(30, 50 - tent_deg), which is 30 for every tent in 20..35, so the joint geometry
// never depended on the tent angle. That is why the spine survives the architecture
// change and the stand does not.
//
// Orientation at 90 deg. The board's outer (USB / pinky) edge is at the bottom and its
// inner (thumb) edge at the top, so the keys face OUTWARD, away from the other half, and
// the hands come in from outside. That falls out of the repo's own frame: in
// microdox_ribs.scad the keyboard sits at local +z above the plate, and here local +z
// maps to world -x.
//
// Load path. Because the keys face outward, a keypress pushes each half INWARD, toward
// the other one. The halves lean on the spine and the spine takes it in compression.
// Contrast the wedge case, where docs/check_results/stability.txt shows the restoring
// moment collapsing: a lone half rocks at 101 N at 20 deg but 3.4 N at 35 deg. At 90 deg
// a lone half has essentially no restoring moment. The spine stops being a convenience
// that holds splay and becomes the thing that stops the keyboard falling over.
// Do not stand one of these up on its own.
//
// Construction: three flat plates per half, all mat_t thick, slotted into each other.
//   wall    the board bolts onto it with its stock bottom screws; passes through the
//           base and lands on the desk, so the load goes straight down
//   brace   two gussets behind the wall, tabbed into the wall and down through the base
//   base    deck plate; carries the dovetail tongues on its inner edge
// Flat plates because the shop charges by weight and machine time, and because the same
// 2D profiles cut directly in cardboard for the mock-up.
//
// Board geometry is still Microdox v1 (microdox_ref.scad). The Charybdis bolt pattern is
// NOT measured yet, so nothing here is printable for a Charybdis. Retarget by replacing
// PCB_OUTLINE / M2_HOLES in microdox_ref.scad. See README.

include <microdox_ribs.scad>
part = "none";          // suppress the included file's own top-level output

/* ---------- main knobs ---------- */
vpart    = "assembly";
mat_t    = 6.0;         // plate thickness; every part is this thick
base_out = 70;          // base reaches this far past the wall on the key side
base_in  = 60;          // and this far behind it; the tongue face is at x = base_in
fit      = 0.30;        // slot width added over mat_t (total, not per side)

/* ---------- wall ---------- */
wall_rim    = 5;        // solid border round the board outline
wall_boss_d = 14;       // solid land round each stock screw
brace_vs    = [20, 74]; // brace positions along the board's y axis
brace_slot  = 24;       // height of the brace tab where it passes through the wall
tab_up      = 10;       // first brace tab starts this far above the base top

/* ---------- brace ---------- */
brace_reach = 36;       // how far the gusset extends behind the wall
brace_frac  = 0.55;     // gusset height as a fraction of the board's length

/* ---------- base ---------- */
bar_pad = 8;            // tongue bar overhangs the outer tongues by this much along y
y_pad   = 6;            // base material beyond the board's y extent

$fn = 48;

assert(mat_t >= 4, "mat_t must be >= 4 mm; thinner plates flex under a keypress at this height");
assert(base_in >= mat_t + brace_reach + bar_w + 4, "base_in too small: braces and tongue bar overlap");

BOARD_U = 100.092;      // board extent along the tenting axis -> becomes height
BOARD_V =  93.384;      // board extent along the fingers      -> stays horizontal
FOOT_Y  = [4.0, 88.5];  // y span of the board outline at its bottom (u ~ 0) edge, +1.5 offset
                        // and a little slack. The wall's foot and the base slot share it.

function board_z0() = mat_t;                        // board's outer edge sits level with the base top
function brace_h()  = BOARD_U * brace_frac;
function slot_w()   = mat_t + fit;

/* ================= wall ================= */
// 2D in board coordinates: local x = u (0 at the outer edge, becomes "up"), local y = v.
// Extruded through local z in [-mat_t, 0], exactly like the plate in microdox_ribs.scad,
// so the keyboard occupies local z > 0 and ends up outboard.
module wall2d() difference() {
    union() {
        offset(r = 1.5) pcb_outline();
        translate([-mat_t, FOOT_Y[0]]) square([mat_t + 1, FOOT_Y[1] - FOOT_Y[0]]);  // foot, down to the desk
    }
    offset(r = 4) offset(delta = -4) difference() {              // lightening, soft corners
        offset(delta = -wall_rim) pcb_outline();
        for (h = M2_HOLES) translate(h) circle(d = wall_boss_d); // keep a land round every screw
        translate(CTRL_ZONE[0] - [2, 2]) square(CTRL_ZONE[1] - CTRL_ZONE[0] + [4, 4]);
        for (v = brace_vs) translate([-5, v - mat_t / 2 - 4]) square([BOARD_U + 10, mat_t + 8]);
    }
    for (h = M2_HOLES) translate(h) circle(d = screw_hole_d);    // stock bottom screws
    for (v = brace_vs)                                           // closed slots for the brace tabs
        translate([tab_up, v - slot_w() / 2]) square([brace_slot, slot_w()]);
}
module wall_placed() translate([0, 0, board_z0()]) rotate([0, -90, 0])
    translate([0, 0, -mat_t]) linear_extrude(mat_t) wall2d();

/* ================= brace ================= */
// Drawn directly in world (x, z): upright edge against the wall's back face at x = mat_t,
// bottom edge on the base top at z = mat_t, hypotenuse falling away behind.
// rotate([90,0,0]) maps the profile's local y onto world z, as the ribs do.
bt_xs = [mat_t + 5, mat_t + brace_reach - 19];   // down-tab positions behind the wall
module brace2d() union() {
    polygon([[mat_t, mat_t], [mat_t + brace_reach, mat_t], [mat_t, mat_t + brace_h()]]);
    translate([0, mat_t + tab_up]) square([mat_t, brace_slot]);              // tab through the wall
    for (x = bt_xs) translate([x, 0]) square([14, mat_t + 0.01]);            // tabs down through the base
}
module brace_placed(v) translate([0, v + mat_t / 2, 0]) rotate([90, 0, 0]) linear_extrude(mat_t) brace2d();

/* ================= base ================= */
module base2d() offset(r = -6) offset(delta = 6)
    translate([-base_out, -y_pad]) square([base_out + base_in, BOARD_V + 2 * y_pad]);
module base_cuts() {
    translate([-fit / 2, FOOT_Y[0], -1]) cube([slot_w(), FOOT_Y[1] - FOOT_Y[0], mat_t + 2]);   // wall
    for (v = brace_vs) for (x = bt_xs)
        translate([x, v - slot_w() / 2, -1]) cube([14, slot_w(), mat_t + 2]);                  // brace tabs
}
module tongue_bar() translate([base_in - bar_w, tongue_ys[0] - bar_pad, 0])
    cube([bar_w, tongue_ys[1] - tongue_ys[0] + 2 * bar_pad, joint_h]);
module base() difference() {
    union() {
        linear_extrude(mat_t) base2d();
        tongue_bar();
        for (ty = tongue_ys) translate([base_in, ty, 0]) sloped_tongue();
    }
    base_cuts();
}

/* ================= preview ================= */
module keyboard_placeholder_v() translate([0, 0, board_z0()]) rotate([0, -90, 0]) {
    color([0.22, 0.24, 0.27]) translate([0, 0, standoff_h]) linear_extrude(1.6) pcb_outline();
    color([0.93, 0.92, 0.88]) translate([0, 0, standoff_h + 1.6 + 6])
        linear_extrude(cap_top_above_pcb - 6) keycap_keepout_2d(extra = -0.5);
}
module half_left() color([0.95, 0.47, 0.32]) { base(); wall_placed(); for (v = brace_vs) brace_placed(v); }
module mirrored_right() translate([2 * base_in + spacer_len, 0, 0]) mirror([1, 0, 0]) children();

/* ================= output ================= */
// Flat parts are exported lying on the bed, which is also how they cut in cardboard.
// wall and brace are plain prisms, so the same part serves either hand - flip it over.
// The base is not: its tongues stand proud on one face, so it has a left and a right.
if (vpart == "wall")       linear_extrude(mat_t) wall2d();
if (vpart == "brace")      linear_extrude(mat_t) brace2d();
if (vpart == "base")       base();
if (vpart == "base_right") mirror([1, 0, 0]) base();
if (vpart == "half")  half_left();
if (vpart == "assembly") {
    half_left();
    keyboard_placeholder_v();
    mirrored_right() { half_left(); keyboard_placeholder_v(); }
    color([0.98, 0.72, 0.40]) translate([base_in, 0, 0]) spacer_use();
}
