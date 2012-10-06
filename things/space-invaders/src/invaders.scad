/*
 *  Parametric 8bit Space Invader Ornaments
 *  (c) 2012 Torsten Paul <Torsten.Paul@gmx.de>
 *  License: CC-BY-SA 3.0
 *
 *  Derived from "8bit Space Invader Ornaments" by 4volt
 *  http://www.thingiverse.com/thing:5080
 */

$fn = 40;

s = 1;		// scale factor against the DXF file
h = 4;		// height of the invaders
r = 2.1;	// radius of the magnet hole
d = 2.2;	// depth of the magnet hole

module invader(layer, x, y) {
	difference() {
		scale([s, s, 1]) {
			linear_extrude(file = "invaders.dxf",
					layer = layer,
					height = h,
					convexity = 10);
		}
		translate([x * s, y * s, -1]) {
			cylinder(r = r, h = d + 1);
		}
	}
}

// just place an ! character before the invader you
// want to generate

!invader("invader1", 19.5, 11);
invader("invader2", 16.5, 13);
invader("invader3", 18, 14);
invader("invader4", 12, 12);
invader("invader5", 24, 12);
