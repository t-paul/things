$fn = 40;

use <din.scad>
use <util.scad>
use <connector.scad>

height = 30;
wall = 2.0;
gap = 0.3;
box_radius = 2;

connector_width = 12;
connector_depth = 4;
connector_pin = 2;

lid_pin = 2;
lid_offset = 1.5;
lid_height = 1.2;

snap_size = 1.3;

pin_height = 1.5;

module pin(gap = 0) {
	render()
		translate([0, 0, -gap])
			cylinder(r1 = connector_pin + gap, r2 = connector_pin - 0.5 + gap, h = pin_height + 2 * gap);
}

module lid_cut(angle, gap = 0) {
	w = lid_pin + gap;
	h = lid_height + gap;
	rotate([0, 0, angle])
		translate([0, -w / 2, 0])
			cube([5 * w, w, h]);
	cylinder(r = w / 2, h = h);
}

module box(din) {
	offset = l(10);
	connector_box = connector_width + 2 * connector_depth + 4 * connector_pin + 4 * wall;
	pin_offset = connector_box / 2 - connector_pin - wall;
	base_height = max(wall, pin_height + 1);

	echo("length = ", l(din), ", width = ", w(din));

	difference() {
		union() {
			difference() {
				roundedCube([l(din)-gap, w(din), height], box_radius, true);
				translate([wall, wall, base_height]) 
					roundedCube([l(din) - 2 * wall-gap, w(din) - 2 * wall, height], box_radius, false);
			}
			for (o = [offset/2 : offset : l(din)]) {
				translate([o - pin_offset, (connector_depth + wall) / 2, height]) pin();
				translate([o + pin_offset, (connector_depth + wall) / 2, height]) pin();
				translate([o, w(din)-wall+((wall + connector_depth)/2), height]) pin();
				translate([o, w(din), 0]) connector(width = connector_width, depth = connector_depth, h = height);
				translate([o - connector_box / 2, 0, 0]) roundedCube([connector_box, connector_depth + wall, height], box_radius, true);
				
				translate([o, w(din) + connector_depth, height - wall]) rotate([45, 0, 0]) cube([5, snap_size+gap/2, snap_size+gap/2], center = true);
				if (o < (l(din) - offset * 0.75)) {
					translate([o + offset/2 - 5, 0, wall]) cube([10, connector_depth + 2 * wall, box_radius]);
				}
			}
			translate([wall - 0.1, wall + connector_depth - 0.1, 0]) cube([l(din) - 2 * wall + 0.2, 4 * wall, base_height + box_radius]);
			translate([wall - 0.1, wall + connector_depth - 0.1, 0]) cube([4 * wall, 4 * wall, height]);
			translate([l(din) - 5 * wall - 0.1, wall + connector_depth - 0.1, 0]) cube([4 * wall, 4 * wall, height]);

		}
		// cut-out for the lid
		translate([0, 0, height - lid_height]) {
			translate([wall + box_radius - lid_offset, wall + connector_depth + box_radius - lid_offset, 0]) lid_cut(angle = 45, gap = gap);
			translate([wall + box_radius - lid_offset, w(din) - wall - box_radius + lid_offset, 0]) lid_cut(angle = -45, gap = gap);
			translate([l(din) - gap - wall - box_radius + lid_offset, wall + connector_depth + box_radius - lid_offset, 0]) lid_cut(angle = 135, gap = gap);
			translate([l(din) - gap - wall - box_radius + lid_offset, w(din) - wall - box_radius + lid_offset, 0]) lid_cut(angle = -135, gap = gap);
		}
		for (o = [offset/2 : offset : l(din)]) {
			translate([o, 0, 0]) connector_cut(width = connector_width, depth = connector_depth, h = height, gap = gap);

			translate([o, connector_depth, height - wall]) rotate([45, 0, 0]) cube([6, snap_size, snap_size], center = true);
		#	translate([o, connector_depth + wall, height - 8]) rotate([45, 0, 0]) cube([6, snap_size, snap_size], center = true);
		#	translate([o, w(din) - wall, height - 8]) rotate([45, 0, 0]) cube([6, snap_size, snap_size], center = true);
			for (oy = [0 : w(10) : w(din) - 1]) {
				translate([o - pin_offset, oy + (connector_depth + wall) / 2, 0]) pin(gap = gap);
				translate([o + pin_offset, oy + (connector_depth + wall) / 2, 0]) pin(gap = gap);
				translate([o, -oy + w(din)-wall+((wall + connector_depth)/2), 0]) pin(gap = gap);
			}
		}
		translate([wall, wall + connector_depth, base_height]) 
			roundedCube([l(din) - 2 * wall-gap, w(din) - 2 * wall - connector_depth, height], box_radius, false);
	}	
}

module right_bar(count) {
	offset = l(10);
	length = count * l(10);
	width = count * w(10);
	pin_offset = connector_box / 2 - connector_pin - wall;

	roundedCube([length - gap, 2 * wall, height], box_radius, true);
	for (o = [offset/2 : offset : length]) {
		translate([o, 2 * wall, 0]) connector(width = connector_width, depth = connector_depth, h = height);
				
		translate([o, connector_depth + 2 * wall, height - wall]) rotate([45, 0, 0]) cube([5, snap_size+gap/2, snap_size+gap/2], center = true);
	}
}

module left_bar(count) {
	offset = l(10);
	length = count * l(10);
	width = count * w(10);
	pin_offset = connector_box / 2 - connector_pin - wall;
	connector_box = connector_width + 2 * connector_depth + 4 * connector_pin + 4 * wall;

	difference() {
		roundedCube([length - gap, 2 * wall + connector_depth, height], box_radius, true);
		for (o = [offset/2 : offset : length]) {
			translate([o, 0, 0]) connector_cut(width = connector_width, depth = connector_depth, h = height, gap = gap);

			translate([o, connector_depth, height - wall]) rotate([45, 0, 0]) cube([6, snap_size, snap_size], center = true);
		}
                
	}
}

module lid_post(width, wall, height) {
	x = 2;
	translate([-width / 2, 0, 0]) roundedCube([width, wall, height], 1, true);
	hull() {
		translate([-width / 2, 0, 0]) roundedCube([width, wall, lid_height + x], 1, true);
		translate([-width / 2 - x, 0, 0]) roundedCube([width + 2 * x, wall + x, lid_height], 1, true);
	}
}

module lid(din) {
	offset = l(10);
	width = 16;
	handle_width = 10;
	handle_size = 2;

	difference() {
		union() {
			translate([wall, wall + connector_depth, 0]) {
				roundedCube([l(din) - 2 * wall-gap, w(din) - 2 * wall - connector_depth, lid_height], box_radius, true);
			}

			translate([wall + box_radius - lid_offset, wall + connector_depth + box_radius - lid_offset, 0]) lid_cut(45);
			translate([wall + box_radius - lid_offset, w(din) - wall - box_radius + lid_offset, 0]) lid_cut(-45);
			translate([l(din) - gap - wall - box_radius + lid_offset, wall + connector_depth + box_radius - lid_offset, 0]) lid_cut(135);
			translate([l(din) - gap - wall - box_radius + lid_offset, w(din) - wall - box_radius + lid_offset, 0]) lid_cut(-135);


			for (o = [offset/2 : offset : l(din)]) {
//				translate([o, wall + connector_depth + 2 * gap, lid_height]) rotate([-90, 0, 0]) cylinder(r = 2, h = w(din) - 2 * wall - connector_depth - 4 * gap);
				translate([o, connector_depth + wall + gap, 0]) {
					translate([0, 0, 8]) rotate([45, 0, 0]) cube([6, snap_size, snap_size], center = true);
					lid_post(width, wall, 10);
				}
				translate([o, w(din) - wall - gap, 0]) {
					translate([0, 0, 8]) rotate([45, 0, 0]) cube([6, snap_size, snap_size], center = true);
					rotate([0, 0, 180]) lid_post(width, wall, 10);
				}
			}
		}		
		for (o = [offset/2 : offset : l(din)]) {
			translate([o, connector_depth + wall + gap, 0]) {
				translate([0, 0, handle_size / 2]) rotate([45, 0, 0]) cube([handle_width, handle_size, handle_size], center = true);
			}
			translate([o, w(din) - wall - gap, 0]) {
				translate([0, 0, handle_size / 2]) rotate([45, 0, 0]) cube([handle_width, handle_size, handle_size], center = true);
			}
		}
	}
}

*box(9);
translate([0, 0, 0]) lid(8);
//left_bar(4);
//translate([0, -10 * wall, 0]) right_bar(4);
//translate([0, -w(6) * 1.2, 0]) box(6);


