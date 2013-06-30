/*********************************************************************************************
 *  Single Object Bag Clip
 *  (c) 2013 Torsten Paul <Torsten.Paul@gmx.de>
 *  License: CC-BY-SA 3.0
 */
$fn = 60;
base_fn = 200;

height = 9;
outer_radius = 160;
outer_thickness = 2.8;
inner_thickness = 3;
gap = 0.3;
length = 80;
scale = 2;
clamp_angle = 20;


angle = 360 / (2 * PI * outer_radius / length);
inner_radius = outer_radius - outer_thickness - gap;

module base(r, thickness) {
	difference() {
		cylinder($fn = base_fn, r = r, h = height);
		translate([0, 0, -1]) cylinder($fn = base_fn, r = r - thickness, h = height + 2);
	}
} 

module clamp() {
	difference() {
		union() {
			difference() {
				cylinder(r = inner_thickness / 2 + gap + outer_thickness, h = height);
				translate([0, 0, -1]) {
					cylinder(r = inner_thickness / 2 + gap, h = height + 2);
					rotate([0, 0, -angle + 5]) translate([-outer_radius - 1, 0, 0]) cube([2 * outer_radius + 2, 2 * outer_radius + 2, 3 * height], center = true);
					rotate([0, 0, -angle + clamp_angle]) translate([-outer_radius - 1, 0, 0]) cube([2 * outer_radius + 2, 2 * outer_radius + 2, 3 * height], center = true);
				}
			}
			translate([-(inner_thickness + gap) * sin(angle - clamp_angle), -(inner_thickness + gap) * cos(angle - clamp_angle), 0]) cylinder(r = outer_thickness / 2, h = height);
		}
		translate([0, 0, -gap]) cylinder(r2 = 0, r1 = inner_thickness / 2 + 3 * gap, h = inner_thickness / 2 + 3 * gap);
		translate([0, 0, height - inner_thickness / 2 - 2 * gap]) cylinder(r1 = 0, r2 = inner_thickness / 2 + 3 * gap, h = inner_thickness / 2 + 3 * gap);
	}
}

module cut() {
	translate([-outer_radius - 1, 0, 0]) cube([2 * outer_radius + 2, 2 * outer_radius + 2, 3 * height], center = true);
	rotate([0, 0, -angle]) translate([+outer_radius + 1, 0, 0]) cube([2 * outer_radius + 2, 2 * outer_radius + 2, 3 * height], center = true);
}

module outer_arm() {
	render() difference() {
		base(outer_radius, outer_thickness);
		cut();
		cylinder($fn = base_fn, r2 = 0, r1 = outer_radius - outer_thickness + gap, h = outer_radius);
		translate([0, 0, -outer_radius + height]) cylinder($fn = base_fn, r1 = 0, r2 = outer_radius - outer_thickness + gap, h = outer_radius);
	}
	translate([(inner_radius - inner_thickness / 2) * sin(angle), (inner_radius - inner_thickness / 2) * cos(angle), 0]) {
		clamp();
	}
}

module inner_arm() {
	difference() {
		base(inner_radius, inner_thickness);
		cut();
	}
	translate([(inner_radius - inner_thickness / 2) * sin(angle), (inner_radius - inner_thickness / 2) * cos(angle), 0]) cylinder(r = inner_thickness / 2, h = height);
}

module inner_cylinder(r_extra = 0, h_extra = 0) {
	translate([0, 0, -h_extra]) cylinder(r1 = r_extra + inner_thickness / 2, r2 = r_extra + (inner_thickness * scale) / 2, h = height / 2 + h_extra);
	translate([0, 0, height / 2]) cylinder(r1 = r_extra + (inner_thickness * scale) / 2, r2 = r_extra + inner_thickness / 2, h = height / 2 + h_extra);
}

module inner_clip() {
	difference() {
		translate([0, -outer_radius + (inner_thickness / 2 + gap + outer_thickness), 0]) inner_arm();
		translate([0, 0, height / 2 + 4 * height / 16 - 2 * gap]) cylinder(r = inner_thickness / 2 + 3 * gap + outer_thickness, h = height);
		translate([0, 0, -height / 2 - 4 * height / 16 + 2 * gap]) cylinder(r = inner_thickness / 2 + 3 * gap + outer_thickness, h = height);
	}
	inner_cylinder();
	hull() {
		translate([0, -inner_thickness / 2, height / 2])
			sphere(r = height / 4 - 2 * gap);
		translate([inner_thickness + outer_thickness, -inner_thickness / 2, height / 2])
			sphere(r = height / 4 - 2 * gap);
	}
}

module outer_clip() {
	difference() {
		union() {
			translate([0, -outer_radius + (inner_thickness / 2 + gap + outer_thickness), 0]) outer_arm();
			difference() {
				cylinder(r = inner_thickness / 2 + gap + outer_thickness, h = height);
				// using gap as x translation to prevent non-manifold object
				translate([gap, -2 * outer_thickness, height / 2 - 4 * height / 16]) cube([4 * outer_thickness, 4 * outer_thickness, 4 * height / 8]);
				translate([-2 * outer_thickness, -4 * outer_thickness + inner_thickness / 2, height / 2 - 4 * height / 16]) cube([4 * outer_thickness, 4 * outer_thickness, 4 * height / 8]);
				rotate([0, 0, -45]) translate([-2 * outer_thickness, -4 * outer_thickness + inner_thickness / 2, height / 2 - 4 * height / 16]) cube([4 * outer_thickness, 4 * outer_thickness, 4 * height / 8]);
			}
		}
		inner_cylinder(r_extra = 2 * gap / 3, h_extra = 1);
		translate([0, 0, -gap]) cylinder(r1 = inner_thickness / 2 + 3 * gap, r2 = 0, h = inner_thickness / 2 + 3 * gap);
		translate([0, 0, height - inner_thickness / 2 - 2 * gap]) cylinder(r2 = inner_thickness / 2 + 3 * gap, r1 = 0, h = inner_thickness / 2 + 3 * gap);
	}
}

module clip() {
	translate([0, -inner_radius, 0]) {
		translate([0, outer_radius - (inner_thickness / 2 + gap + outer_thickness), 0]) {
			outer_clip();
			inner_clip();
		}
	}
}

clip();
