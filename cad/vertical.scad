// vertical.scad - 90 deg (fully vertical) stand for Drupchen's Charybdis.
// Two handed walls, each hinged to a plate on the desk and braced by two slot-in haunches;
// the two plates half-lap in the middle. No upper bar, no lip: the boards stand on the desk.
//
// THE BOARDS. The two halves carry plates from two different boards (identified from Drupchen's tracings):
//   left  = Scylla MK1 plate     (scylla_ref.scad)
//   right = Charybdis MK1 plate  (charybdis_ref.scad)
// So the walls are two different parts, not one part flipped. Only the six mounting holes
// are good to a tenth of a millimetre (from upstream DXFs); the reset plunger and cable
// opening come from the tracings and are good to ~0.5 mm, so their holes here are generous.
//
// THE FRAME. Every wall is drawn in a "standing" frame (u, v), in mm:
//   u  height, 0 at the plate's bottom edge on the desk; the thumb cluster is at the top
//   v  horizontal, 0 at the near (user's) end, where the thumb cluster is
// Fixed against Drupchen's tracing of the right half's bottom, as seen from between the
// halves when mounted: thumb cluster top right (top left on the left half). The right
// plate fits that tracing at 0.8 mm rms in this frame; an earlier mapping had it
// transposed (12 mm rms, holes that would not meet the board). to_uv() maps either ref
// file into this frame, written for the LEFT half. The right half is built as the mirror image of a
// left half (its plate mirrored into the left convention, then the whole half mirrored back
// in assembly), so one set of modules serves both.
// In this frame the two six-hole patterns are nearly mirror-identical (within ~2 mm), which
// is why one set of band positions below clears both boards. The asserts check that.
//
// THE HINGE. It folds INWARD: from 90 deg (standing) down to 0 deg (the wall lying on its
// own plate, board on top, keys up) for the bag. The axis is not in the wall but just inboard
// of it, at mid-thickness of the plate (hinge_axis()): the wall's knuckles are lobes that
// reach hinge_gap + mat_t into the plate's plane, the plate's knuckles reach out to meet
// them. Standing, every knuckle lies within the plate's thickness: flush top and bottom, and
// the wall's foot stands on the desk unbroken. Folded, the wall lies hinge_gap above the
// plate. The wall's inboard face stays hinge_gap + mat_t/2 from the axis at every angle and
// the plate's knuckles are mat_t/2 round it, so nothing has to be cut out of the wall for
// the fold: the clearance is geometric, not swept.
// Nothing in the hinge stops it at 90. Inward, the haunches do. Outward, the board does:
// it stands on the desk outboard of the wall, so the wall cannot fall outward without
// lifting its plate, and the plate is held down by the other half through the lap. That
// also means the hinge cannot open past 90 with the board on.
// A 3 mm steel rod is the pin: it turns in the wall's knuckles and grips in the plate's.
// The plate owns both end knuckles, and the two low board screws on each wall must land in
// plate knuckles (asserted): in a wall knuckle the lobe stands in front of the screw head.
//
// THE HAUNCHES. Two per half, separate flat triangles that slot in on the inboard side:
// one tab into the wall, one into the plate, for location and shear; one M4 x 16 per leg, for
// tension: at the top into a nut pocketed in the wall's board face (screw driven from the
// haunch's edge, so nothing under the board is ever undone), at the foot up from the desk into
// a nut in a cross-slot in the haunch. A keypress pushes each half
// INWARD (keys face outward), which closes the corner: the haunch takes it in compression.
// The board's weight hangs outboard of the hinge and tries to open the corner: the screws take
// that, in tension: a few newtons. Two rather than one so that the wall cannot rack about a single
// brace; spread as far as the board screws and the half-lap allow. The plate leg stops short
// of the lap, where the other half's plate arrives (asserted).
//
// STABILITY. A lone half has essentially no restoring moment at 90 deg (upstream's wedge
// already tipped over under 7 N at 35 deg). The plates are what stop the keyboard falling over.
// Never stand one half up on its own.
//
// ASSEMBLY. Per half: board onto the wall FIRST, wall alone on the bench (screws from the
// inboard side, through wall and plate into the case's inserts, countersunk: the length the
// Bastardkb plate needed + 3 mm). With the plate on, its knuckles cover the low screws. Press
// the wall nuts into their board-face pockets before the board too: it keeps them there. Then
// push the pin through wall and plate knuckles, stand the wall up, drop in the haunches, screw
// them (top from the haunch's edge, foot from under the plate). Then bring the halves
// together, sliding the laps, and push the lap_staple into two lined-up holes. To pack,
// board left on: lift the staple out, undo the haunch screws, lift the haunches out, fold each wall onto its own plate. Folded, a wall reaches ~150 mm inboard, past the lap, so
// the halves cannot stay joined while folded.
//
// INPUTS: splay_deg and gap were confirmed at 90 deg on 2026-11-08 (see below).

include <charybdis_ref.scad>
include <scylla_ref.scad>

vpart = "assembly";
$fn   = 48;

/* ---------- material ---------- */
mat_t = 6.0;            // every flat part is this thick
fit   = 0.30;           // clearance added to slots and laps
m3_clear = 3.4;

/* ---------- splay and distance ---------- */
// Total included angle between the halves: 28 deg per side, measured on the 58 deg rig and
// confirmed by Drupchen at 90 deg (2026-11-08).
splay_deg = 56;
// Drupchen, 2026-11-08, at 90 deg: 22 cm between the keyboards' edges at their closest point,
// which is the far end (the halves converge away from the user). With this splay and these
// boards, board faces 220 mm apart there is 269.9 mm between the walls' inboard faces on the
// centreline. He wants that as the MIDDLE of the range, free to go wider or narrower.
// gap is NOT free: the two hole rows only meet where h1 + h2 == gap, so gap moves in
// hole_pitch steps. usable_gaps() lists the ones with at least two bolts: 250..290 here,
// 270 in the middle (asserted).
gap        = 270;       // wall's inboard face to wall's inboard face, at the centreline
rail_len   = 162;       // each half, wall's inboard face to inner tip; 54 mm of overlap
lap_len    = 80;        // length of the half-thickness overlap region
hole_pitch = 10;

/* ---------- board mount ---------- */
board_screw_d = 3.4;    // the plate's holes are 4.0 with a countersink; stock screws are M3.
                        // MEASURE: if yours are bigger, raise this (max 4.0)
board_csk_d   = 10.0;   // Drupchen's board screws are the ones that fit the 3 mm Bastardkb
board_seat_t  = 3.0;    // stand plate, so each hole copies that plate's seat: a ~90 deg
                        // countersink ~10 mm across with 3 mm of material under it (measured
                        // from plate.3mf), sunk in a counterbore so the 6 mm wall takes the
                        // SAME screws. The head sits 3 mm below the inboard face.
board_screws_used = [0, 1, 4, 5];   // of the ref's six: the two top and the two bottom, the
                        // four the Bastardkb wrist-pad stand plate uses (same indices on both
                        // plates). The other two would land in open frame.
wall_boss = 16;         // solid land round every board screw: the 10 mm seat + 3 mm each side
wall_bar  = 10;         // width of the wall frame's members
wall_fillet = 4;        // radius filling the frame's inside corners
head_r    = 3.5;        // board-screw head radius plus a little, for clash checks

/* ---------- where things go, in the standing frame (u, v) ---------- */
reset_reach = 2.5;          // clearance round the reset tab; clash checks keep 2 mm more
foot_h     = 14;            // the wall's foot strip, up from the desk: hinge and bottom screws
v_c        = 90;            // the v that lands on the rails' centreline (world y = 0)
foot_v     = [42, 139];     // the wall's bottom edge on the desk = the hinge's length
spine_plate_v = [42, 139];  // the spine plate's width, across the rail

/* ---------- the hinge ---------- */
// A knuckle hinge exactly as thick as the plate, its axis at the plate's mid-thickness, just
// inboard of the wall. It folds from 90 deg (standing) to 0 deg (wall lying on its plate).
// Five knuckles: the plate owns the two ends and the middle; the wall the two between.
pin_d       = 3.0;      // steel rod, cut to the hinge's length
hinge_gap   = 0.5;          // air between the wall's inboard face and the plate's knuckles
pin_fit     = 0.3;      // the wall's knuckles turn on the pin; the plate's grip it
n_knuckles  = 5;           // 7 left no knuckle wide enough for a 10 mm screw seat

/* ---------- the haunches ---------- */
// Separate knee braces, two per half, each a flat 6 mm triangle in the plane normal to the
// hinge, as tall as the wall allows: its top sits just under the board's top screws. It
// joins wall and plate only at its two far ends: a tab into a slot near the top of the wall
// and one M4 screw, a tab into the plate at the leg's end and one M4 screw. So it is a
// triangular frame, open in the middle: three members, pads at the joints.
haunch_vs   = [64, 103];    // v of each haunch's near face; between the hinge's end
                            // screws, clear of every board feature
haunch_len  = 30;           // along the plate from the wall's inboard face; capped by the lap
haunch_h    = 108;          // up the wall from the plate's top face; under the top screws
haunch_pad  = [14, 34];     // the top pad, [x' wide, z tall]: wall tab and bolt live in it
haunch_bar  = 7;            // width of the frame's members
haunch_chamfer = 1.5;       // inner corner, clear of the hinge's fit
wall_tab_z  = [haunch_h - 30, haunch_h - 16];   // tab into the wall, up from the plate's top
plate_tab_x = [8, 15];      // tab into the plate, measured in from the wall's inboard face
wall_bolt_z = haunch_h - 9; // wall-leg bolt, up from the plate's top face
plate_bolt_x= 21;           // plate-leg bolt, in from the wall's inboard face
tab_d       = mat_t - 0.6;  // tabs stop short of the board behind the wall and of the desk
haunch_t    = 8;            // thicker than mat_t: an M4 runs along its plane, the nut stands in it
// Drupchen's screws: the 8 M4 x 16 socket-head screws and nuts from the Bastardkb stand's
// hinges (measured from its plate.3mf: 4.2 bore, 7.0 mm nut pocket; length by ruler).
m4_clear    = 4.4;
m4_nut_af   = 7.0;
m4_nut_t    = 3.2;
m4_head_d   = 7.0;
m4_head_k   = 4.0;
m4_len      = 16;           // under the head
tip_in      = 0.5;          // the tip stops this far inside the nut's outer face
// Wall joint: the nut sits in a hex pocket on the wall's BOARD face, under the board, so it is
// pulled against the wall when tightened (a pocket on the inboard face would just let go);
// the screw goes in from the haunch's outer edge, its head in a notch there.
wall_nut_d  = m4_nut_t + 0.3;                       // pocket depth from the board face
wall_head_x = m4_len - (mat_t - tip_in);            // x' of the head's seat in the haunch
// Just under the head, the bore narrows to a ring the screw's thread cuts its way through
// once; past it the screw turns free but cannot fall out, so it stays in the haunch when the
// stand is packed.
keep_d      = 3.7;
keep_l      = 2.5;
// Plate joint: the screw comes up from under the plate, its head in a counterbore, into a nut
// standing in a cross-slot in the haunch's foot.
plate_cb_d  = m4_head_k + 0.3;                      // counterbore depth from the desk face
foot_tip_z  = plate_cb_d + m4_len - mat_t;          // tip, above the plate's top face

/* ================= the boards in the standing frame ================= */
function to_uv(side, p) = side == "left"
    ? [p[1], p[0]]                                         // Scylla
    : [CB_PLATE_SIZE[1] - p[1], p[0]];                     // Charybdis, mirrored to a left
function uvs(side, pts)     = [for (p = pts) to_uv(side, p)];
function b_outline(side)    = uvs(side, side == "left" ? SC_OUTLINE : CB_OUTLINE);
function b_screws(side)     = let(a = uvs(side, side == "left" ? SC_SCREWS : CB_SCREWS))
                              [for (i = board_screws_used) a[i]];
function top_screws(side)   = [for (h = b_screws(side)) if (h[0] > foot_h) h];
// reset plunger and cable opening: [centre, size]. Both mappings swap the ref's x and y,
// so a bbox's [x, y] size becomes [v, u] here: reverse it.
function swap(s) = [s[1], s[0]];
function b_reset(side)  = side == "left" ? [to_uv(side, SC_RESET),  swap(SC_RESET_BBOX)]
                                         : [to_uv(side, CB_RESET),  swap(CB_RESET_BBOX)];
function b_square(side) = side == "left" ? [to_uv(side, SC_SQUARE), swap(SC_SQUARE_BBOX)]
                                         : [to_uv(side, CB_SQUARE), swap(CB_SQUARE_BBOX)];
function plate_t(side)  = side == "left" ? SC_PLATE_T : CB_PLATE_T;

module board2d(side) polygon(b_outline(side));
module feature2d(f, grow) translate(f[0] - f[1] / 2 - [grow, grow])
    offset(r = 1.5) offset(delta = -1.5) square(f[1] + 2 * [grow, grow]);

/* ================= the hinge frame ================= */
// Everything at the joint is drawn in the HINGE FRAME: the rail frame turned by a_half(), so
//   x'  across the hinge, 0 at the wall's inboard face, + toward the plate (inboard)
//   y'  along the hinge, = v - v_c
//   z   height above the desk
// The wall stands in x' in [-mat_t, 0]; the plate lies in z in [0, mat_t]. The axis is at
// x' = hinge_gap + mat_t/2, z = mat_t/2. Folding turns the wall inward about it, so at 0 deg
// the wall lies on the plate, inboard face down, hinge_gap above it.
function a_half()     = -splay_deg / 2;    // + converges the halves away from the user
function overlap()    = 2 * rail_len - gap;
function rail_y(v)    = v - v_c;           // wall v -> hinge y'
function lap_start()  = rail_len - lap_len;
function hinge_axis() = [hinge_gap + mat_t / 2, mat_t / 2];               // (x', z)
function hinge_ys()   = [rail_y(foot_v[0]), rail_y(foot_v[1])];
function knuckle(i)   = let(y = hinge_ys(), w = (y[1] - y[0]) / n_knuckles)
                        [y[0] + i * w, y[0] + (i + 1) * w];
function plate_knuckles() = [for (i = [0 : 2 : n_knuckles - 1]) knuckle(i)];   // owns the ends
function wall_knuckles()  = [for (i = [1 : 2 : n_knuckles - 1]) knuckle(i)];
// hinge frame (x', y') -> rail frame (x, y)
function to_rail(p) = [p[0] * cos(a_half()) - p[1] * sin(a_half()),
                       p[0] * sin(a_half()) + p[1] * cos(a_half())];

// a 2D profile in (x', z), extruded along y' from y0 to y1
module along(y0, y1) translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
// the wall turned about the axis; phi = 90 standing, 0 folded onto the plate
module wall_pose(phi) let(A = [hinge_axis()[0], 0, hinge_axis()[1]])
    translate(A) rotate([0, -(phi - 90), 0]) translate(-A) children();
// where the plate's body begins, everywhere along the hinge: clear of the wall's lobes
function plate_start() = hinge_axis()[0] + mat_t / 2 + fit;

// The plate's knuckle: round on the outboard side, square into the plate.
module plate_knuckle2d() hull() {
    translate(hinge_axis()) circle(d = mat_t);
    translate([hinge_axis()[0], 0]) square([plate_start() - hinge_axis()[0] + 1, mat_t]);
}
// The wall's knuckle: the wall's foot carried round the axis. Turned about the axis it only
// ever turns inside itself or away from the plate (dx <= 0), so it needs no sweep cut.
module wall_knuckle2d() hull() {
    translate([-mat_t, 0]) square([mat_t + hinge_axis()[0], mat_t]);
    translate(hinge_axis()) circle(d = mat_t);
}

/* ================= the spine (the plate on the desk) ================= */
// Print frame = rail frame: plate in XY, the hinge edge rotated by a_half(), the other half's
// plate lapping over the inner end. The hinge edge stops fit short of the wall's lobes.
module rail_plate2d() intersection() {
    offset(r = -5) offset(delta = 5)
        translate([-90, rail_y(spine_plate_v[0])])
            square([rail_len + 90, spine_plate_v[1] - spine_plate_v[0]]);
    rotate(a_half()) translate([plate_start(), -300]) square(600);
}
module lap_relief() translate([lap_start(), rail_y(spine_plate_v[0]) - 1, mat_t / 2])
    cube([lap_len + 1, spine_plate_v[1] - spine_plate_v[0] + 2, mat_t]);
// Both halves carry the same row, so a hole at h on one meets a hole at gap - h on the
// other. Mirrored parts, so the rows are counter-running: only some gaps line up at all.
function n_lap()  = floor((lap_len - 16) / hole_pitch);
function lap_h(i) = lap_start() + 8 + i * hole_pitch;
function aligned_hs() = [for (i = [0:n_lap()]) for (j = [0:n_lap()])
                         if (abs(lap_h(i) + lap_h(j) - gap) < 0.01) lap_h(i)];
function n_aligned(g) = len([for (i = [0:n_lap()]) for (j = [0:n_lap()])
                             if (abs(lap_h(i) + lap_h(j) - g) < 0.01) 1]);
function usable_gaps() = [for (g = [2*lap_h(0) : hole_pitch : 2*lap_h(n_lap())])
                          if (2*rail_len - g >= 15 && 2*rail_len - g <= lap_len
                              && n_aligned(g) >= 2) g];
// What holds the lap: one printed staple, two pins one hole pitch apart joined by a bridge
// that sits on the upper plate. Every usable gap lines up at least two neighbouring holes, so
// the one staple fits them all. It only has to take the lap's shear (the halves' distance and
// their turn against each other); gravity and the boards keep the halves down on the desk.
// A tab at one end, flush with the bridge's top and standing 1 mm proud of the plate, takes
// a string tied to the eyelet on spine_left's near edge, so it cannot get lost.
// Drawn as printed: bridge top face down on the bed, pins up.
pin_shaft  = m3_clear - 0.15;           // a close fit: two pins 10 mm apart set the turn
pin_len    = mat_t - 0.3;               // tip short of the desk
staple_w   = 6.5;
staple_t   = 2.5;                        // bridge
staple_tab = [7, 1.5];                   // string tab: reach past the bridge's end, thickness
staple_hole = 2.2;
module lap_staple() {
    hull() for (x = [0, hole_pitch]) translate([x, 0, 0]) cylinder(d = staple_w, h = staple_t);
    difference() {
        hull() {
            cylinder(d = staple_w, h = staple_tab[1]);
            translate([-staple_tab[0], 0, 0]) cylinder(d = staple_w, h = staple_tab[1]);
        }
        translate([-staple_tab[0], 0, -1]) cylinder(d = staple_hole, h = staple_tab[1] + 2);
    }
    for (x = [0, hole_pitch]) translate([x, 0, staple_t - 0.01]) {
        cylinder(d = pin_shaft, h = pin_len - 0.4 + 0.01);
        translate([0, 0, pin_len - 0.4]) cylinder(d1 = pin_shaft, d2 = pin_shaft - 0.8, h = 0.4);
    }
}
// The string's anchor: a lug on the near side of spine_left's centre bar, just outboard of
// the lap, reaching into the opening beside it, with a hole along the bar at mid-thickness, so
// the string never runs under the plate. In the plate's own plane, so the wall still folds
// flat over it.
eye_len  = 10;
eye_out  = 6;
eye_hole = 2.5;
function eye_x() = lap_start() - eye_len / 2 - 4;
function eye_y() = -spine_bar / 2;
module eye_lug() translate([eye_x(), eye_y(), 0]) difference() {
    translate([-eye_len / 2, -eye_out, 0]) cube([eye_len, eye_out + 2, mat_t]);
    translate([-eye_len / 2 - 1, -eye_out / 2, mat_t / 2]) rotate([0, 90, 0])
        cylinder(d = eye_hole, h = eye_len + 2);
}
module lap_holes() for (i = [0 : n_lap()])
    translate([lap_h(i), 0, -1]) cylinder(d = m3_clear, h = mat_t + 2);

// The plate lies on the desk, which carries it everywhere, so it needs no bending stiffness:
// only the paths that carry load stay solid. A rim, the hinge strip, each haunch's foot (tab
// and bolt), and a bar down the centreline that carries the lap bolts and ties the halves.
spine_rim = 8;
spine_bar = 16;
module spine_pockets2d() offset(r = 4) offset(delta = -4) difference() {
    offset(delta = -spine_rim) rail_plate2d();
    rotate(a_half()) translate([-50, -200]) square([plate_start() + 12 + 50, 400]);   // hinge strip
    rotate(a_half()) for (v = haunch_vs)
        translate([0, rail_y(v) - 8]) square([haunch_len + 8, haunch_t + 16]);      // haunch feet
    translate([-100, -spine_bar / 2]) square([300, spine_bar]);                       // centre bar
}
// handed: "a" is relieved on its top face, "b" on its bottom, so the two half-lap together.
module rail_half(hand = "a") { rail_body(hand); if (hand == "a") eye_lug(); }
module rail_body(hand) difference() {
    union() {
        difference() {
            linear_extrude(mat_t) rail_plate2d();
            if (hand == "a") lap_relief();
            else translate([0, 0, -mat_t]) lap_relief();
        }
        rotate([0, 0, a_half()]) for (k = plate_knuckles())
            along(k[0] + fit / 2, k[1] - fit / 2) plate_knuckle2d();
    }
    lap_holes();
    translate([0, 0, -1]) linear_extrude(mat_t + 2) spine_pockets2d();
    rotate([0, 0, a_half()]) {
        translate([hinge_axis()[0], 0, hinge_axis()[1]]) rotate([90, 0, 0])
            cylinder(d = pin_d, h = 400, center = true);           // the pin, a grip fit
        for (v = haunch_vs) let(y0 = rail_y(v)) {
            translate([plate_tab_x[0] - fit / 2, y0 - fit / 2, -1])  // tab slot, through
                cube([plate_tab_x[1] - plate_tab_x[0] + fit, haunch_t + fit, mat_t + 2]);
            translate([plate_bolt_x, y0 + haunch_t / 2, 0]) {        // M4, head sunk below
                translate([0, 0, -1]) cylinder(d = m4_clear, h = mat_t + 2);
                translate([0, 0, -1]) cylinder(d = m4_head_d + 0.6, h = plate_cb_d + 1);
            }
        }
    }
}

/* ================= the haunch ================= */
// Drawn in (x', z): x' from the wall's inboard face, z from the desk. Printed flat.
function haunch_outer(t, L, H, c) = [[c, t], [L, t], [L, t + 8], [haunch_pad[0], t + H],
                                      [0, t + H], [0, t + c]];
module haunch2d() let(t = mat_t, L = haunch_len, H = haunch_h, c = haunch_chamfer,
                      ac = m4_nut_af / cos(30) + fit, nt = m4_nut_t + fit,
                      hr = m4_head_d / 2 + 0.5) difference() {
    union() {
        polygon(haunch_outer(t, L, H, c));
        translate([-tab_d, t + wall_tab_z[0]]) square([tab_d + 0.01, wall_tab_z[1] - wall_tab_z[0]]);
        translate([plate_tab_x[0], t - tab_d]) square([plate_tab_x[1] - plate_tab_x[0], tab_d + 0.01]);
    }
    // the open middle: the triangle shrunk by one member width, minus the two joint pads
    offset(r = 2) offset(delta = -2) difference() {
        offset(delta = -haunch_bar) polygon(haunch_outer(t, L, H, c));
        translate([-1, t + H - haunch_pad[1]]) square([L + 2, haunch_pad[1] + 1]);     // top pad
        translate([plate_tab_x[0] - haunch_bar, t - 1])                                // plate pad
            square([L, foot_tip_z + 1 + haunch_bar]);
    }
    // wall joint: the head's notch in the outer edge (the bore is drilled in haunch())
    translate([wall_head_x, t + wall_bolt_z - hr]) square([L, 2 * hr]);
    // plate joint (T-slot): the nut standing in a cross-slot
    translate([plate_bolt_x - ac / 2, t + foot_tip_z - tip_in - nt]) square([ac, nt]);
}
// The bores are round holes inside the plate, not 2D slots: cut through the thickness, the
// wall bore and the head's notch together would cut the top pad off.
module haunch() let(t = mat_t) difference() {
    linear_extrude(haunch_t) haunch2d();
    translate([-1, t + wall_bolt_z, haunch_t / 2]) rotate([0, 90, 0])
        cylinder(d = m4_clear, h = wall_head_x - keep_l + 1.01);
    translate([wall_head_x - keep_l, t + wall_bolt_z, haunch_t / 2]) rotate([0, 90, 0])
        cylinder(d = keep_d, h = keep_l + 1);       // the ring that keeps the screw
    translate([plate_bolt_x, t - 1, haunch_t / 2]) rotate([-90, 0, 0])
        cylinder(d = m4_clear, h = foot_tip_z + 2);
}
// in the hinge frame, its near face at y' = rail_y(v)
// in the hinge frame, its near face at y' = rail_y(v). The key haunch is turned over so its
// clip is on the far face, away from the user (the haunch is symmetric about its mid-plane,
// so turned over it is the same part).
module haunch_at(v, key = false) translate([0, rail_y(v) + haunch_t, 0]) rotate([90, 0, 0])
    if (key) translate([0, 0, haunch_t]) mirror([0, 0, 1]) haunch_key(); else haunch();

/* ---------- the hex key's clip, on one haunch ---------- */
// Drupchen's key for the M4 screws: a 3 mm L-key, long leg ~56 mm, short leg ~19 mm (ruler
// photos). It rides on the haunch's wall-side bar, long leg vertical, bend at the top: two
// snap channels hold it, by their grip alone. Lifting it out means pulling it back through
// the lips.
key_af     = 3.0;
key_long   = 56;            // outside of the bend to the tip
key_top    = mat_t + haunch_h - haunch_pad[1] - 2;   // outside of the bend, height above desk
key_ch     = [3.7, 3.2];    // channel inside: width (a hex lying on a flat is 3.46 wide), depth
key_lip    = [2.6, 1.2];    // gap between the lips (< 3.46, so it snaps), lip height
key_wall   = 1.2;
key_x      = haunch_bar / 2;            // along the wall-side bar
key_clips  = [[key_top - 12, 8], [key_top - key_long + 8, 8]];   // [top, length] of each
function key_w() = key_ch[0] + 2 * key_wall;
module key_channel2d() let(w = key_w(), h = key_ch[1] + key_lip[1]) difference() {
    translate([-w / 2, 0]) square([w, h]);
    translate([-key_ch[0] / 2, -1]) square([key_ch[0], key_ch[1] + 1]);
    polygon([[-key_lip[0] / 2, key_ch[1] - 0.01], [key_lip[0] / 2, key_ch[1] - 0.01],   // lead-in
             [w / 2 - 0.5, h + 0.01], [-(w / 2 - 0.5), h + 0.01]]);
}
// on the haunch's +z face, in the haunch's own frame (x = x', y = height above the desk)
module key_clip() translate([key_x, 0, haunch_t]) {
    for (c = key_clips) translate([0, c[0], 0]) rotate([90, 0, 0])
        linear_extrude(c[1]) key_channel2d();
}
module haunch_key() { haunch(); key_clip(); }

/* ================= wall ================= */
// Print frame: local x = u, local y = v, extruded in z by mat_t, inner face down on the bed.
// The board goes on the +z face (keys face outward in use). Board screws are countersunk from
// the inner face; the haunch screws' nuts sit in pockets in the board face, under the board.
function box_grow(b, g) = [b[0] - [g, g], b[1] + [g, g]];
module box2d(b) translate(b[0]) square(b[1] - b[0]);
// what a haunch puts on the wall, [[u0, v0], [u1, v1]]
function haunch_box(v)    = [[mat_t, v], [mat_t + haunch_h, v + haunch_t]];
function haunch_pad_box(v) = [[mat_t + haunch_h - haunch_pad[1], v], [mat_t + haunch_h, v + haunch_t]];
function wall_slot_box(v) = [[mat_t + wall_tab_z[0] - fit / 2, v - fit / 2],
                             [mat_t + wall_tab_z[1] + fit / 2, v + haunch_t + fit / 2]];
function wall_bolt_uv(v)  = [mat_t + wall_bolt_z, v + haunch_t / 2];
wall_nut_r = (m4_nut_af + 0.2) / cos(30) / 2;      // the board covers it, so no press fit

// The wall is a frame along the load paths, not a sheet the board's shape: the board's case
// is the stiff member, and the wall only has to carry four screws to two places. The bottom
// screws go into the foot, which is the hinge. The top screws go across to the haunch pads,
// which the haunches take down to the plate. A column on each haunch's line joins pad to
// foot, and a bar joins the two top screws, so the wall is one closed piece.
function nearest_pad_v(h) = let(d = [for (v = haunch_vs) abs(v + haunch_t / 2 - h[1])])
                            haunch_vs[search(min(d), d)[0]];
module column2d(v) translate([0, v + haunch_t / 2 - wall_bar / 2])
    square([mat_t + haunch_h, wall_bar]);
module wall2d(side, screw_holes = true) difference() {
    intersection() {
        offset(r = -wall_fillet) offset(r = wall_fillet) union() {
            translate([0, foot_v[0]]) square([foot_h, foot_v[1] - foot_v[0]]);   // foot = hinge
            for (h = b_screws(side)) translate(h) circle(d = wall_boss);
            for (v = haunch_vs) { column2d(v); box2d(box_grow(haunch_pad_box(v), 7)); }
            for (h = top_screws(side)) hull() {                   // top screw -> its pad
                translate(h) circle(d = wall_boss);
                box2d(box_grow(haunch_pad_box(nearest_pad_v(h)), 7));
            }
            let(ts = top_screws(side)) for (i = [0 : len(ts) - 2]) hull() {
                translate(ts[i]) circle(d = wall_bar);              // top screw <-> top screw
                translate(ts[i + 1]) circle(d = wall_bar);
            }
        }
        translate([0, -500]) square(1000);                        // nothing below the desk
    }
    if (screw_holes) for (h = b_screws(side)) translate(h) circle(d = board_screw_d);
    feature2d(b_reset(side), reset_reach);  // reach the reset tab from inboard with a pen
    feature2d(b_square(side), 1.0);         // whatever lives in the cable opening keeps its room
    for (v = haunch_vs) box2d(wall_slot_box(v));
}
// Through-hole and countersink as ONE revolved solid, head at z = mat_t. Cut separately, the
// two meet on coincident circles and leave a seamed mesh.
module csk_hole(d, dk) let(h = (dk - d) / 2)
    translate([0, 0, -1]) rotate_extrude() polygon([[0, 0], [d / 2, 0],
        [d / 2, mat_t + 1 - h], [dk / 2 + 0.05, mat_t + 1.05], [0, mat_t + 1.05]]);
// The board screw's seat: hole, 90 deg countersink, counterbore, as ONE revolved solid.
// Drawn with z = 0 at the board face; wall_flat flips it, because there the board is on +z
// and the screw goes in from the inboard face, z = 0.
module board_seat() let(d = board_screw_d, dk = board_csk_d, s = board_seat_t,
                        zd = s - (dk - d) / 2)                  // where the cone meets the hole
    rotate_extrude() polygon([[0, -1], [d / 2, -1], [d / 2, zd], [dk / 2, s],
        [dk / 2 + 0.2, s], [dk / 2 + 0.2, mat_t + 1], [0, mat_t + 1]]);
module wall_flat(side) difference() {
    linear_extrude(mat_t) wall2d(side, screw_holes = false);   // the countersinks cut them
    for (h = b_screws(side)) translate([h[0], h[1], mat_t]) mirror([0, 0, 1])
        board_seat();                                             // heads on the inboard face
    for (v = haunch_vs) translate(wall_bolt_uv(v)) {                // M4 nut, under the board
        translate([0, 0, -1]) cylinder(d = m4_clear, h = mat_t + 2);
        translate([0, 0, mat_t - wall_nut_d]) rotate(30) cylinder(r = wall_nut_r, h = wall_nut_d + 1, $fn = 6);
    }
}
// Stand it up: local x -> z, local z -> -x', so the wall occupies x' in [-mat_t, 0] and the
// board sits outboard of it. u = 0 is the desk.
module in_use() translate([0, -v_c, 0]) rotate([0, -90, 0]) children();
module from_use() rotate([0, 90, 0]) translate([0, v_c, 0]) children();
// The wall with its half of the hinge, in the hinge frame, standing.
module wall_hinged(side) difference() {
    union() {
        in_use() wall_flat(side);
        for (k = wall_knuckles()) along(k[0] + fit / 2, k[1] - fit / 2) wall_knuckle2d();
    }
    translate([hinge_axis()[0], 0, hinge_axis()[1]]) rotate([90, 0, 0])
        cylinder(d = pin_d + pin_fit, h = 600, center = true);    // turns on the pin
}
// Export frame: flat, BOARD FACE DOWN, so the lobes stand up off the bed with the pin hole
// horizontal. A rotation, not a mirror: the hand is kept.
module wall(side) translate([0, 0, mat_t]) rotate([180, 0, 0]) from_use() wall_hinged(side);

/* ================= clash checks ================= */
function overlaps(a, b) = a[0][0] < b[1][0] && b[0][0] < a[1][0]
                       && a[0][1] < b[1][1] && b[0][1] < a[1][1];
function pt_box(p, r)  = [p - [r, r], p + [r, r]];
function f_box(f, g)   = [f[0] - f[1] / 2 - [g, g], f[0] + f[1] / 2 + [g, g]];
// Everything a haunch puts on the wall: its body, the slot, the nut pocket under the board.
function haunch_boxes(v) = [haunch_box(v), wall_slot_box(v), pt_box(wall_bolt_uv(v), wall_nut_r)];
function clashes(side) = [
    for (v = haunch_vs) for (b = haunch_boxes(v)) each concat(
        [for (h = b_screws(side)) if (overlaps(b, pt_box(h, wall_boss / 2))) str("screw ", h)],
        [for (f = [b_reset(side), b_square(side)]) if (overlaps(b, f_box(f, reset_reach + 2))) str("opening ", f[0])])];
// A board screw low enough to meet the hinge zone must sit in one of the plate's knuckles:
// in a wall knuckle the lobe stands in front of its head (and the plate's knuckle covers it
// once fitted, which is why the board goes on first).
function low_screws(side) = [for (h = b_screws(side)) if (h[0] - board_csk_d / 2 - 0.2 < mat_t + 2) h];
function in_plate_knuckle(h) = len([for (k = plate_knuckles())
    if (rail_y(h[1]) - board_csk_d / 2 - 0.2 >= k[0] + fit && rail_y(h[1]) + board_csk_d / 2 + 0.2 <= k[1] - fit) 1]) > 0;
// the haunch's plate leg must stop before the other half's plate can arrive over the lap
function haunch_tip_x(v) = max([for (y = [rail_y(v), rail_y(v) + haunch_t]) to_rail([haunch_len, y])[0]]);
function haunch_lap_margin() = lap_start() - 1 - max([for (v = haunch_vs) haunch_tip_x(v)]);

assert(board_seat_t - (board_csk_d - board_screw_d) / 2 > -1, "board seat's cone runs out");
assert(mat_t >= 4, "mat_t must be >= 4 mm; thinner plates flex under a keypress at this height");
assert(let(u = usable_gaps()) gap == u[floor(len(u) / 2)] && len(u) % 2 == 1,
       str("gap ", gap, " is not the middle of the usable range ", usable_gaps()));
assert(overlap() >= 15 && overlap() <= lap_len,
       str("overlap is ", overlap(), " mm; must be 15..", lap_len, ". Change gap or rail_len."));
assert(len(aligned_hs()) >= 2,
       str("gap ", gap, " mm does not line the two bolt rows up. Usable gaps: ", usable_gaps()));
assert(n_knuckles % 2 == 1, "odd knuckle count: the plate must own both ends");
assert((mat_t - pin_d - pin_fit) / 2 >= 1.2, "too little knuckle round the pin");
assert(haunch_lap_margin() >= 0,
       str("a haunch's plate leg reaches ", -haunch_lap_margin(), " mm into the lap; ",
           "shorten haunch_len or move haunch_vs toward the user"));
assert(eye_x() + eye_len / 2 + 3 <= usable_gaps()[0] - rail_len,
       "string lug under the other half's plate at the narrowest gap");
assert(eye_x() + eye_len / 2 <= lap_start(), "string lug in the lap");
assert(key_w() <= haunch_bar, "key clip wider than the haunch's bar");
assert(key_clips[1][0] - key_clips[1][1] > key_top - key_long - 1.5, "lower clip past the key's tip");
assert(key_lip[0] < key_af / cos(30) && key_ch[0] > key_af / cos(30), "key clip won't snap or won't fit");
assert((haunch_t - m4_clear) / 2 >= 1.5, "too little haunch either side of an M4 bore");
assert(m4_nut_af + fit <= haunch_t, "the foot's nut would stand proud of the haunch's faces");
assert(mat_t - wall_nut_d >= 2.4, "too little wall in front of the wall's nut");
assert(mat_t - plate_cb_d >= 1.6, "too little plate under the foot screw's head");
assert(wall_head_x >= 8, "too little haunch between the wall and the screw head");
assert(wall_tab_z[0] > 0 && wall_tab_z[1] <= wall_bolt_z - m4_head_d / 2 - 0.5 - 1
       && wall_bolt_z + m4_head_d / 2 + 0.5 + 3 <= haunch_h,
       "wall tab or head notch falls outside the haunch's top pad");
assert(plate_bolt_x + (m4_nut_af / cos(30) + fit) / 2 + 3
       <= haunch_len - max(0, foot_tip_z - 8) * (haunch_len - haunch_pad[0]) / (haunch_h - 8),
       "foot nut too close to the haunch's outer edge");
for (s = ["left", "right"]) {
    assert(len(clashes(s)) == 0,
           str(s, " wall: a haunch covers ", clashes(s), ". Move haunch_vs."));
    for (h = low_screws(s)) assert(in_plate_knuckle(h),
           str(s, " wall: board screw at ", h, " falls in a wall knuckle; change n_knuckles"));
}

/* ================= assembly ================= */
// Approximate case volume behind the plate, so the picture reads. Not a measurement.
case_depth = 22;
phi = 90;               // hinge angle shown: 90 standing (haunches in), 0 folded
module board_ghost(side) in_use() translate([0, 0, mat_t]) {
    color([0.22, 0.24, 0.27]) linear_extrude(plate_t(side)) board2d(side);
    color([0.30, 0.32, 0.36], 0.35) translate([0, 0, plate_t(side)])
        linear_extrude(case_depth) offset(delta = -1) board2d(side);
}
// One half in the left-half convention, rail frame, the desk at z = 0.
module half(side, hand) translate([-gap / 2, 0, 0]) {
    color([0.95, 0.47, 0.32]) rail_half(hand);
    rotate([0, 0, a_half()]) {
        wall_pose(phi) {
            color([0.80, 0.84, 0.90]) wall_hinged(side);
            board_ghost(side);
        }
        if (phi == 90) color([0.98, 0.75, 0.30]) for (v = haunch_vs)
            haunch_at(v, key = side == "left" && v == haunch_vs[1]);
        color([0.5, 0.5, 0.5]) translate([hinge_axis()[0], 0, hinge_axis()[1]])
            rotate([90, 0, 0]) cylinder(d = pin_d, h = foot_v[1] - foot_v[0], center = true);
    }
}
module half_left()  half("left", "a");
module half_right() mirror([1, 0, 0]) half("right", "b");

/* ================= output ================= */
// Right-hand parts are exported mirrored, because in the assembly the right half is the
// mirror image of a left-convention half. mirror([0,1,0]) keeps each part's print face down.
if (vpart == "wall_left")   wall("left");
if (vpart == "wall_right")  mirror([0, 1, 0]) wall("right");
if (vpart == "spine_left")  rail_half("a");
if (vpart == "spine_right") mirror([0, 1, 0]) rail_half("b");
if (vpart == "haunch")      haunch();                 // print three
if (vpart == "haunch_key")  haunch_key();             // print one: the haunch with the key clip
if (vpart == "lap_staple")  lap_staple();             // print one
if (vpart == "half")        half_left();
module staple_in_place() translate([-gap / 2 + aligned_hs()[0], 0, mat_t + staple_t])
    mirror([0, 0, 1]) lap_staple();
if (vpart == "assembly")  { half_left(); half_right(); color([0.3, 0.6, 0.9]) staple_in_place(); }
// 2D profiles, for cutting the cardboard mock-up at 1:1 (export as SVG). The hinge is 3D;
// in cardboard, tape the wall to the plate along the axis line.
if (vpart == "wall_left_2d")   wall2d("left");
if (vpart == "wall_right_2d")  mirror([0, 1]) wall2d("right");
if (vpart == "haunch_2d")      haunch2d();
