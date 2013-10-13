/*********************************************************************************************
 *  Minty Boost Case
 *  (c) 2013 Torsten Paul <Torsten.Paul@gmx.de>
 *  License: CC-BY-SA 3.0
 */

/*********************************************************************************************
 *  Definitions
 */

$fn = 50;

use <util.scad>
use <lock.scad>

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

lid_height = 1;
lid_lock_angle = 3;
lid_lock_height = 3;
lid_lock_width = 2;
lid_lock_length = 5;
lid_lock_wall = 2;

lock_post_thickness = 3;
usb_post_width = 12;
usb_post_height = 7.8;
usb_post_offset = -2;
ic_post_width = 6;
ic_post_height = 7;
ic_post_offset = 10;

w2 = 2 * wall;

/*********************************************************************************************
 *  Top-Level modules, remove the '*' from the module that should be generated
 */

*lid();
*base();
plate();
*assembly();

/*********************************************************************************************
 *  Other modules
 */

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
	
	// Lid lock
	translate([wall + 12, width + wall, height + wall]) lock(length = lid_lock_length, width = lid_lock_width, height = lid_lock_height, angle = lid_lock_angle);
	translate([length / 2, width + wall, height + wall]) lock(length = lid_lock_length, width = lid_lock_width, height = lid_lock_height, angle = lid_lock_angle);
	translate([length - pcb_length, width + wall, height + wall]) lock(length = lid_lock_length, width = lid_lock_width, height = lid_lock_height, angle = lid_lock_angle);
	translate([wall + 12, wall, height + wall]) mirror([0, 1, 0]) lock(length = lid_lock_length, width = lid_lock_width, height = lid_lock_height, angle = lid_lock_angle);
	translate([length / 2, wall, height + wall]) mirror([0, 1, 0]) lock(length = lid_lock_length, width = lid_lock_width, height = lid_lock_height, angle = lid_lock_angle);
	translate([length - pcb_length, wall, height + wall]) mirror([0, 1, 0]) lock(length = lid_lock_length, width = lid_lock_width, height = lid_lock_height, angle = lid_lock_angle);

	// Battery holder
	translate([usb_x + pcb_length, wall - gap, 0]) cube([5, width + 2 * gap, usb_z + wall + 4]);
	translate([usb_x + pcb_length + battery_length + 5, width + wall - 8 - gap, 0]) cube([5, 8 + gap, usb_z + wall + 4]);
	translate([usb_x + pcb_length + battery_length + 5, wall - gap, 0]) cube([5, 8 + gap, usb_z + wall + 4]);

	// PCB post
	translate([usb_x - 0.5, width / 2 - 2.5 + wall, 0]) cube([3, 5, usb_z + wall]);
	translate([usb_x + pcb_length - 3, wall + width - gap - 6, 0]) cube([5, 2, usb_z + wall]);
	translate([usb_x + pcb_length - 9, wall - gap , 0]) cube([3, 3 + gap, usb_z + wall]);

	// USB connector post
	translate([usb_x - 4.5, width / 2 - usb_width / 2 + wall, usb_z + wall - gap]) cube([2, usb_width, 2.4 + gap]);
}

module lid() {
    rotate([180, 0, 0]) lid_rotated();  
}

module lid_rotated() {
    roundedCube([length + w2, width + w2, lid_height], 5, true);

    translate([wall + length - lid_height, width / 2 + wall, 0])  rotate([-90, 0, 0]) cylinder(r = lid_height, h = 0.6 * width, center = true);

    // lock posts
    for (v = [wall + 12, length / 2, length - pcb_length]) {
        translate([v, width + wall, 0]) lock_post(length = lid_lock_length, width = lid_lock_width, height = lid_lock_height, angle = lid_lock_angle, wall = lid_lock_wall);
        translate([v, wall, 0]) mirror([0, 1, 0]) lock_post(length = lid_lock_length, width = lid_lock_width, height = lid_lock_height, angle = lid_lock_angle, wall = lid_lock_wall);
    }

    // posts over the USB plug and regulator IC
    for (v = [[usb_post_width, usb_post_height, usb_post_offset], [ic_post_width, ic_post_height, ic_post_offset]]) {
        translate([usb_x + v[2], 0, 0]) {
            translate([0, width / 2 - v[0] / 2 + wall, -v[1] + 1]) cube([lock_post_thickness, v[0], v[1] - lock_post_thickness/2 + gap]);
            translate([lock_post_thickness/2, width / 2 + wall, -v[1] + lock_post_thickness/2]) rotate([90, 0, 0]) cylinder(r = lock_post_thickness/2, h = v[0], center = true);
            difference() {
                translate([-lock_post_thickness, width / 2 - v[0] / 2 + wall, -2]) cube([3 * lock_post_thickness, v[0], 2 + gap]);
                translate([2 * lock_post_thickness, width / 2 + wall, -lock_post_thickness]) rotate([90, 0, 0]) cylinder(r = lock_post_thickness, h = v[0] + 2, center = true);
                translate([-lock_post_thickness, width / 2 + wall, -lock_post_thickness]) rotate([90, 0, 0]) cylinder(r = lock_post_thickness, h = v[0] + 2, center = true);
            }
        }
    }
}

module assembly() {
    translate([0, 0, 2 * height]) lid_rotated();
    base();
}

module plate() {
    translate([0, -10, lid_height]) lid();
    translate([0, 10, 0]) base();
}