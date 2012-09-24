/*********************************************************************************************
 *  Webcam holder for Ultimaker
 *  (c) 2012 Torsten Paul <Torsten.Paul@gmx.de>
 *  License: CC-BY-SA 3.0
 */

/*********************************************************************************************
 *  Definitions
 */

include <knurledFinishLib.scad>
include <polyScrewThread.scad>

$fn = 40;

enable_thread = 1;

resolution = PI / 2;

thread_step_height = 2.5;
thread_step_degrees = 55;
thread_outer_diameter = 15;
thread_gap = 1;

screw_head = 10;
screw_height = 15;

hole_diameter = 3.4;
hole_cap_diameter = 6.4;
hole_cap_height = 2.5;

clamp_wall = 3;
clamp_length1 = 25;
clamp_length2 = 15;
clamp_width = 8;
clamp_height = 25;

beam_width = 10;
beam_length = 30;

holder_wall = 5;
holder_height = 20;
holder_width = 40;
holder_spacing = 10;
holder_hole_diameter = 6.4;

//bolt();
//clamp_test();
//clamp();
//beam();
//holder();
assembly();

thread_x = clamp_length1 - thread_outer_diameter / 2 - 1.5 * clamp_wall;
thread_z = clamp_height / 2;

module assembly() {
	clamp();
	translate([clamp_length1 + beam_width, clamp_width / 2 + clamp_wall, 0]) {
		color("LightSteelBlue") translate([0, 0, beam_width + 5]) rotate([0, 0, 90]) beam();
		translate([0, beam_length, 0]) holder();
	}
	color("LightSteelBlue") translate([thread_x, -10, thread_z]) rotate([-90, 0, 0]) bolt();
}

module holder_base() {
		holder_length = 2 * beam_width + holder_spacing + holder_wall - (beam_width - holder_wall) / 2;

		hull() {
			cylinder(r = beam_width / 2, h = beam_width);
			translate([holder_length, 0, 0]) cylinder(r = beam_width / 2, h = beam_width);
		}
		translate([1.5 * beam_width, 0, 0]) hull() {
			cylinder(r = beam_width / 2, h = holder_height);
			translate([holder_length - 1.5 * beam_width, 0, 0]) cylinder(r = beam_width / 2, h = holder_height);
		}
		translate([2 * beam_width, holder_width + 1.5 * holder_wall, 0]) cylinder(r = holder_wall / 2, h = holder_height);
		translate([2 * beam_width, holder_width + holder_wall, 0]) cube([holder_spacing + holder_wall, holder_wall, holder_height]);
		translate([2 * beam_width + holder_spacing + holder_wall, holder_width + 1.5 * holder_wall, 0]) cylinder(r = holder_wall / 2, h = holder_height);
		translate([2 * beam_width - holder_wall / 2, 0, 0]) cube([holder_wall, holder_width + beam_width / 2 + holder_wall / 2, holder_height]);
		translate([2 * beam_width + holder_wall / 2 + holder_spacing, 0, 0]) cube([holder_wall, holder_width + beam_width / 2 + holder_wall / 2, holder_height]);
}

module holder() {
	difference() {
		holder_base();
		translate([0, 0, -1]) cylinder(r = hole_diameter / 2, h = beam_width + 2);

		translate([2 * beam_width - holder_wall / 2 - 1, holder_width / 2 + beam_width / 2, holder_height / 2]) rotate([0, 90, 0]) cylinder(r = holder_hole_diameter / 2, h = holder_spacing + 2 * holder_wall + 2);

	}
}

module bolt() {
	rotate([180, 0, 0]) {
		if (enable_thread != 0) {
		    translate([0, 0, screw_height]) knurled_cylinder(screw_head);
		    screw_thread(thread_outer_diameter, thread_step_height, thread_step_degrees, screw_height, resolution, 1);
		} else {
		    translate([0, 0, screw_height]) cylinder(r = thread_outer_diameter / 2 + 5, h = screw_head);
		    cylinder(r = thread_outer_diameter / 2, h = screw_height);
		}
	}
}

module clamp_test() {
	difference() {
		cube([20, 20, 10], center = true);
		translate([0, 0, -6]) screw_thread(thread_outer_diameter + thread_gap, thread_step_height, thread_step_degrees, 12, resolution, -2);
	}
}

module clamp_base() {
	cube([clamp_length1, clamp_wall, clamp_height]);
	translate([clamp_length1 - clamp_length2, clamp_width + clamp_wall, 0]) cube([clamp_length2, clamp_wall, clamp_height]);
	translate([clamp_length1 - clamp_wall / 2, clamp_wall / 2, 0]) cube([clamp_wall, clamp_width + clamp_wall, clamp_height]);
	translate([clamp_length1, clamp_wall / 2, 0]) cylinder(r = clamp_wall / 2, h = clamp_height);
	translate([clamp_length1, clamp_wall * 1.5 + clamp_width, 0]) cylinder(r = clamp_wall / 2, h = clamp_height);

	translate([clamp_length1 - thread_outer_diameter / 2 - 1.5 * clamp_wall, 1, clamp_height / 2]) rotate([90, 0, 0]) cylinder(r = clamp_height / 2, h = clamp_wall + 1);

	difference() {
		translate([clamp_length1 - clamp_wall, clamp_wall / 2, 0]) cube([clamp_wall, clamp_wall, clamp_height]);
		translate([clamp_length1 - clamp_wall, clamp_wall * 1.5, -1]) cylinder(r = clamp_wall / 2, h = clamp_height + 2);
	}
	difference() {
		translate([clamp_length1 - clamp_wall, clamp_wall / 2 + clamp_width, 0]) cube([clamp_wall, clamp_wall, clamp_height]);
		translate([clamp_length1 - clamp_wall, clamp_wall / 2 + clamp_width, -1]) cylinder(r = clamp_wall / 2, h = clamp_height + 2);
	}

	translate([clamp_length1 + beam_width, clamp_width / 2 + clamp_wall, 0]) {
		difference() {
			union() {
				translate([-beam_width, -beam_width /2, 0]) cube([beam_width, beam_width, beam_width]);
				cylinder(r = beam_width / 2, h = beam_width);
			}
			translate([0, 0, -1]) cylinder(r = hole_diameter / 2, h = beam_width + 2);
		}
	}
}

module beam() {
	difference() {
		hull() {
			cylinder(r = beam_width / 2, h = beam_width);
			translate([beam_length, 0, 0]) cylinder(r = beam_width / 2, h = beam_width);
		}
		translate([0, 0, -1]) cylinder(r = hole_diameter / 2, h = beam_width + 2);
		translate([beam_length, 0, -1]) cylinder(r = hole_diameter / 2, h = beam_width + 2);

		translate([0, 0, beam_width - hole_cap_height]) cylinder(r = hole_cap_diameter / 2, h = hole_cap_height + 1);
		translate([beam_length, 0, beam_width - hole_cap_height]) cylinder(r = hole_cap_diameter / 2, h = hole_cap_height + 1);
	}
}

module clamp()
{
	difference() {
		clamp_base();
		translate([thread_x, -clamp_wall, thread_z]) rotate([90, 0, 0]) rotate_extrude(convexity = 10) translate([thread_x, 0, 0]) circle(r = clamp_wall);
		if (enable_thread != 0) {
			translate([thread_x, clamp_wall, thread_z]) rotate([90, 0, 0]) screw_thread(thread_outer_diameter + thread_gap, thread_step_height, thread_step_degrees, 3 * clamp_wall, resolution, -2);
		}
	}
}

module knurled_cylinder(bnhg)
{
    k_cyl_hg=bnhg;   // Knurled cylinder height
    k_cyl_od=22.5;   // Knurled cylinder outer* diameter

    knurl_wd=3;      // Knurl polyhedron width
    knurl_hg=4;      // Knurl polyhedron height
    knurl_dp=1.5;    // Knurl polyhedron depth

    e_smooth=1;      // Cylinder ends smoothed height
    s_smooth=0;      // [ 0% - 100% ] Knurled surface smoothing amount

    knurled_cyl(k_cyl_hg, k_cyl_od, knurl_wd, knurl_hg, knurl_dp, e_smooth, s_smooth);
}
