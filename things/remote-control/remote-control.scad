$fn = 40;

s = 2.54;

width = 19*s;
length = 63*s;

module key(x, y) {
	translate([-3 + x * s + s/2, -3 + y * s + s/2, 1]) {
		color("white") cube([6, 6, 2]);
		color("black") translate([3, 3, 0]) cylinder(r = 1.75, h = 3);
	}
}

module key_hole(x, y, r) {
	translate([x * s + s/2, y * s + s/2, 1]) {
		cylinder(r = r, h = 100);
	}
}

module key_base(x, y, r) {
	translate([x * s + s/2, y * s + s/2, 12]) {
		difference() {
			cylinder(r1 = r + 1, r2 = r + 4, h = 10);
			cylinder(r = r, h = 50, center = true);
		}		
	}
}

module knob(r) {
	s = 20;
	difference() {
		union() {
			cylinder(r = r + 1, h = 1);
			difference() {
				translate([0, 0, -s + 11]) intersection() {
					sphere(r = s, $fn = 200);
					cylinder(r = r, h = 200);
				}
				translate([0, 0, -50]) cube([100, 100, 100], center = true);
			}
		}
		cylinder(r = 3.6/2, h = 4, center = true);
	}

}

module battery() {
	color([0.5, 0, 0]) cube([46, 27, 17]);
	color([0.2, 0, 0]) translate([46, 0, 0]) cube([6, 27, 17]);
}

module plate() {
	color([0.6, 0.5, 0]) difference() {
		cube([length, width, 1]);
		for (x = [0 : s : 160]) {
			for (y = [0 : s : 50]) {
				//translate([x + s/2, y + s/2, -2]) cylinder(r = 0.5, h = 4, $fn=4);
			}
		}
	}
}

module board() {
	plate();
	translate([106, 2, -4]) battery();

	key(3, 4);
	key(3, 14);

	key(14, 9);
	key(14, 4);
	key(14, 14);
	key( 9, 9);
	key(19, 9);

	key(26, 4);
	key(32, 4);
	key(26, 14);
	key(32, 14);

	key(39, 3);
	key(39, 7);
	key(39, 11);
	key(39, 15);
}

module spheres(x, y, z, r) {
	translate([0, 0, z]) sphere(r = r);
	translate([x, 0, z]) sphere(r = r);
	translate([0, y, z]) sphere(r = r);
	translate([x, y, z]) sphere(r = r);
}

module case_bottom() {
	r = 4;
	difference() {
		color([.5, .5, 1]) hull() {
			spheres(length, width, 0, r);
			spheres(length, width, 50, r);
		}
		translate([-200, -100, 12]) cube([400, 200, 100]);
		translate([0, 0, 4]) cube([length, width, 10]);
		translate([2, 2, 2]) cube([length - 4, width - 4, 10]);
		translate([0, width / 2 - 10, 8]) rotate([0, 90, 0]) cylinder(r = 2.7, h = 20, center = true);
		translate([0, width / 2 + 10, 8]) rotate([0, 90, 0]) cylinder(r = 2.7, h = 20, center = true);
		for (yoff = [0, +18, -18]) {
			translate([0.5, width / 2 + yoff, 7]) cube([5, 5, 3], center = true);
			translate([-2, width / 2 + yoff, 7+1.5]) rotate([0, -45, 0]) translate([2.5, 0, -1.5]) cube([5, 5, 3], center = true);
		}
	}
}

module case_top() {
	r = 4;
	h = 20;
	key_base(3, 4, 5);
	key_base(3, 14, 5);
	key_base(14, 9, 5);
	key_base(26, 4, 5);
	key_base(32, 4, 5);
	key_base(26, 14, 5);
	key_base(32, 14, 5);
	key_base(39, 3, 3);
	key_base(39, 7, 3);
	key_base(39, 11, 3);
	key_base(39, 15, 3);

	difference() {
		union() {
			for (yoff = [0, +18, -18]) {
				translate([0.5, width / 2 + yoff, 8]) cube([5, 4, 4], center = true);
				translate([1.5, width / 2 + yoff, 16]) cube([3, 4, 12], center = true);
			}
		}
		translate([0, 0, 10]) rotate([0, 45, 0]) translate([-10, 0, -10]) cube([10, 100, 10]);
	}
	difference() {
		union() {
			color([0, 0, 0.4]) hull() {
				spheres(length, width, 0, r);
				spheres(length, width, h, r);
			}
		}
		translate([-200, -100, -100 + 12]) cube([400, 200, 100]);
		cube([length, width, h+r-2]);

		key_hole(3, 4, 5);
		key_hole(3, 14, 5);

		key_hole(14, 9, 5);
		union() {
			key_hole(14, 4, 1);
			key_hole(14, 14, 1);
			key_hole( 9, 9, 1);
			key_hole(19, 9, 1);
		}

		translate([14 * s + s/2, 9 * s + s/2, 1]) {
			difference() {
				cylinder(r = 18, h = 100, center = true);
				cylinder(r = 9, h = 200, center = true);
				rotate([0, 0, -45]) cube([100, 5, 100], center = true);
				rotate([0, 0, 45]) cube([100, 5, 100], center = true);
			}
		}

		key_hole(26, 4, 5);
		key_hole(32, 4, 5);
		key_hole(26, 14, 5);
		key_hole(32, 14, 5);

		key_hole(39, 3, 3);
		key_hole(39, 7, 3);
		key_hole(39, 11, 3);
		key_hole(39, 15, 3);
	}
}

*knob(r = 5);

difference() {
	union() {
		rotate([180, 0, 0]) translate([0, 20, -20]) case_top();
		case_bottom();
		*translate([0, 0, 4]) board();
	}
	*translate([20, -100, -100]) cube([200, 200, 200]);
}