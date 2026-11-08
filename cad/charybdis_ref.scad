// charybdis_ref.scad - Charybdis 4x6 bottom-plate geometry, measured not guessed.
//
// Sliced from Bastardkb/charybdis files/4x6/MK1/plate_shield2.x.stl at mid-thickness.
// Drupchen identified that plate as matching his physical one, bar the on/off and reset
// openings. The hole pattern is confirmed twice over: the same folder's
// plate_shield2.x.dxf carries eight CIRCLE entities, and all fifteen pairwise distances
// between the six screw holes agree with the mesh to within 0.01 mm.
//
// Screw holes are 4.0 mm through (DXF), opening out to a countersink on one face - at 8%
// of the plate's depth the slice reads ~10 mm. Use CB_SCREW_D for clearance in a new
// part; do not copy the countersink, which belongs to the case side.
//
// The plate is 2.00 mm thick, which matches stock_plate_t in microdox_ribs.scad.
//
// The pattern is invariant across revisions AND across hands. Checked against
// files/4x6/MK2/charybdis_v4_6_plate_L.stl and charybdis_v4_247_plate_R.stl: all three
// plates give the same fifteen pairwise distances between the six mounting holes, to
// within 0.02 mm. What does change between revisions is everything else - MK2's outline
// is 155.9 x 154.2, its mounting holes are 6.0 mm not 4.0, it has one button opening
// rather than two, and it adds six 10.15 mm pockets for the magnetic tenting system.
// So treat the outline here as indicative and the hole pattern as reliable.
//
// Origin at the outline's min corner. Units mm.

CB_PLATE_SIZE = [153.643, 149.644];
CB_PLATE_T    = 2.00;
CB_SCREW_D    = 4.00;    // through-hole in the stock plate

CB_OUTLINE = [[135.232,148.054], [132.817,149.258], [130.218,149.644], [53.047,149.644], [51.368,149.500], [49.487,148.937], [48.112,148.189], [46.849,147.156], [45.241,145.089], [44.037,142.474], [43.325,139.250], [43.171,134.088], [42.642,130.571], [41.263,126.407], [39.146,122.678], [36.389,119.557], [33.807,117.594], [30.973,116.171], [26.742,114.935], [23.843,113.782], [20.195,111.653], [17.672,109.641], [15.369,107.303], [12.695,103.735], [10.533,99.730], [9.280,96.499], [8.132,91.970], [7.619,87.549], [8.116,73.430], [7.266,64.377], [6.811,49.854], [6.426,45.764], [5.645,41.763], [4.712,38.839], [0.730,30.763], [0.000,28.061], [0.174,25.702], [0.877,23.635], [2.408,21.036], [4.661,18.360], [8.120,15.420], [27.370,2.505], [31.346,0.551], [34.728,0.000], [37.654,0.646], [38.902,1.336], [40.579,2.748], [42.617,5.334], [46.240,11.341], [47.884,13.254], [49.760,14.950], [53.305,17.203], [57.249,18.669], [60.570,19.226], [63.100,19.272], [65.612,19.000], [70.497,17.987], [74.457,17.704], [106.485,17.725], [113.781,18.114], [118.224,18.758], [144.860,23.897], [148.451,25.366], [151.028,27.374], [152.929,30.176], [153.643,33.194], [153.559,104.040], [152.662,107.023], [151.743,108.512], [150.418,109.950], [148.020,111.656], [141.860,114.822], [140.545,115.945], [140.042,116.780], [139.770,118.439], [139.647,140.137], [139.145,142.356], [138.082,144.780], [136.885,146.515]];

CB_SCREWS = [[105.004,26.121], [55.658,27.704], [12.658,50.704], [147.238,84.424], [50.889,141.232], [132.658,141.704]];

// on/off and reset openings, 5.0 mm
CB_BUTTONS = [[131.358,38.613], [127.858,52.113]];

module cb_outline()  polygon(CB_OUTLINE);
module cb_screws_2d(d = CB_SCREW_D) for (h = CB_SCREWS) translate(h) circle(d = d, $fn = 32);
module cb_buttons_2d(d = 5.0)       for (h = CB_BUTTONS) translate(h) circle(d = d, $fn = 32);
