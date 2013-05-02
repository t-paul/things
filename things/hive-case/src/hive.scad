$fn = 80;


wall = 2;
nut_diameter = 6.4;

mil_to_mm = 0.0254;

depth = 3900 * mil_to_mm;
width = 6300 * mil_to_mm;

h1_x = 200 * mil_to_mm;
h1_y = 200 * mil_to_mm;
h2_x = 6100 * mil_to_mm;
h2_y = 200 * mil_to_mm;
h3_x = 200 * mil_to_mm;
h3_y = 3300 * mil_to_mm;
h4_x = 6100 * mil_to_mm;
h4_y = 3300 * mil_to_mm;
h5_x = 2900 * mil_to_mm;
h5_y = 2900 * mil_to_mm;
h6_x = 2900 * mil_to_mm;
h6_y = 400 * mil_to_mm;

module hole(x, y) {
	h = 6 + wall;
	translate([x, y, 0]) {
		difference() {
			cylinder(r = 5, h = h);
			translate([0, 0, wall]) cylinder(r = 2, h = h + 1);
			translate([0, 0, h - 3]) cylinder(r = nut_diameter / 2, h = wall + 6 + 2, $fn = 6);
		}
	}
}

module base() {
	union() {
		difference() {
			cube([width, depth, wall]);
			for (a = [10 : 8 : width - 10]) {
				translate([a, 10, -1]) cube([4, depth - 20, wall + 2]);
			}
		}
		hole(x = h1_x, y = h1_y);
		hole(x = h2_x, y = h2_y);
		hole(x = h3_x, y = h3_y);
		hole(x = h4_x, y = h4_y);
		hole(x = h5_x, y = h5_y);
		hole(x = h6_x, y = h6_y);
	}
}

module logo_circle() {
	difference() {
		cylinder(r = 10, h = 1);
		translate([0, 0, -1]) cylinder(r = 10 - 0.4, h = 3);
	}
}

module logo(h) {
	union() {
		difference() {
			union() {
				for (a = [0 : 120 : 360]) {
					translate([15 * sin(a), 15 * cos(a), 0]) {
						cylinder(r = 10, h = h);
					}
					rotate([0, 0, a + 60]) translate([0, 7, h / 2]) cube([20, 3, h], center = true);
				}
			}
			for (a = [0 : 120 : 360]) {
				translate([15 * sin(a), 15 * cos(a), -1]) {
					cylinder(r = 7, h = h + 2);
				}
			}
		}
	}
}

module c(r, w, h) {
	difference() {
		cylinder(r = r, h = h);
		translate([0, 0, -1]) {
			cylinder(r = r - w, h = h + 2);
			translate([0, -2 * r, 0]) cube([2 * r, 4 * r, h + 2]);
			translate([- 2 * r, 0, 0]) cube([4 * r, 2 * r, h + 2]);
		}
	}
}

module hive(h) {
	w = 10;
	// H
	cube([w, 4 * w, h]);
	translate([3 * w, 0, 0]) cube([w, 4 * w, h]);
	translate([2 * w, 2 * w, 0]) cylinder(r = w / 2, h = h);
	// i
	translate([4.5 * w, 0, 0]) cube([w, 2 * w, h]);
	translate([5 * w, 3 * w, 0]) cylinder(r = w / 2, h = h);
	// v
	translate([6 * w, 1.5 * w, 0]) cube([w, 2 * w, h]);
	translate([7.5 * w, 0, 0]) cube([2 * w, w, h]);
	translate([7.5 * w, 1.5 * w, 0]) c(r = 1.5 * w, w = w, h = h, m = 1);
	translate([8.5 * w, 0, 0]) cube([w, 3.5 * w, h]);

	translate([11.5 * w, 1.5 * w, 0]) c(r = 1.5 * w, w = w, h = h, m = 0);
	translate([11.5 * w, 0, 0]) cube([1.5 * w, w, h]);
	translate([11.5 * w, 2 * w, 0]) rotate([0, 0, -90]) c(r = 1.5 * w, w = w, h = h, m = 0);
	translate([11.5 * w, 2.5 * w, 0]) cube([1.5 * w, w, h]);
	translate([10 * w, 1.5 * w, 0]) cube([w, 0.5 * w, h]);
	translate([11.75 * w, 1.75 * w, 0]) cylinder(r = w / 2, h = h);
}

module hive_logo(h) {
	scale([1, 0.8, 1]) {
		cube([200, 48, wall]);
		translate([27, 20, 0]) logo(h = h);
		translate([65, 4, 0]) hive(h = h);
	}
}

module spacer() {
	difference() {
		cylinder(r1 = 5, r2 = 2 + 0.4, h = 4);
		translate([0, 0, -1]) cylinder(r = 2, h = 6);
	}
}

module plate() {
	base();
	translate([30, 20, 0]) scale([0.5, 0.5, 1]) hive_logo(h = 5);
}

spacer();
!plate();

