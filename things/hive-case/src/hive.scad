/******************************************************************************
 *  Case for Hive Retro Style Computer
 *  (c) 2013 Torsten Paul <Torsten.Paul@gmx.de>
 *  License: CC-BY-SA 3.0
 *
 *  Settings according to the board layout of Hive R14-V (hive-1-ver3-r14-v.brd).
 */

// WriteScad By Harlan Martin, harlan@sutlog.com, January 2012
use <write.scad>

$fn = 80;

/******************************************************************************
 *  Definitions
 */
wall = 2;
nut_diameter = 6.4;
nut_height = 2.8;
spacer_extra_height = 4;
spacer_cone_height = 3;

screw_diameter = 3.6;

serial_number = "363";
font_name = "orbitron.dxf";

/******************************************************************************
 *  Calculations
 */

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

audio_x = 700 * mil_to_mm;
video_x = 1250 * mil_to_mm;
keyboard_ps2_x = 1825 * mil_to_mm;
mouse_ps2_x = 2500 * mil_to_mm;
vga_x = 3425 * mil_to_mm;
network_x = 4425 * mil_to_mm;
host_ps2_x = 5125 * mil_to_mm;
power_x = 5700 * mil_to_mm;
reset_x = 6075 * mil_to_mm;

sd_y = 875 * mil_to_mm;
usb_host_y = 1675 * mil_to_mm;

spacer_total_height = nut_height + spacer_extra_height + spacer_cone_height;

nozzle_size = 0.4;
/******************************************************************************
 *  Top-Level modules, remove the '*' from the module that should be generated
 */

*test1();
*test2();
*plate();
bottom();

/******************************************************************************
 *  Other modules
 */
module test1() {
	translate([0, 0, 2]) cube([12, 12, 4], center = true);
	translate([0, 0, 4]) hole(x = 0, y = 0, r = 0);
}

module test2() {
	difference() {
		bottom();
		translate([-50, 40, 0]) cube([400, 200, 200], center = true);
		translate([120, 60, 122]) cube([130, 200, 200], center = true);
	}
}

module spacer(x, y, r) {
	d = 10;
	h = nut_height + spacer_extra_height;
	ir = (nut_diameter / 2) / (2 * tan(180 / 6));
	nut_offset = 1;

	xx = sqrt(pow(d / 2, 2) - pow(ir, 2));
	translate([x, y, 0]) rotate([0, 0, r]) {
		difference() {
			union() {
				cylinder(r = d / 2, h = h);
				translate([0, 0, h]) cylinder(r1 = d / 2, r2 = screw_diameter / 2 + nozzle_size, h = spacer_cone_height);
			}
			translate([0, 0, -1]) cylinder(r = screw_diameter / 2, h = h + 100);
			translate([0, 0, nut_offset + nut_height]) cylinder(r1 = ir - nozzle_size, r = screw_diameter / 2, h = 0.3);
			translate([0, 0, nut_offset]) cylinder(r = nut_diameter / 2, h = nut_height, $fn = 6);
			translate([50, 0, nut_height / 2 + nut_offset]) cube([100, 2 * ir, nut_height], center = true);
			difference() {
				translate([xx, 0, 0]) rotate([0, -45, 0]) translate([50, 0, nut_height / 2 + nut_offset]) cube([100, 2 * ir, nut_height], center = true);
				translate([0, 0, nut_offset]) cube([100, 2 * ir, nut_height], center = true);
			}
		}
	}
}

module base(ew, ed, ef) {
	union() {
		difference() {
			translate([-ew / 2, -ed / 2 - ef, 0]) cube([width + ew, depth + ed + ef, wall]);
			for (a = [10 : 10 : width / 2 - 15]) {
				translate([a + 1, 10, -1]) cube([6, depth - 20, wall + 2]);
			}
			for (a = [10 : 10 : width / 2 - 5]) {
				translate([width - a - 7, 10, -1]) cube([6, depth - 20, wall + 2]);
			}
		}
		translate([0, 0, wall]) {
			spacer(x = h1_x, y = h1_y, r = 0);
			spacer(x = h2_x, y = h2_y, r = 180);
			spacer(x = h3_x, y = h3_y, r = 0);
			spacer(x = h4_x, y = h4_y, r = 180);
			spacer(x = h5_x, y = h5_y, r = 90);
			spacer(x = h6_x, y = h6_y, r = 90);
		}
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

logo_width = 100;
logo_height = 22;
module hive_logo(wall, h) {
	cube([logo_width, logo_height, wall]);
	color("black") {
		translate([logo_width / 200 * 27, logo_height / 48 * 22, 0]) scale([logo_width / 200, 0.8 * logo_width / 200, 1]) logo(h = wall + h);
		translate([logo_width / 200 * 65, logo_height / 48 * 8, 0]) scale([logo_height / 48, 0.8 * logo_height / 48, 1]) hive(h = wall + h);
	}
}

module plate() {
	base(ew = 0, ed = 0);
	translate([30, 20, 0]) hive_logo(wall = wall, h = 2);
}

module phone_connector(x, z_base) {
	translate([x, 0, z_base + 4.7]) rotate([90, 0, 0]) cylinder(r = 5, h = 10, center = true);
}

module video_connector(x, z_base) {
	translate([x, 0, z_base + 8.2]) rotate([90, 0, 0]) cylinder(r = 5.5, h = 10, center = true);
}

module ps2_connector(x, z_base) {
	translate([x, 0, z_base + 8.2]) rotate([90, 0, 0]) cylinder(r = 6.6, h = 10, center = true);
}

module vga_connector(x, z_base) {
	translate([x, 0, z_base + 8.2]) rotate([90, 0, 0]) {
		hull() {
			translate([13, 0, 0]) cylinder(r = 3.2, h = 10, center = true);
			translate([-13, 0, 0]) cylinder(r = 3.2, h = 10, center = true);
		}
		hull() {
			translate([9, 4.5, 0]) cylinder(r = 1, h = 10, center = true);
			translate([-9, 4.5, 0]) cylinder(r = 1, h = 10, center = true);
			translate([7.5, -4.5, 0]) cylinder(r = 1, h = 10, center = true);
			translate([-7.5, -4.5, 0]) cylinder(r = 1, h = 10, center = true);
		}
	}
}

module network_connector(x, z_base) {
	h = 12.5;
	translate([x, 0, z_base + 1.6 + h / 2]) rotate([90, 0, 0]) cube([14, h, 10], center = true);
}

module power_connector(x, z_base) {
	translate([x, 0, z_base + 8.2]) rotate([90, 0, 0]) cylinder(r = 5.5, h = 10, center = true);
}

module reset_connector(x, z_base) {
	translate([x, 0, z_base + 5.7]) rotate([90, 0, 0]) cylinder(r = 2.5, h = 10, center = true);
}

module sd_connector(x, z_base) {
	h = 3.2;
	translate([x, 0, z_base + 1.6 + h / 2]) rotate([90, 0, 0]) cube([25.5, h, 10], center = true);
}

module usb_host_connector(x, z_base) {
	h = 4;
	translate([x, 0, z_base + 1.6 + h / 2]) rotate([90, 0, 0]) cube([11.5, h, 10], center = true);
}

module bottom() {
	ew = 10;  // extra width, distributed on both sides
	ed = 2 * wall + 2; // extra depth to both front and back
	ef = 6; // extra font depth
	h = 35;
	logo_height = 0.35;
	difference() {
		union() {
			base(ew = ew, ed = ed, ef = ef);
			// left
			translate([-ew / 2, -ed / 2 - ef, 0]) cube([wall, depth + ed + ef, h]);
			// right
			translate([width + ew / 2 - wall, -ed / 2 - ef, 0]) cube([wall, depth + ed + ef, h]);
			// front
			translate([-ew / 2, -ed / 2 - ef, 0]) cube([width + ew, wall, h]);
			translate([0, -ed / 2 + wall - ef, 4]) rotate([90, 0, 0]) hive_logo(wall = wall, h = logo_height);
			color("black") translate([width - 17, -ed / 2 -ef + logo_height, 4]) rotate([90, 0, 0]) {
				write(serial_number, t = 2 * logo_height, h = 8, space = 1.2, font = font_name);
			}
			// back
			translate([-ew / 2, depth + ed / 2 - wall]) cube([width + ew, wall, h]);
		}
		translate([0, depth + ed / 2, wall]) {
			phone_connector(x = audio_x, z_base = spacer_total_height);
			video_connector(x = video_x, z_base = spacer_total_height);
			ps2_connector(x = keyboard_ps2_x, z_base = spacer_total_height);
			ps2_connector(x = mouse_ps2_x, z_base = spacer_total_height);
			vga_connector(x = vga_x, z_base = spacer_total_height);
			network_connector(x = network_x, z_base = spacer_total_height);
			ps2_connector(x = host_ps2_x, z_base = spacer_total_height);
			power_connector(x = power_x, z_base = spacer_total_height);
			reset_connector(x = reset_x, z_base = spacer_total_height);
		}
		translate([width + ew / 2, 0, wall]) rotate([0, 0, 90]) {
			sd_connector(x = sd_y, z_base = spacer_total_height);
			usb_host_connector(x = usb_host_y, z_base = spacer_total_height);
		}
	}
}
