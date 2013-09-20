$fn = 20;

use <din.scad>
use <util.scad>
use <connector.scad>

height = 12;
wall = 2.0;
gap = 0.3;
box_radius = 2;

connector_width = 12;
connector_depth = 4;
connector_pin = 2;

snap_size = 1.3;

module pin(gap = 0) {
	translate([0, 0, -gap])
		cylinder(r1 = connector_pin + gap, r2 = connector_pin - 0.5 + gap, h = 1.5 + 2 * gap);
}

module box(din) {
	offset = l(10);
	connector_box = connector_width + 2 * connector_depth + 4 * connector_pin + 4 * wall;
	pin_offset = connector_box / 2 - connector_pin - wall;
	difference() {
		union() {
			difference() {
				roundedCube([l(din)-gap, w(din), height], box_radius, true);
				translate([wall, wall, wall]) 
					roundedCube([l(din) - 2 * wall-gap, w(din) - 2 * wall, height], box_radius, false);
			}
			for (o = [offset/2 : offset : l(din)]) {
				translate([o - pin_offset, (connector_depth + wall) / 2, height]) pin();
				translate([o + pin_offset, (connector_depth + wall) / 2, height]) pin();
				translate([o, w(din)-wall+((wall + connector_depth)/2), height]) pin();
				translate([o, w(din), 0]) connector(width = connector_width, depth = connector_depth, h = height);
				translate([o - connector_box / 2, 0, 0]) roundedCube([connector_box, connector_depth + wall, height], box_radius, true);
				
				translate([o, w(din) + connector_depth, height - wall]) rotate([45, 0, 0]) cube([5, snap_size+gap/2, snap_size+gap/2], center = true);
			}
		}
		for (o = [offset/2 : offset : l(din)]) {
			translate([o, 0, 0]) connector_cut(width = connector_width, depth = connector_depth, h = height, gap = gap);

			translate([o, connector_depth, height - wall]) rotate([45, 0, 0]) cube([6, snap_size, snap_size], center = true);
			for (oy = [0 : w(10) : w(din) - 1]) {
				#translate([o - pin_offset, oy + (connector_depth + wall) / 2, 0]) pin(gap = gap);
				translate([o + pin_offset, oy + (connector_depth + wall) / 2, 0]) pin(gap = gap);
				#translate([o, -oy + w(din)-wall+((wall + connector_depth)/2), 0]) pin(gap = gap);
			}
		}
	}	
}

box(8);
translate([0, -w(6) * 1.2, 0]) box(6);


