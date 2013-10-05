$fn = 50;

use <util.scad>

wall = 2;
gap = 0.2;

length = 100;
width = 35;
height = 20;

usb_width = 16;
usb_height = 8;
usb_z = 4;
usb_x = 8;

pcb_length = 18;

battery_length = 58;

switch_hole_spacing = 15;
switch_width = 8;
switch_height = 4;
switch_z = 5;

led_z = 13;
led_diameter = 3.2;

w2 = 2 * wall;

module lock() {
	difference() {
		translate([0, -4, 0]) cube([10, 4, 5]);
	#	translate([1, 0, 1]) rotate([0, -2, 0]) translate([0, -6, 0]) cube([9, 4, 2]);
	}
}

module base() {
	difference() {
		roundedCube([length + w2, width + w2, height + wall], 5, true);
		translate([wall + 20, wall, wall]) roundedCube([length - 20, width, 2 * height], 5, true);
		translate([usb_x, wall, wall]) roundedCube([length - 20, width, 2 * height], 10, true);
		translate([wall, wall, wall + usb_z]) roundedCube([length - 20, width, 2 * height], 10, true);
		translate([0, wall + width / 2, usb_height / 2 + usb_z + wall + 1]) roundedCube([20, usb_width, usb_height], 1, center = true);
		// switch
		translate([length, wall + width / 2 - switch_hole_spacing / 2, wall + switch_z]) rotate([0, 90, 0]) cylinder(r = 1.4, h = 20, center = true);
		translate([length, wall + width / 2 + switch_hole_spacing / 2, wall + switch_z]) rotate([0, 90, 0]) cylinder(r = 1.4, h = 20, center = true);
		translate([length, wall + width / 2, wall + switch_z]) cube([20, switch_width, switch_height], center = true);
		// LED
		translate([length, wall + width / 2, wall + led_z]) rotate([0, 90, 0]) cylinder(r = led_diameter / 2, h = 20, center = true);
	}
	translate([usb_x + pcb_length, wall - gap, 0]) cube([5, width + 2 * gap, usb_z + wall + 4]);
	translate([usb_x + pcb_length + battery_length + 5, wall - gap, 0]) cube([5, width + 2 * gap, usb_z + wall + 4]);

	translate([usb_x - 0.5, width / 2 - 2.5 + wall, 0]) cube([3, 5, usb_z + wall]);
	translate([usb_x + pcb_length - 3, wall + width - gap - 6, 0]) cube([5, 2, usb_z + wall]);
	translate([usb_x + pcb_length - 9, wall - gap , 0]) cube([3, 3 + gap, usb_z + wall]);
	translate([usb_x - 4.5, width / 2 - usb_width / 2 + wall, usb_z + wall - gap]) cube([2, usb_width, 2.4 + gap]);
}


//!lock();
difference() {
	base();
	//translate([usb_width + usb_x + wall + 5 + 100, 0, 0]) cube([200, 200, 200], center = true);
}
