$fn = 50;
x = 0.1;
e = 0.001;

module lock_shape(y1, y2, z1, z2) {
	linear_extrude(height = e)
		polygon([[0, 0], [0, y1 + y2], [z1, y1 + y2], [z2, y1], [z2, 0]]);
}

module lock(length, width, height, angle) {
	y1 = x;
	y2 = width;
	z1 = height - width;
	z2 = height;
	zo = length * tan(angle);

	translate([length, y1, 0]) rotate([0, 90, 180]) hull() {
		lock_shape(y1, y2, z1, z2);
		translate([0, 0, length])
			lock_shape(y1, y2, z1 + zo, z2 + zo);
	}
}

module lock_post(length, width, height, angle, wall = 2, stopper_length = 2) {
	w = width + wall;
	difference() {
		union() {
			translate([0, 0, x]) rotate([0, 180, 180]) cube([length + stopper_length, w, height + x]);
			translate([0, 0, x]) rotate([0, 180, 180]) cube([length + stopper_length, w + wall, wall + x]);
			translate([0, -w / 2, -height]) rotate([0, 90, 0]) cylinder(r = w / 2, h = length + stopper_length);
		}
		translate([-x, 0, 2*x]) lock(length = length + 2 * x, width = width, height = height + 2 * x, angle = angle);
		translate([-1, -w - wall, -wall]) rotate([0, 90, 0]) cylinder(r = wall, h = length + stopper_length + 2);
	}
}

translate([0, 2, 0]) lock(length = 5, width = 2, height = 5, angle = 3);
!lock_post(length = 5, width = 2, height = 5, angle = 3, wall = 2);
