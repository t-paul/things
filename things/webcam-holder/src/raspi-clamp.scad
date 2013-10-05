include <MCAD/boxes.scad>

$fn = 40;

board_height = 3;
board_length = 85;
board_width = 56;
board_hole_diameter = 3.2;

board_h1_x = 25.5;
board_h1_y = 18;
board_h2_x = board_length - 5;
board_h2_y = board_width - 12.5;
board_p3_x = board_h1_x + 6;
board_p3_y = board_width - 12.5;

clamp_length = 70;
clamp_width = 15;
clamp_height = 6;
clamp_depth = 10;
clamp_support = 0.5;

nut_trap_radius = 5.5 / 2 / cos(180 / 6) + 0.05;

module clamp() {
	difference() {
		union() {
			translate([(clamp_depth + board_height)/2, clamp_width/2, 0]) {
				translate([0, 0, board_height + clamp_height/2]) roundedBox([clamp_depth + board_height, clamp_width, 2 * board_height + clamp_height], 1, false);
				translate([0, 0, board_height/2]) roundedBox([clamp_depth + board_height, clamp_width, board_height], 1, true);
			}
			translate([-1, 0, 0]) cube([clamp_depth, clamp_width, board_height]);
		}
		translate([board_height, -clamp_width/2, board_height]) cube([2 * clamp_depth, 2 * clamp_width, clamp_height]);
		translate([clamp_depth + board_height, 0, board_height]) rotate([0, 45, 0]) cube([sqrt(2), 4 * clamp_depth, sqrt(2)], center = true);
		translate([clamp_depth + board_height, 0, board_height + clamp_height]) rotate([0, 45, 0]) cube([sqrt(2), 4 * clamp_depth, sqrt(2)], center = true);
	}
	for (x = [1 : 3 : clamp_depth - 1]) {
		translate([clamp_depth + board_height - clamp_support - x, 0, 1]) cube([clamp_support, clamp_width, board_height + clamp_height]);
	}
}

module raspi_board() {
	o = board_h1_x - board_h1_y + clamp_width / 4;
	difference() {
		union() {
			//%cube([board_length, board_width, board_height]);
			translate([0, board_h2_y - clamp_width/2, 0]) cube([board_length + clamp_length, clamp_width, board_height]);
			cube([clamp_width, board_h2_y, board_height]);
			translate([board_h2_x - clamp_width/2, 0, 0]) cube([clamp_width, board_h2_y, board_height]);
			translate([o, clamp_width / 4, 0]) rotate([0, 0, -45]) translate([-clamp_width/4, 0, 0]) cube([clamp_width/2, 60, board_height]);

			translate([board_h2_x + clamp_width / 2 - o, clamp_width / 4, 0]) rotate([0, 0, 45]) translate([-clamp_width/4, 0, 0]) cube([clamp_width/2, 60, board_height]);

			translate([board_h1_x, board_h1_y, 1]) cylinder(r = 3.5, h = board_height + 5 - 1);
			translate([board_h2_x, board_h2_y, 1]) cylinder(r = 3.5, h = board_height + 5 - 1);
			translate([board_p3_x, board_p3_y, 1]) cylinder(r = 3.5, h = board_height + 5 - 1);
		}
		translate([board_h1_x, board_h1_y, 0]) {
			cylinder(r = board_hole_diameter/2, h = 20, center = true);
			rotate([0, 0, 45]) cylinder(r = nut_trap_radius, h = 4, $fn = 6, center = true);
		}
		translate([board_h2_x, board_h2_y, 0]) {
			cylinder(r = board_hole_diameter/2, h = 20, center = true);
			cylinder(r = nut_trap_radius, h = 4, $fn = 6, center = true);
		}
	}
}

raspi_board();
translate([board_length + clamp_length, board_h2_y - clamp_width/2, 0]) clamp();
rotate([0, 0, -90]) clamp();
translate([board_h2_x - clamp_width/2, 0, 0]) rotate([0, 0, -90]) clamp();
