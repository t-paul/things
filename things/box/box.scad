$fn = 40;

include <MCAD/boxes.scad>

module roundedBox2(size, radius, sidesonly) {
	translate([size[0]/2, size[1]/2, size[2]/2]) roundedBox(size, radius, sidesonly);
}

width = 20;
depth = 4;
height = 100;

module cut(gap, height) {
	offset = 0.2;
	difference() {
		translate([-width / 2, 0, 0]) cube([width, depth+gap, height]);
		translate([width / 2 + 1, depth + 1 - offset - gap, 0]) rotate([0, 0, -45]) translate([0, -3 * width, -1]) cube([3 * width, 3 * width, 2 * height]);

		translate([-width / 2 - 1, depth + 1 - offset - gap, 0]) rotate([0, 0, -45]) translate([0, -3 * width, -1]) cube([3 * width, 3 * width, 2 * height]);
	}

}

h = 30;
wall = 2;
length = 100;

module connector() {
	cylinder(r1 = 2.5, r2 = 1.5, h = 2);
}

difference() {
	union() {
//#translate([length - 3, 3, h]) connector();
//#translate([25, 75, h]) connector();
//#translate([length - 3, 3, h]) connector();
		translate([25 - width / 2 - wall, 0, 0]) cube([width+2*wall, depth +wall, h]);
		translate([length- (25+width/2+wall), 0, 0]) cube([25+width/2+wall, depth+wall, h]);
	}
	translate([25, -0.05, -1]) cut(0.5, height);
	translate([length-25, -0.05, -1]) cut(0.5, height);
}

difference() {
	difference() {
		union() {
			cube([length, 75, h]);
			translate([25, 75, 0]) cut(0, h);
			translate([length-25, 75, 0]) cut(0, h);
		}
		translate([25, -0.05, -1]) cut(0.5, height);
		translate([length-25, -0.05, -1]) cut(0.5, height);
	}
	translate([wall, wall, wall]) roundedBox2([100 - 2 * wall, 75 - 2 * wall, h], 2, false);
	translate([-wall, wall, wall + 10]) cube([3 * wall, 75 - 2 * wall, h], 2, false);
	translate([0, -wall, wall + 15]) rotate([0, -45, 0]) cube([30, 75 + 2 * wall, h], 2, false);
}	



