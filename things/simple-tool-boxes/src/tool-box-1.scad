$fn = 100;

wall = 2;

difference() {
	union() {
		difference() {
			union() {
				translate([20, 45, 0]) {
					difference() {
						cylinder(r = 50, h = 40);
						translate([0, 0, wall]) cylinder(r = 50 - wall, h = 200);
					}
				}
				translate([15, -20, 0]) cylinder(r = 30, h = 80);
			}
			translate([15, -20, wall]) cylinder(r = 30 - wall, h = 200);
		}
		translate([-40, 0, 0]) cylinder(r = 40, h = 120);
	}
	translate([-40, 0, wall]) cylinder(r = 40 - wall, h = 200);
}