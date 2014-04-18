/*
 *  VESA mount for RaspberryPi
 *  (c) 2014 Torsten Paul <Torsten.Paul@gmx.de>
 *  License: CC-BY-SA 4.0
 */

$fn = 60;

/*
 * The number of vesa mount holes to generate, default is to only
 * generate the 75mm holes.
 */
count = 1;

/*
 * default values are for the very nice Raspberry Pi case by HansH
 * http://www.thingiverse.com/thing:16104
 */
case_width = 61;
case_length = 90;
case_height = 24;

mount_height = 3;
mount_diameter = 12;
mount_pin_height = mount_height + 3;

/* M4 */
screw_head_diameter = 8;
screw_shaft_diameter = 4.3;
nut_diameter = 8;
nut_height = 3.5;

/*
 * Define which module to generate:
 *
 * mount() will generate the VESA mount base
 * clip() will generate a single clip
 * plate() will generate the mount and 4 clips
 *
 * Just put a single ! for the module that should be rendered.
 */
mount();
clip();
!plate();

/*
 * end of config section
 */

vesa_size = [case_width, 75, 100, 200];

module case() {
	%translate([0, 0, case_height / 2 + mount_height]) {
		cube([case_length, case_width, case_height], center = true);
	}
}

module pin(h) {
	difference() {
		cylinder(d = mount_diameter, h = h);
		cylinder(d = screw_head_diameter, h = 5 * h, center = true);
	}
}

module pins(l, x, h) {
	translate([x * l / 2, l / 2, 0]) pin(h);
	translate([x * -l / 2, -l / 2, 0]) pin(h);
}

module holes(l, x) {
	translate([x * l / 2, l / 2, 0]) cylinder(d = screw_shaft_diameter, h = 100, center = true);
	translate([x * -l / 2, -l / 2, 0]) cylinder(d = screw_shaft_diameter, h = 100, center = true);
}

module base(l, x, h1, h2) {
		hull() {
			pins(l, x, h1);
		}
		pins(l, x, h2);
}

module pilar() {
	h = mount_height + case_height;
	difference() {
		union() {
			cylinder(d = mount_diameter, h = h);
			translate([0, 0, h]) {
				hull() {
					translate([0, mount_diameter / 2 - 1, 0]) sphere(r = 1);
					translate([0, -mount_diameter / 2 + 1, 0]) sphere(r = 1);
				}
			}
		}
		hull() {
			translate([0, 0, h - nut_height - 3]) cylinder(d = nut_diameter, $fn = 6, h = nut_height);
			translate([-mount_diameter, 0, h - nut_height - 3 - 2]) cylinder(d = 1.1 * nut_diameter, $fn = 6, h = nut_height + 2);
		}
		translate([0, 0, h - nut_height - 3]) cylinder(d = screw_shaft_diameter, h = h);
	}
}

module mount() {
	case();
	difference() {
		union() {
			for (idx = [1 : 1 : count]) {
				assign(l = vesa_size[idx]) {
					base(l, 1, mount_height, mount_pin_height);
					base(l, -1, mount_height, mount_pin_height);
				}
			}
			assign(l = case_width / 2 + (mount_diameter / 2)) {
				hull() {
					translate([l, -l, 0]) pin(mount_height);
					translate([-l, -l, 0]) pin(mount_height);
				}
				hull() {
					translate([l, l, 0]) pin(mount_height);
					translate([-l, l, 0]) pin(mount_height);
				}
				translate([case_width / 3, l, 0]) pilar();
				translate([-case_width / 3, l, 0]) pilar();
				translate([case_width / 3, -l, 0]) pilar();
				translate([-case_width / 3, -l, 0]) pilar();
			}
		}
		for (idx = [1 : 1 : count]) {
			assign(l = vesa_size[idx]) {
				holes(l, 1);
				holes(l, -1);
			}
		}
	}
}

module clip() {
	difference() {
		union() {
			hull() {
				cylinder(d = mount_diameter, h = mount_height);
				translate([0, mount_diameter / 2, 0]) cylinder(d = mount_diameter, h = mount_height);
			}
			translate([0, 0, mount_height]) pin(mount_height);
		}

		cylinder(d = screw_shaft_diameter, h = 5 * mount_height, center = true);
		hull() {
			translate([0, mount_diameter / 2 - 1, 0]) sphere(r = 1.2);
			translate([0, -mount_diameter / 2 -10, 0]) sphere(r = 1.2);
		}
	}
}

module plate() {
	mount();
	for (y = [-3, -1, 1, 3]) {
		translate([-75, y * mount_diameter, 0]) rotate([0, 0, 90]) clip();
	}
}