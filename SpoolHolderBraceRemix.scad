// screw hole diameter in mm. no thread. 
screw_hole_diameter=4.5;
    
module original_object_pattern_remover() {    
    translate([-26, 4, 0])
        rotate([90, 0, 0])
            cube([25, 40, 6]);
}

module screw_hole() {
    cylinder(d=screw_hole_diameter, h=35, center=true, $fn=50);
}

module enhance_slab() {
    cube([8, 40, 3]);
}

module brace() {
    difference() {
        union() {
            translate([0, 66, 0])
                import("SpoolHolderBrace.stl");
            
            original_object_pattern_remover();
            
            translate([0, 48, 0])
                rotate([90, 0, 0])
                    enhance_slab();
        }

        translate([10, 41, 20])
            rotate([0, 90, 0])
                screw_hole();
    }
}

brace();