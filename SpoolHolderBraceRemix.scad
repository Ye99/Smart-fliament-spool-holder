// screw hole diameter in mm. no thread. 
screw_hole_diameter=4.5;

brace_wall_thickness=8;
brace_wall_width=40;
added_slab_length=7;
// distance from the screw hole, to contact edge between the added slab and original brace wall.
screw_hole_to_contact_edge_distance=2.5;

module original_object_pattern_remover() {    
    translate([-26, 4, 0])
        rotate([90, 0, 0])
            cube([25, brace_wall_width, 6]);
}

module screw_hole() {
    cylinder(d=screw_hole_diameter, h=35, center=true, $fn=50);
}

module remove_slab() {
    translate([0, 53, 0])
        rotate([90, 0, 0])
            cube([brace_wall_thickness, brace_wall_width, 15]);
}

module added_slab() {
    translate([-26, 16, brace_wall_width]) {
        rotate([-90, 0, 0])
            difference() {
                cube([brace_wall_thickness, brace_wall_width, added_slab_length]);
                translate([0, brace_wall_width/2, (screw_hole_to_contact_edge_distance)])
                    rotate([0, 90, 0])
                        screw_hole();
            }
    }
}

module brace() {
    difference() {
        union() {
            translate([0, 66, 0])
                import("SpoolHolderBrace.stl");
            
            original_object_pattern_remover();
            added_slab();
        }
        
        remove_slab();
    }
}

brace();