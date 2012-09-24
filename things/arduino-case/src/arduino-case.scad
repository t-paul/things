/*********************************************************************************************
 *  Case for Arduino UNO (tested with UNO R2)
 *  (c) 2012 Torsten Paul <Torsten.Paul@gmx.de>
 *  License: CC-BY-SA 2.0
 */

/*********************************************************************************************
 *  Definitions
 */
$fn = 100;

inch = 25.4; // just for calculation

x = 2.7 * inch;
y = 2.1 * inch;

/**
 * Thickness of the top and bottom sides of the case
 */
z = 0.8;

/**
 * Diameter of the top part of the board holder pins
 */
pin_d1 = 2.8;

/**
 * Diameter of the bottom part of the board holder pins
 */
pin_d2 = 5.0;

/**
 * The thickness of the wall
 */
wall = 1.2;

/**
 * Height of the walls of the bottom case part
 */
wall_h_bottom = 16;

/**
 * Height of the walls of the top case part
 */
wall_h_top = 4;

w2 = 0.8; // additional room around the board
w3 = 0.2; // spacing for the top part to fit into the bottom part

pin1_x = 0.6 * inch;
pin1_y = 2.0 * inch + 0.3;

pin2_x = 2.6 * inch;
pin2_y = 0.3 * inch;

pin3_x = 2.6 * inch;
pin3_y = 1.4 * inch;

pin4_x = 0.55 * inch;
pin4_y = 0.10 * inch - 0.3;

/**
 * set to false to remove the upper part of the 4th pin that was introduced with the UNO
 */
include_pin_4 = true;

header1_n = 6;
header1_x = 2.6 * inch - (header1_n * 0.1 * inch);
header1_y = 0.1 * inch;

header2_n = 6;
header2_x = 1.9 * inch - (header2_n * 0.1 * inch);
header2_y = 0.1 * inch;

header3_n = 8;
header3_x = 2.6 * inch - (header3_n * 0.1 * inch);
header3_y = 2.0 * inch;

/**
 * change header4_n to 10 for the new longer connector of the UNO R3
 */
header4_n = 8;
header4_x = 1.74 * inch - (header4_n * 0.1 * inch);
header4_y = 2.0 * inch;

usb_x = 15;
usb_y = 31.9;
usb_z = 5.2;
usb_width = 12.5;

power_x = 7;
power_y = 3.5;
power_z = 5;
power_width = 10;

/**
 *  When using the bottom with holes, this are the parameters for the holes
 */
holes_percent = 60;	// size in percentage of the case width
holes_size = 3;		// width of the holes
holes_spacing = 6;	// spacing of the holes
holes_border = 10;	// leave that much space without holes

/**
 *  When using the framed bottom, this is the size of the frame, should be minimum of 5 mm.
 */
frame_size = 6;

snap_depth = 0.3;
snap_size1 = 1.2;
snap_size2 = 2.0;

/*********************************************************************************************
 *  Top-Level modules, remove the '*' from the module that should be generated
 */

*bottom();
*bottom_frame();
bottom_holes();

translate([0, -10, z]) rotate([180, 0, 0]){

*top();
*top_osh();
*top_header();
top_osh_header();

}

/*********************************************************************************************
 *  Other modules
 */
module pin(pin_x, pin_y, force_include) {
	r1 = pin_d2 / 2;
	r2 = pin_d1 / 2;
	r3 = (0.8 * pin_d1) / 2;
	h1 = 3;
	h2 = 0.5;
	h3 = 2.5;
	h4 = 1;
	translate([pin_x, pin_y, z]) cylinder(r = r1, h = h1);
	translate([pin_x, pin_y, z + h1]) cylinder(r1 = r1, r2 = r2, h = h2);
	if (force_include || include_pin_4) {
		translate([pin_x, pin_y, z + h1 + h2]) cylinder(r = r2, h3);
		translate([pin_x, pin_y, z + h1 + h2 + h3]) cylinder(r1 = r2, r2 = r3, h4);
	}
}

module wall() {
	frame_height = z + 1.5;
	translate([-w2 - wall, -w2 - wall, 0]) cube([wall, y + 2 * w2 + 2 * wall, wall_h_bottom]);
	translate([-w2 - wall, -w2 - wall, 0]) cube([2 * wall, y + 2 * w2 + 2 * wall, frame_height]);
	translate([x + w2, -w2 - wall, 0]) cube([wall, y + 2 * w2 + 2 * wall, wall_h_bottom]);
	translate([x + w2 - wall, -w2 - wall, 0]) cube([2 * wall, y + 2 * w2 + 2 * wall, frame_height]);
	translate([-w2, -w2 - wall, 0]) cube([x + 2 * w2, wall, wall_h_bottom]);
	translate([-w2, -w2 - wall, 0]) cube([x + 2 * w2, 2 * wall, frame_height]);
	translate([-w2, y + w2, 0]) cube([x + 2 * w2, wall, wall_h_bottom]);
	translate([-w2, y + w2 - wall, 0]) cube([x + 2 * w2, 2 * wall, frame_height]);
}

module snap(h, z) {
	translate([6, -w2 - snap_depth, z]) cube([4, 1, h]);
	translate([x - 6 - 4, -w2 - snap_depth, z]) cube([4, 1, h]);
	translate([6, y + w2 - 1 + snap_depth, z]) cube([4, 1, h]);
	translate([x - 6 - 4, y + w2 - 1 + snap_depth, z]) cube([4, 1, h]);
}

module bottom() {
	translate([-w2, -w2, 0]) cube([x + 2 * w2, y + 2 *w2, z]);
	difference() {
		wall();
		snap(h = snap_size2, z = wall_h_bottom - wall_h_top + snap_size1 - snap_size2 + 0.2);
		translate([-5, power_y, z  + power_z]) cube([power_x, power_width, 60]);
		translate([-5, usb_y, z  + usb_z]) cube([usb_x, usb_width, 60]);
	}
	pin(pin_x = pin1_x, pin_y = pin1_y, force_include = true);
	pin(pin_x = pin2_x, pin_y = pin2_y, force_include = true);
	pin(pin_x = pin3_x, pin_y = pin3_y, force_include = true);
	pin(pin_x = pin4_x, pin_y = pin4_y, force_include = false);
}

module bottom_frame() {
	difference() {
		bottom();
		translate([frame_size, frame_size, -1]) cube([x - 2 * frame_size, y - 2 * frame_size, z + 2]);
	}
}

module bottom_holes() {
	w = y * holes_percent / 100;
	difference() {
		bottom();
		for (a = [holes_border : holes_spacing : x - holes_border]) {
			translate([a, (y - w) / 2, -1]) cube([holes_size, w, z + 2]);
		}
	}
}

module top() {
	difference() {
		union() {
			translate([-w2 - wall, -w2 - wall, 0]) cube([x + 2 * w2 + 2 * wall, y + 2 *w2 + 2 * wall, z]);
			translate([-w2 + w3, -w2 + w3, -wall_h_top]) cube([wall, y + 2 * w2 - 2 * w3, wall_h_top]);
			translate([x + w2 - wall - w3, -w2 +w3, -wall_h_top]) cube([wall, y + 2 * w2 - 2 * w3, wall_h_top]);
			translate([-w2 + w3 + wall, y + w2 - wall - w3, -wall_h_top]) cube([x - 2 * w3 - 2 * wall + 2 * w2, wall, wall_h_top]);
			translate([-w2 + w3 + wall, -w2 + w3, -wall_h_top]) cube([x - 2 * w3 - 2 * wall + 2 * w2, wall, wall_h_top]);
			snap(h = snap_size1, z = -wall_h_top);
		}
		translate([-5, power_y, -6]) cube([power_x, power_width, 60]);
		translate([-5, usb_y, -6]) cube([usb_x, usb_width, 60]);
	}
}

module osh() {
	translate([x / 2 + 2, y / 2 - 2, -1]) linear_extrude(file = "ohw-logo.dxf", scale = 0.2, height = z + 2, convexity = 10);
}

module _header(x, y, n) {
	translate([x - 0.25, y, -2]) {
		minkowski() {
			cube([(n - 1) * 2.54 + 0.5, 0.0001, 0.0001]);
			cylinder(r = 2.54/2, h = 10);
		}
	}
}

module header() {
	_header(x = header1_x, y = header1_y, n = header1_n);
	_header(x = header2_x, y = header2_y, n = header2_n);
	_header(x = header3_x, y = header3_y, n = header3_n);
	_header(x = header4_x, y = header4_y, n = header4_n);
}

module top_osh() {
	difference() {
		top();
		osh();
	}
}

module top_header() {
	difference() {
		top();
		header();
	}
}

module top_osh_header() {
	difference() {
		top();
		osh();
		header();
	}
}
