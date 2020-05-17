use <roundedCube.scad>;
use <SpoolHolderBraceRemix.scad>;

// screw hole diameter in mm. no thread. 
screw_hole_diameter=4.5;

arm_height=30;
arm_length=60;
arm_thickness=20;
arm_thickness_reduction=3;
arm_angle=14.5;

rounded_corner_radius=2;

bolt_holder_area_diameter=20;

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

module fill_original_holes() {    
    /*translate([16, 89, 70])
        rotate([-arm_angle, 0, 0])
                roundedCube([arm_thickness, arm_height, arm_length], center=true, r=rounded_corner_radius);*/
}

module spool_bracket() {
    translate([arm_thickness_reduction, 93, 24])
        rotate([arm_angle, 0, 180])
            #brace();
}

module recude_arm_thickness() {
    translate([-arm_thickness+arm_thickness_reduction, 62, 35])
        rotate([-arm_angle, 0, 0])
            cube([arm_thickness, arm_height, arm_length*1.5]);
}

module cut_bolt_holder() {    
    translate([23.5, 71.5, 12.5])
        rotate([0, -90, 0])
            cylinder(d=bolt_holder_area_diameter, h=25, center=true, $fn=50);
}

union() {
    difference() {
        union() {
            translate([-5, -16, 0])
                import("Rocker_Arm_v1.1.STL");
            fill_original_holes();
        }
        
        cut_bolt_holder();
        recude_arm_thickness();
    }
    
    #spool_bracket();
}