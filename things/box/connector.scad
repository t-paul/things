
module connector_polygon(width = 6, depth = 3, edge = 0.5, gap = 0, overlap = 0.01) {
	polygon([
		[-width/2-gap, -overlap],
		[width/2+gap, -overlap],
		[width/2+gap, edge],
		[width/2+depth-2*edge+gap, depth-edge],
		[width/2+depth-2*edge+gap, depth+gap],
		[-width/2-depth+2*edge-gap, depth+gap],
		[-width/2-depth+2*edge-gap, depth-edge],
		[-width/2-gap, edge]
	]);
}

module connector(width = 6, depth = 3, edge = 0.5, h = 1) {
	linear_extrude(height = h)
		connector_polygon(width = width, depth = depth, edge = edge, gap = 0);
}

module connector_cut(width = 6, depth = 3, edge = 0.5, gap = 0.2, h = 1) {
	translate([0, 0, -gap])
		linear_extrude(height = h + 2 * gap)
			connector_polygon(width = width, depth = depth, edge = edge, gap = gap);
}

color("green") connector();
translate([-10, 0, 0]) difference() {
	cube([20, 8, 1]);
	translate([10, 0, 0]) connector_cut(h = 1, gap = 0.1);
}

