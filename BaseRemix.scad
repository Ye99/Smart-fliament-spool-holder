// screw hole diameter in mm. no thread. 
screw_hole_diameter=4.5;

baseplate_width=40;
baseplate_length=80;


module screw_hole() {
    rotate([90, 0, 0])
        cylinder(d=screw_hole_diameter, h=35, center=true, $fn=50);
}

module base_plate() {    
    difference() {
        translate([-16, 6, 0])
                cube([baseplate_length, 6, baseplate_width]);
        
        translate([-8, 0, baseplate_width/2])
            screw_hole();
        translate([56, 0, baseplate_width/2])
            screw_hole();        
    }
}

module cut_extrusion_below_base_plate() {    
    translate([-16, -20, 0])
            cube([baseplate_length, 26, baseplate_width]);
}


module cut_bolt_holder() {    
    translate([-16, 40, -10])
        cube([16, 40, 60]);
}

difference() {
    union() {
        translate([-4, -16, 0])
            import("Base_v1.1.STL");
        
        base_plate();
    }
    
    cut_extrusion_below_base_plate();
    cut_bolt_holder();
}
