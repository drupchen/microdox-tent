// charybdis_template.scad - 1:1 paper template of the bottom-plate bolt pattern.
//
// Export to SVG and print at 100% (no "fit to page"), then hold it against the OUTSIDE
// of the keyboard's bottom plate. The screws are visible from outside, so this checks the
// pattern with nothing taken apart.
//
// Check the 100 mm scale bar with a ruler before trusting the result: printers scale.
//
//   openscad --export-format svg -o charybdis_template.svg charybdis_template.scad

include <charybdis_ref.scad>

ring_t  = 0.4;      // line weight
cross_r = 7;        // crosshair arm length at each hole centre

module ring(d) difference() { circle(d = d + ring_t, $fn = 64); circle(d = d - ring_t, $fn = 64); }
module cross(r) { square([2*r, ring_t], center = true); square([ring_t, 2*r], center = true); }

difference() { offset(ring_t/2) cb_outline(); offset(-ring_t/2) cb_outline(); }   // outline
for (h = CB_SCREWS) translate(h) { ring(CB_SCREW_D); cross(cross_r); }            // the six
for (h = CB_BUTTONS) translate(h) ring(5.0);                                      // buttons

// 100 mm scale bar with 10 mm ticks, below the plate
translate([10, -18]) {
    square([100, ring_t]);
    for (i = [0 : 10]) translate([i * 10, 0]) square([ring_t, i % 5 == 0 ? 6 : 3.5]);
    translate([0, 9]) text("100 mm - measure this first", size = 5);
}
translate([10, -30]) text("Charybdis 4x6 bottom plate, 1:1. Holes 1-6 = mounting.", size = 5);
