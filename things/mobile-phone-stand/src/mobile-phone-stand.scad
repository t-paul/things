/*********************************************************************************************
 *  Mobile Phone Stand
 *  iPhone 5 / Cable: Original Apple or Amazon Basics
 *  (c) 2013 Torsten Paul <Torsten.Paul@gmx.de>
 *  License: CC-BY-SA 3.0
 */

$fn = 80;
rotate_fn = 120;

outer_w = 16; // with cable, small 18, big one 25
outer_d = 10;
outer_h = 23; // amazon basics cable: 21.6

inner_w = 8;		// amazon basics cable: 12.5, apple 8
inner_d = 5;		// amazon basics cable: 7   , apple 5

cable_d = 4;

bend_d = 30;

add_clamp = 1;
plate_w = 65; // with cable 50, with clamp minimum 65

plate_h = 18; // small 20, big 25
plate_d = 3; // thickness of the plate, with clamp should be > 3, otherwise 2 is ok
plate_rotation = 15;
plate_overhang = 35;
plate_cutout_w = 59; // iphone5 width
plate_cutout_d = 8; // iphone5 thickness
clamp_wall = 2;

base_outer_w = 75; // small 75, big 90
base_inner_w = 65; // small 65, big 70
base_h = 5;
base_center = 40; // small 30, big 40
base_center_offset = 5;
base_scale = 1.25;

spoke_w = 3;
spoke_count = 4;


h1 = 0;			// amazon basics: 2, apple 0
h2 = h1 + 11.0;		// amazon basics: 3, apple 11

wall = outer_d - inner_d;

module shape() {
	hull() {
		translate([0, -(outer_w - outer_d) / 2]) circle(r = outer_d / 2);
		translate([0,  (outer_w - outer_d) / 2]) circle(r = outer_d / 2);
		translate([-outer_d / 4 - plate_d / 2, 0]) square([outer_d / 2 + plate_d, cable_d], center = true);
	}
}

module connector() {
	union() {
			cube([inner_w - inner_d, inner_d, outer_h], center = true);
			translate([-(inner_w - inner_d) / 2, 0, 0]) cylinder(r = inner_d / 2, h = outer_h, center = true);	
			translate([(inner_w - inner_d) / 2, 0, 0]) cylinder(r = inner_d / 2, h = outer_h, center = true);
	}
}

module bar(h) {
	hull() {
		translate([plate_w / 2 - outer_d / 2, plate_cutout_d / 2, outer_h + plate_h])
			rotate([90, 0, 180])
				cylinder(r = outer_d / 2, h = h);
		translate([-plate_w / 2 + outer_d / 2, plate_cutout_d / 2, outer_h + plate_h])
			rotate([90, 0, 180])
				cylinder(r = outer_d / 2, h = h);
	}
}

module plate() {
	difference() {
		union() {
			if (add_clamp) hull() {
				bar(h = wall / 2 + plate_d);
				translate([0, -plate_cutout_d - clamp_wall, outer_d]) bar(h = wall / 2 + plate_d + plate_cutout_d + clamp_wall);
			}

			hull() {
				bar(h = wall / 2 + plate_d);
				difference() {
					translate([0, 0, outer_h + plate_h - outer_d / 2 - plate_w / (180 / (90 - plate_overhang))]) linear_extrude(height = 0.01) rotate([0, 0, -90]) shape();
					translate([0, -outer_d / 2 + plate_cutout_d / 2, 2 * outer_h]) cube([plate_cutout_w, outer_d, 2 * outer_h], center = true);
				}
			}
		}
		translate([0, 0, 2 * outer_h]) cube([plate_cutout_w, plate_cutout_d, 2 * outer_h], center = true);

		translate([0, -plate_cutout_d / 2, plate_h + outer_d / 2]) cube([plate_cutout_w, 2 * plate_cutout_d, 2 * outer_h], center = true);

		translate([0, -plate_cutout_d / 2, outer_h + plate_h + outer_d / 2]) rotate([0, 45, 0]) cube([plate_cutout_w/sqrt(2), 2 * plate_cutout_d, plate_cutout_w/sqrt(2)], center = true);
	}
}

module top() {
	translate([0, 0, bend_d / 2 + outer_d / 2]) rotate([0, 90 + plate_rotation, 0]) translate([0, 0, -bend_d / 2]) rotate([90, 0, -90]) {
		difference() {
			union() {
				difference() {
					union() {
						linear_extrude(height = outer_h + plate_h) rotate([0, 0, -90]) shape();
						plate();
					}
					translate([0, 0, outer_h / 2 + h1]) cylinder(r = inner_d / 2, h = outer_h + 1, center = true);

					// cut-out cable duct
					translate([0, 0, outer_h / 2]) cylinder(r = cable_d / 2, h = outer_h + 2, center = true);
					translate([0, outer_d, outer_h / 2 + plate_h / 2 - inner_w / 4]) cube([cable_d, 2 * outer_d, outer_h + plate_h - inner_w / 2 + 1], center = true);

					// cut-out plate
					translate([0, -outer_h + plate_cutout_d / 2, 2 * outer_h]) cube([plate_cutout_w - 2 * clamp_wall, 2 * outer_h, 2 * outer_h], center = true);
					// cut-out connector hole
					translate([0, 0, outer_h + plate_h - inner_w / 2]) rotate([90, 90, 0]) scale([1.1, 1.1, 1]) connector();
				}
				difference() {
					     translate([0, -outer_d / 4, outer_h]) scale([1, 1, 1.5]) sphere(r = outer_d / 2);
					     translate([0, -outer_h + inner_d / 2, 2 * outer_h + 3]) cube([plate_cutout_w - 2 * clamp_wall, 2 * outer_h, 2 * outer_h], center = true);
					     translate([0, 0, 2 * outer_h]) cube([plate_cutout_w, plate_cutout_d, 2 * outer_h], center = true);
				}
			}
			// cut-out connector
			translate([0, 0, outer_h / 2 + h2]) connector();
		}
	}
}

module shaft() {
	translate([0, 0, bend_d / 2 + outer_d / 2]) rotate([90, 0, 0]) difference() {
		rotate_extrude(convexity = 10, $fn = rotate_fn) {
			difference() {
				translate([bend_d / 2, 0]) shape();
				translate([bend_d / 2 - outer_d, 0]) square([2 * outer_d, cable_d], center = true);
				translate([bend_d / 2, 0]) circle(r = cable_d / 2);
			}
		}
		translate([0, -50, -50]) cube([100, 100, 100]);
		rotate([0, 0, 90 - plate_rotation - 1]) translate([0, -50, -50]) cube([100, 100, 100]);
	}
}

module base() {
	union() {
		hull() {
			rotate([0, 90, 0]) linear_extrude(height = 0.01) translate([-outer_d / 2, 0]) shape();
			cylinder(r = base_center / 2, h = base_h);
		}

		assign(offset = base_center / 2 + base_center / 8 + base_center_offset) {
			assign(spoke_size = offset + (base_outer_w - base_inner_w) / 2 * base_scale) {

				translate([(base_inner_w * base_scale) / 2 - offset, 0, 0]) scale([base_scale, 1, 1]) difference() {
					cylinder(r = base_outer_w / 2, h = base_h);
					translate([0, 0, -1]) cylinder(r = base_inner_w / 2, h = base_h + 2);
				}
	
				intersection() {
					translate([(base_inner_w * base_scale) / 2 - offset, 0, 0]) scale([base_scale, 1, 1]) cylinder(r = base_outer_w / 2, h = base_h);
					translate([-spoke_size, 0, 0]) for (a = [spoke_size - base_center / 2 + spoke_w : (base_center - spoke_w) / (spoke_count - 1) : spoke_size + base_center / 2 + 0.1]) {
						scale([1, 0.8 / base_scale, 1]) {
							difference() {
								cylinder(r = a, h = base_h);
								translate([0, 0, -1]) cylinder(r = a - spoke_w, h = base_h + 2);
							}
						}
					}
				}
			}
		}
	}
}

module main() {
	difference() {
		union() {
			top();
			shaft();
			base();
		}
		translate([0, 0, bend_d / 2 + outer_d / 2]) rotate([90, 0, 0]) {
			hull() // hack to get the difference working for F6 rendering too :(
			rotate_extrude() {
				union() {
					translate([bend_d / 2 - outer_d, 0]) square([2 * outer_d, cable_d], center = true);
					translate([bend_d / 2, 0]) circle(r = cable_d / 2);
				}
			}
		}
	}
}

main();
