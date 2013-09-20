use <MCAD/boxes.scad>

// make rounded box at same position as cube()
module roundedCube(size, radius, sidesonly) {
	translate([size[0]/2, size[1]/2, size[2]/2]) roundedBox(size, radius, sidesonly);
}
