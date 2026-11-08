// scylla_ref.scad - Scylla MK1 bottom-plate geometry, measured not guessed.
//
// Sliced from Bastardkb/scylla files/MK1/plate_shield2.x.stl at mid-thickness, holes
// cross-checked against that folder's plate_shield2.x.dxf.
//
// This is the LEFT half of Drupchen's build. His tracing of it matches this pattern to
// 0.58 mm rms at a scale factor of 0.999 - and matches the Charybdis pattern no better
// than 6.30 mm rms. The right-hand tracing is the reverse: Charybdis to 0.51 mm, Scylla
// to 5.89 mm. So the two halves really do carry different plates, which is exactly what
// the wrist-pad mod's own filenames say: left-case-bottom-scylla, right-case-bottom-
// charybdis.
//
// Origin at the outline's min corner. Units mm.

SC_PLATE_SIZE = [155.242, 149.474];
SC_PLATE_T    = 2.00;
SC_SCREW_D    = 4.00;

SC_OUTLINE = [[38.189,85.608], [46.144,84.237], [48.795,83.079], [51.175,81.434], [53.194,79.362], [54.779,76.941], [55.869,74.262], [56.424,71.422], [56.494,61.042], [56.092,58.868], [55.355,57.608], [54.186,56.337], [48.487,51.652], [46.476,49.359], [45.105,46.768], [44.471,44.090], [44.388,5.771], [44.461,4.730], [44.999,3.015], [46.352,1.350], [48.728,0.252], [51.628,0.000], [131.843,0.084], [133.872,0.305], [135.732,0.949], [136.846,1.598], [138.666,3.282], [139.985,5.441], [140.712,8.037], [140.808,35.851], [141.128,37.890], [142.053,39.517], [144.055,41.161], [150.754,44.115], [153.090,45.531], [154.677,47.459], [155.206,49.356], [155.242,119.314], [154.975,121.935], [154.298,123.934], [153.690,125.012], [152.116,126.812], [151.054,127.610], [148.767,128.752], [144.219,129.869], [106.362,133.603], [94.896,134.118], [62.640,134.084], [58.211,133.684], [55.310,133.867], [51.099,134.964], [48.485,136.212], [46.088,137.847], [43.029,140.930], [39.525,146.519], [38.759,147.388], [36.974,148.673], [35.834,149.127], [33.501,149.474], [30.793,149.138], [29.281,148.633], [26.444,146.958], [1.777,127.348], [0.757,125.931], [0.117,124.151], [0.000,122.064], [0.186,121.002], [0.822,119.379], [12.884,97.131], [14.762,94.787], [17.592,92.912], [20.520,91.696]];

SC_SCREWS = [[51.239,7.138], [132.643,8.086], [148.643,64.086], [33.186,94.276], [64.253,126.768], [104.643,127.086]];

// on/off and reset openings, 5.0 mm
SC_BUTTONS = [[129.442,99.348], [132.942,112.848]];

// AS-BUILT features, from the tracing of the left plate, mapped through the six holes
// (fit: 0.57 mm rms, 0.79 mm max). Same story as the right: the stock 5.0 mm openings at
// (129.44, 99.35) and (132.94, 112.85) are gone, replaced by a square cable opening and
// a reset plunger: a flexure tab whose dome protrudes on the INSIDE, toward the PCB. The
// outer face is flat, so no relief pocket - just a hole through the stand to reach it.
SC_RESET        = [119.6, 111.2];
SC_RESET_BBOX   = [ 6.4, 13.1];
SC_SQUARE       = [140.6,  99.4];
SC_SQUARE_BBOX  = [13.9, 12.9];

module sc_outline()  polygon(SC_OUTLINE);
module sc_screws_2d(d = SC_SCREW_D) for (h = SC_SCREWS) translate(h) circle(d = d, $fn = 32);
module sc_buttons_2d(d = 5.0)       for (h = SC_BUTTONS) translate(h) circle(d = d, $fn = 32);
